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
/// and IOKit power assertions (keeping USB and services active).
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
    
    /// Sets the system-wide disablesleep setting without asking for passwords
    /// using passwordless sudoers, falling back to osascript if needed.
    func setSystemSleepDisabled(_ disabled: Bool) async throws {
        // 1. Try passwordless sudo first (runs in 1 millisecond, 0 prompts!)
        let sudoProcess = Process()
        sudoProcess.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
        sudoProcess.arguments = ["-n", "/usr/bin/pmset", "-a", "disablesleep", disabled ? "1" : "0"]
        do {
            try sudoProcess.run()
            sudoProcess.waitUntilExit()
            if sudoProcess.terminationStatus == 0 {
                if disabled {
                    self.didChangeSleepSetting = true
                    self.acquirePowerAssertions()
                } else {
                    self.releasePowerAssertions()
                    self.didChangeSleepSetting = false
                }
                return
            }
        } catch {
            // Continue to fallback
        }
        
        // 2. Fallback to osascript only if sudoers entry is not available
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
                    
                    if errorNumber == -128 {
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
        
        let reason = "Awake! Mode (USB & Services Protection)" as CFString
        
        _ = IOPMAssertionCreateWithName(
            kIOPMAssertionTypePreventSystemSleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &systemSleepAssertionID
        )
        
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
    
    // MARK: - Clean exit restoration
    
    func restoreOnQuit() {
        releasePowerAssertions()
        if didChangeSleepSetting {
            let sudoProcess = Process()
            sudoProcess.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
            sudoProcess.arguments = ["-n", "/usr/bin/pmset", "-a", "disablesleep", "0"]
            try? sudoProcess.run()
            sudoProcess.waitUntilExit()
        }
    }
}
