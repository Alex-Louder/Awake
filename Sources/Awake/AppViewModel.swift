import Foundation
import Combine
import SwiftUI
import ServiceManagement

@MainActor
final class AppViewModel: ObservableObject {
    @Published var isKeepAwakeEnabled: Bool = false
    @Published var isMuteOnLidCloseEnabled: Bool = true
    @Published var preventScreenSleep: Bool = true
    @Published var leftClickToggles: Bool = true
    @Published var isLaunchAtLoginEnabled: Bool = false
    
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
    private let kPreventScreenPrefKey = "awake.preventscreen.enabled"
    private let kLeftClickPrefKey = "awake.leftclick.enabled"
    
    init() {
        // Load preferences
        let savedKeepAwake = UserDefaults.standard.bool(forKey: kKeepAwakePrefKey)
        let savedMute = UserDefaults.standard.object(forKey: kMutePrefKey) == nil ? true : UserDefaults.standard.bool(forKey: kMutePrefKey)
        let savedScreen = UserDefaults.standard.object(forKey: kPreventScreenPrefKey) == nil ? true : UserDefaults.standard.bool(forKey: kPreventScreenPrefKey)
        let savedLeftClick = UserDefaults.standard.object(forKey: kLeftClickPrefKey) == nil ? true : UserDefaults.standard.bool(forKey: kLeftClickPrefKey)
        
        self.isMuteOnLidCloseEnabled = savedMute
        self.preventScreenSleep = savedScreen
        self.leftClickToggles = savedLeftClick
        
        if #available(macOS 13.0, *) {
            self.isLaunchAtLoginEnabled = SMAppService.mainApp.status == .enabled
        }
        
        // Sync system state
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
    
    func togglePreventScreenSleep() {
        preventScreenSleep.toggle()
        UserDefaults.standard.set(preventScreenSleep, forKey: kPreventScreenPrefKey)
    }
    
    func toggleLeftClickMode() {
        leftClickToggles.toggle()
        UserDefaults.standard.set(leftClickToggles, forKey: kLeftClickPrefKey)
    }
    
    func toggleLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            do {
                if SMAppService.mainApp.status == .enabled {
                    try SMAppService.mainApp.unregister()
                    isLaunchAtLoginEnabled = false
                } else {
                    try SMAppService.mainApp.register()
                    isLaunchAtLoginEnabled = true
                }
            } catch {
                errorMessage = "No se pudo cambiar el inicio automático: \(error.localizedDescription)"
            }
        }
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
                // Dim screen backlight to 0.0 preserving WindowServer framebuffer
                brightnessController.dimForLidClose()
            }
            if isMuteOnLidCloseEnabled {
                // Pause media and redirect external DACs to muted speaker
                audioManager.handleLidClosed()
            }
        } else {
            // Lid opened
            if isKeepAwakeEnabled {
                // Restore screen brightness
                brightnessController.restoreForLidOpen()
            }
            if isMuteOnLidCloseEnabled {
                // Unmute and restore external DAC
                audioManager.handleLidOpened()
            }
        }
    }
}
