import Foundation
import Combine
import SwiftUI

@MainActor
final class AppViewModel: ObservableObject {
    @Published var isKeepAwakeEnabled: Bool = false
    @Published var isMuteOnLidCloseEnabled: Bool = true
    
    @Published var isLidClosed: Bool = false
    @Published var isSystemSleepDisabled: Bool = false
    @Published var isBusy: Bool = false
    @Published var errorMessage: String? = nil
    
    private let lidDetector = LidDetector()
    private let powerManager = PowerManager.shared
    private let audioManager = AudioManager.shared
    private let brightnessController = BrightnessController.shared
    
    private let kKeepAwakePrefKey = "awake.keepawake.enabled"
    private let kMutePrefKey = "awake.mute.enabled"
    
    init() {
        // Load preferences
        let savedKeepAwake = UserDefaults.standard.bool(forKey: kKeepAwakePrefKey)
        let savedMute = UserDefaults.standard.object(forKey: kMutePrefKey) == nil ? true : UserDefaults.standard.bool(forKey: kMutePrefKey)
        
        self.isMuteOnLidCloseEnabled = savedMute
        
        // Sync system state
        let currentSystemState = powerManager.readSleepDisabledStatus()
        self.isSystemSleepDisabled = currentSystemState
        
        // Respect user's explicit preference as source of truth
        if savedKeepAwake {
            self.isKeepAwakeEnabled = true
            powerManager.acquirePowerAssertions()
            if !currentSystemState {
                Task {
                    try? await powerManager.setSystemSleepDisabled(true)
                }
            }
        } else {
            self.isKeepAwakeEnabled = false
            powerManager.releasePowerAssertions()
            // Clean up any orphaned pmset state left by crashes or reboots
            if currentSystemState {
                Task {
                    try? await powerManager.setSystemSleepDisabled(false)
                }
            }
        }
        
        lidDetector.setHighFrequencyMonitoring(self.isKeepAwakeEnabled)
        self.isLidClosed = lidDetector.isLidClosed
        
        // Listen to physical lid changes
        lidDetector.onLidStateChanged = { [weak self] closed in
            Task { @MainActor [weak self] in
                self?.handleLidChange(isClosed: closed)
            }
        }
    }
    
    // MARK: - User Actions
    
    func toggleKeepAwake() {
        guard !isBusy else { return }
        let targetState = !isKeepAwakeEnabled
        isBusy = true
        errorMessage = nil
        
        Task {
            do {
                try await powerManager.setSystemSleepDisabled(targetState)
                await MainActor.run {
                    self.isKeepAwakeEnabled = targetState
                    self.isSystemSleepDisabled = targetState
                    self.isBusy = false
                    UserDefaults.standard.set(targetState, forKey: self.kKeepAwakePrefKey)
                    self.lidDetector.setHighFrequencyMonitoring(targetState)
                    
                    if !targetState {
                        // Ensure any audio assertion is released and display brightness restored immediately
                        self.audioManager.releaseAudioAssertion()
                        self.brightnessController.restoreForLidOpen()
                    }
                }
            } catch {
                await MainActor.run {
                    self.isBusy = false
                    if case PowerError.authorizationCancelled = error {
                        self.isKeepAwakeEnabled = self.powerManager.readSleepDisabledStatus()
                    } else {
                        self.errorMessage = error.localizedDescription
                        self.isKeepAwakeEnabled = self.powerManager.readSleepDisabledStatus()
                    }
                }
            }
        }
    }
    
    func toggleMuteOnLidClose() {
        guard !isBusy else { return }
        isMuteOnLidCloseEnabled.toggle()
        UserDefaults.standard.set(isMuteOnLidCloseEnabled, forKey: kMutePrefKey)
        if isMuteOnLidCloseEnabled {
            audioManager.releaseAudioAssertion()
        } else {
            audioManager.ensureUnmuted()
        }
    }
    
    func refreshSystemState() {
        let currentSystemState = powerManager.readSleepDisabledStatus()
        self.isSystemSleepDisabled = currentSystemState
        
        // Re-synchronize isKeepAwakeEnabled with system state if changed externally
        if self.isKeepAwakeEnabled != currentSystemState {
            self.isKeepAwakeEnabled = currentSystemState
            UserDefaults.standard.set(currentSystemState, forKey: self.kKeepAwakePrefKey)
        }
        
        lidDetector.checkState()
        self.isLidClosed = lidDetector.isLidClosed
    }
    
    // MARK: - State Handling
    
    private func handleLidChange(isClosed: Bool) {
        self.isLidClosed = isClosed
        
        if isClosed {
            // Lid closed
            guard isKeepAwakeEnabled else {
                // If Awake! is disabled, NEVER prevent sleep, dim screen, or hold assertions!
                audioManager.releaseAudioAssertion()
                return
            }
            
            // Refresh user activity immediately to prevent App Nap or clamshell throttle
            powerManager.refreshUserActivity()
            
            // Dim physical screen backlight without killing WindowServer framebuffer
            brightnessController.dimForLidClose()
            
            if isMuteOnLidCloseEnabled {
                // Pause media and redirect external DACs to muted speaker
                audioManager.handleLidClosed()
            } else {
                // User explicitly unchecked Shh!: Keep AirPods/audio active without muting
                audioManager.handleLidClosedWithoutMute()
            }
        } else {
            // Lid opened: Always restore display brightness and release any audio assertions
            brightnessController.restoreForLidOpen()
            audioManager.handleLidOpened()
            
            // CRUCIAL: Only refresh user activity if Awake! is ACTIVE!
            // Refreshing user activity while inactive wakes up macOS from DarkWake!
            if isKeepAwakeEnabled {
                powerManager.refreshUserActivity()
            }
        }
    }
}
