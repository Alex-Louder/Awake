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
    
    private let kKeepAwakePrefKey = "clamawake.keepawake.enabled"
    private let kMutePrefKey = "clamawake.mute.enabled"
    
    init() {
        // Load stored preferences
        let savedKeepAwake = UserDefaults.standard.bool(forKey: kKeepAwakePrefKey)
        let savedMute = UserDefaults.standard.object(forKey: kMutePrefKey) == nil ? true : UserDefaults.standard.bool(forKey: kMutePrefKey)
        
        self.isMuteOnLidCloseEnabled = savedMute
        
        // Check actual system state from pmset -g
        let currentSystemState = powerManager.readSleepDisabledStatus()
        self.isSystemSleepDisabled = currentSystemState
        self.isKeepAwakeEnabled = currentSystemState || savedKeepAwake
        
        if currentSystemState {
            powerManager.acquirePowerAssertions()
        }
        
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
                }
            } catch {
                await MainActor.run {
                    self.isBusy = false
                    if case PowerError.authorizationCancelled = error {
                        // User cancelled auth, restore toggle state without error banner
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
        isMuteOnLidCloseEnabled.toggle()
        UserDefaults.standard.set(isMuteOnLidCloseEnabled, forKey: kMutePrefKey)
    }
    
    func refreshSystemState() {
        let currentSystemState = powerManager.readSleepDisabledStatus()
        self.isSystemSleepDisabled = currentSystemState
        self.isLidClosed = lidDetector.isLidClosed
    }
    
    // MARK: - State Handling
    
    private func handleLidChange(isClosed: Bool) {
        self.isLidClosed = isClosed
        
        if isClosed {
            // Lid closed
            if isKeepAwakeEnabled {
                // Keep computer running, sleep internal display
                powerManager.sleepDisplay()
            }
            if isMuteOnLidCloseEnabled {
                // Pause media and mute audio
                audioManager.handleLidClosed()
            }
        } else {
            // Lid opened
            if isKeepAwakeEnabled {
                // Wake display up
                powerManager.wakeDisplay()
            }
            if isMuteOnLidCloseEnabled {
                // Unmute audio
                audioManager.handleLidOpened()
            }
        }
    }
}
