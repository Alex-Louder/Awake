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
    private var displayIdleAssertionID: IOPMAssertionID = 0
    private var diskIdleAssertionID: IOPMAssertionID = 0
    private var networkClientAssertionID: IOPMAssertionID = 0
    private var remoteUserAssertionID: IOPMAssertionID = 0
    private var processActivityToken: NSObjectProtocol?
    private var heartbeatTimer: DispatchSourceTimer?
    private var isKeepAwakeActive: Bool = false
    
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
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.starts(with: "SleepDisabled") {
                    // Split on any whitespace (including tabs \t emitted by pmset)
                    let parts = trimmed.split(whereSeparator: { $0.isWhitespace }).map { String($0) }
                    if parts.count >= 2, parts[1] == "1" {
                        return true
                    }
                    if trimmed.contains("1") {
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
        if !disabled {
            // Releasing assertions BEFORE modifying pmset guarantees
            // no background assertion keeps the machine awake if pmset succeeds.
            self.releasePowerAssertions()
        }
        
        // 1. Try passwordless sudo first (runs in 1 millisecond, 0 prompts!)
        let sudoProcess = Process()
        sudoProcess.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
        sudoProcess.arguments = ["-n", "/usr/bin/pmset", "-a", "disablesleep", disabled ? "1" : "0"]
        var sudoSucceeded = false
        do {
            try sudoProcess.run()
            sudoProcess.waitUntilExit()
            if sudoProcess.terminationStatus == 0 {
                sudoSucceeded = true
            }
        } catch {
            sudoSucceeded = false
        }
        
        if sudoSucceeded {
            if disabled {
                self.isKeepAwakeActive = true
                self.acquirePowerAssertions()
            } else {
                self.isKeepAwakeActive = false
                self.releasePowerAssertions()
            }
            return
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
                    self.isKeepAwakeActive = true
                    self.acquirePowerAssertions()
                } else {
                    self.isKeepAwakeActive = false
                    self.releasePowerAssertions()
                }
                
                continuation.resume()
            }
        }
    }
    
    // MARK: - IOKit Power Assertions
    
    func acquirePowerAssertions() {
        releasePowerAssertions()
        self.isKeepAwakeActive = true
        
        let reason = "Awake! Mode (Uninterrupted Compute & USB Protection)" as CFString
        
        // 1. Prevent System Sleep
        _ = IOPMAssertionCreateWithName(
            kIOPMAssertionTypePreventSystemSleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &systemSleepAssertionID
        )
        
        // 2. Prevent User Idle Sleep
        _ = IOPMAssertionCreateWithName(
            kIOPMAssertionTypePreventUserIdleSystemSleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason,
            &userIdleAssertionID
        )
        
        // 3. Prevent Display Sleep (Keeps WindowServer framebuffer live & prevents clamshell sleep)
        let displayReason = "Awake! Virtual Framebuffer & Network Keep-Alive" as CFString
        _ = IOPMAssertionCreateWithName(
            kIOPMAssertionTypePreventUserIdleDisplaySleep as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            displayReason,
            &displayIdleAssertionID
        )
        
        // 4. Prevent Disk Idle (Prevents internal/external SSDs from spinning down or throttling large downloads)
        let diskReason = "Awake! High-Speed Disk I/O & Download Protection" as CFString
        _ = IOPMAssertionCreateWithName(
            "PreventDiskIdle" as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            diskReason,
            &diskIdleAssertionID
        )
        
        // 5. Network Client Active (Keeps Wi-Fi card fully powered in D0 state, answering ARP, mDNS, Chrome downloads, SSH)
        let netReason = "Awake! Remote Desktop & Headless Stream" as CFString
        _ = IOPMAssertionCreateWithName(
            "NetworkClientActive" as CFString,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            netReason,
            &networkClientAssertionID
        )
        
        // 6. NSProcessInfo activity assertion (exempts process from macOS App Nap and latency throttling)
        if processActivityToken == nil {
            processActivityToken = ProcessInfo.processInfo.beginActivity(
                options: [.userInitiated, .idleSystemSleepDisabled, .latencyCritical],
                reason: "Awake! Uninterrupted Compute & Download Protection"
            )
        }
        
        // 7. Start continuous Keep-Alive Heartbeat (declares user activity every 30s to keep DeclUser active)
        startHeartbeat()
    }
    
    /// Periodically signals user activity to macOS IOKit power management so DeclUser never times out,
    /// preventing App Nap from throttling background browser downloads or closing sockets.
    /// CRUCIAL: Only executes if Awake! is currently ACTIVE, preventing DarkWake-to-FullWake bugs!
    func refreshUserActivity() {
        guard isKeepAwakeActive else { return }
        
        _ = IOPMAssertionDeclareUserActivity(
            "Awake! Continuous Compute & Download Guard" as CFString,
            kIOPMUserActiveLocal,
            &remoteUserAssertionID
        )
    }
    
    private func startHeartbeat() {
        stopHeartbeat()
        guard isKeepAwakeActive else { return }
        
        // Immediate initial refresh
        refreshUserActivity()
        
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global(qos: .userInitiated))
        timer.schedule(deadline: .now() + 30.0, repeating: 30.0, leeway: .seconds(2))
        timer.setEventHandler { [weak self] in
            guard let self = self, self.isKeepAwakeActive else { return }
            self.refreshUserActivity()
        }
        timer.resume()
        self.heartbeatTimer = timer
    }
    
    private func stopHeartbeat() {
        heartbeatTimer?.cancel()
        heartbeatTimer = nil
    }
    
    func releasePowerAssertions() {
        isKeepAwakeActive = false
        stopHeartbeat()
        
        if let token = processActivityToken {
            ProcessInfo.processInfo.endActivity(token)
            processActivityToken = nil
        }
        if systemSleepAssertionID != 0 {
            IOPMAssertionRelease(systemSleepAssertionID)
            systemSleepAssertionID = 0
        }
        if userIdleAssertionID != 0 {
            IOPMAssertionRelease(userIdleAssertionID)
            userIdleAssertionID = 0
        }
        if displayIdleAssertionID != 0 {
            IOPMAssertionRelease(displayIdleAssertionID)
            displayIdleAssertionID = 0
        }
        if diskIdleAssertionID != 0 {
            IOPMAssertionRelease(diskIdleAssertionID)
            diskIdleAssertionID = 0
        }
        if networkClientAssertionID != 0 {
            IOPMAssertionRelease(networkClientAssertionID)
            networkClientAssertionID = 0
        }
        if remoteUserAssertionID != 0 {
            IOPMAssertionRelease(remoteUserAssertionID)
            remoteUserAssertionID = 0
        }
        AudioManager.shared.releaseAudioAssertion()
    }
    
    // MARK: - Passwordless sudo status & setup
    
    /// Checks whether passwordless pmset sudo is configured and functional
    func isPasswordlessSudoConfigured() -> Bool {
        let currentStatus = readSleepDisabledStatus() ? "1" : "0"
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
        process.arguments = ["-n", "/usr/bin/pmset", "-a", "disablesleep", currentStatus]
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
    
    /// Configures passwordless sudo for pmset disablesleep by asking administrator privileges once.
    func setupPasswordlessSudo() async throws {
        let userName = NSUserName()
        let rule = "\(userName) ALL=(ALL) NOPASSWD: /usr/bin/pmset -a disablesleep *"
        let script = "do shell script \"echo '\(rule)' > /etc/sudoers.d/awake && chmod 0440 /etc/sudoers.d/awake\" with administrator privileges"
        
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
                    if errorNumber == -128 {
                        continuation.resume(throwing: PowerError.authorizationCancelled)
                    } else {
                        let brief = error[NSAppleScript.errorBriefMessage] as? String ?? "Error desconocido"
                        continuation.resume(throwing: PowerError.commandFailed(brief))
                    }
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    // MARK: - Clean exit restoration
    
    /// Restores system power settings to default when quitting.
    /// Always forces disablesleep to 0 if sleep is currently disabled.
    func restoreOnQuit() {
        releasePowerAssertions()
        if readSleepDisabledStatus() || isKeepAwakeActive {
            let sudoProcess = Process()
            sudoProcess.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
            sudoProcess.arguments = ["-n", "/usr/bin/pmset", "-a", "disablesleep", "0"]
            try? sudoProcess.run()
            sudoProcess.waitUntilExit()
        }
    }
}
