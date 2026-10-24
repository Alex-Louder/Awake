import Foundation
import IOKit.pwr_mgt

enum PowerError: LocalizedError {
    case authorizationCancelled
    case commandFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .authorizationCancelled:
            return "Se canceló la autorización de administrador."
        case .commandFailed(let msg):
            return msg
        }
    }
}

/// Manages system sleep prevention, pmset disablesleep state,
/// IOKit power assertions, and display sleep/wake states.
final class PowerManager: @unchecked Sendable {
    static let shared = PowerManager()
    
    private var systemSleepAssertionID: IOPMAssertionID = 0
    private var userIdleAssertionID: IOPMAssertionID = 0
    private var didChangeSleepSetting: Bool = false
    
    private init() {}
    
    // MARK: - pmset disablesleep control
    
    /// Reads the current system-wide SleepDisabled status from pmset -g.
    func readSleepDisabledStatus() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        process.arguments = ["-g"]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = FileHandle.nullDevice
        
        do {
            try process.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            process.waitUntilExit()
            let output = String(decoding: data, as: UTF8.self)
            
            for line in output.components(separatedBy: .newlines) {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.starts(with: "SleepDisabled") {
                    let parts = trimmed.split(separator: " ").map { String($0) }
                    if parts.count >= 2, parts[1] == "1" {
                        return true
                    }
                }
            }
        } catch {
            return false
        }
        return false
    }
    
    /// Sets the system-wide disablesleep setting using macOS administrator authorization.
    func setSystemSleepDisabled(_ disabled: Bool) async throws {
        let command = "/usr/bin/pmset -a disablesleep \(disabled ? 1 : 0)"
        let script = "do shell script \"\(command)\" with administrator privileges"
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                var errorDict: NSDictionary?
                guard let appleScript = NSAppleScript(source: script) else {
                    continuation.resume(throwing: PowerError.commandFailed("No se pudo inicializar AppleScript."))
                    return
                }
                
                appleScript.executeAndReturnError(&errorDict)
                
                if let error = errorDict {
                    let errorNumber = error[NSAppleScript.errorNumber] as? Int ?? 0
                    let errorBrief = error[NSAppleScript.errorBriefMessage] as? String ?? "Error desconocido"
                    
                    if errorNumber == -128 { // User cancelled the dialog
                        continuation.resume(throwing: PowerError.authorizationCancelled)
                    } else {
                        continuation.resume(throwing: PowerError.commandFailed(errorBrief))
                    }
                    return
                }
                
                if disabled {
                    self.didChangeSleepSetting = true
                    self.acquirePowerAssertions()
                } else {
                    self.releasePowerAssertions()
                    self.didChangeSleepSetting = false
                }
                
                continuation.resume()
            }
        }
    }
    
    // MARK: - IOKit Power Assertions
    
    func acquirePowerAssertions() {
        releasePowerAssertions()
        
        let reason = "ClamAwake Clamshell Mode (USB & Services Protection)" as CFString
        
        // Prevent system from going to sleep
        _ = IOPMAssertionCreateWithName(
            kIOPMAssertionTypePreventSystemSleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &systemSleepAssertionID
        )
        
        // Prevent user idle sleep
        _ = IOPMAssertionCreateWithName(
            kIOPMAssertionTypePreventUserIdleSystemSleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &userIdleAssertionID
        )
    }
    
    func releasePowerAssertions() {
        if systemSleepAssertionID != 0 {
            IOPMAssertionRelease(systemSleepAssertionID)
            systemSleepAssertionID = 0
        }
        if userIdleAssertionID != 0 {
            IOPMAssertionRelease(userIdleAssertionID)
            userIdleAssertionID = 0
        }
    }
    
    // MARK: - Display Power Sleep / Wake
    
    /// Turns off the internal screen while the laptop is closed to save battery and prevent heat.
    func sleepDisplay() {
        DispatchQueue.global(qos: .utility).async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
            process.arguments = ["displaysleepnow"]
            try? process.run()
            process.waitUntilExit()
        }
    }
    
    /// Wakes up the display immediately when the laptop lid is reopened.
    func wakeDisplay() {
        DispatchQueue.global(qos: .utility).async {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
            process.arguments = ["-u", "-t", "1"]
            try? process.run()
            process.waitUntilExit()
        }
    }
    
    // MARK: - Clean exit restoration
    
    func restoreOnQuit() {
        releasePowerAssertions()
        if didChangeSleepSetting {
            // Restore default sleep mode synchronously on exit
            let command = "/usr/bin/pmset -a disablesleep 0"
            let script = "do shell script \"\(command)\" with administrator privileges"
            var error: NSDictionary?
            if let appleScript = NSAppleScript(source: script) {
                _ = appleScript.executeAndReturnError(&error)
            }
        }
    }
}
