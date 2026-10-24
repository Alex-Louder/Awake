import Foundation
import AppKit

/// Handles audio muting and media playback pausing when the lid closes.
final class AudioManager: @unchecked Sendable {
    static let shared = AudioManager()
    
    private var didMuteByApp: Bool = false
    
    private init() {}
    
    /// Called when the lid closes with audio control enabled.
    func handleLidClosed() {
        // 1. Pause running media applications (Music, Spotify)
        pauseMusicAndSpotify()
        
        // 2. Post system-wide Play/Pause media key event for browser/video players
        sendSystemPlayPauseKey()
        
        // 3. Mute system volume
        muteSystemOutput()
    }
    
    /// Called when the lid opens.
    func handleLidOpened() {
        if didMuteByApp {
            unmuteSystemOutput()
            didMuteByApp = false
        }
    }
    
    // MARK: - Media Controls
    
    private func pauseMusicAndSpotify() {
        let script = """
        if application "Music" is running then
            tell application "Music" to pause
        end if
        if application "Spotify" is running then
            tell application "Spotify" to pause
        end if
        """
        runAppleScript(script)
    }
    
    private func sendSystemPlayPauseKey() {
        DispatchQueue.main.async {
            func postKey(down: Bool) {
                let flags: NSEvent.ModifierFlags = down ? [.init(rawValue: 0xa00)] : [.init(rawValue: 0xb00)]
                let data1 = Int((16 << 16) | ((down ? 0xa : 0xb) << 8))
                let event = NSEvent.otherEvent(
                    with: .systemDefined,
                    location: .zero,
                    modifierFlags: flags,
                    timestamp: 0,
                    windowNumber: 0,
                    context: nil,
                    subtype: 8,
                    data1: data1,
                    data2: -1
                )
                event?.cgEvent?.post(tap: .cghidEventTap)
            }
            postKey(down: true)
            postKey(down: false)
        }
    }
    
    // MARK: - Volume Muting
    
    private func muteSystemOutput() {
        let script = "set volume with output muted"
        if runAppleScript(script) {
            didMuteByApp = true
        }
    }
    
    private func unmuteSystemOutput() {
        let script = "set volume without output muted"
        _ = runAppleScript(script)
    }
    
    @discardableResult
    private func runAppleScript(_ source: String) -> Bool {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: source) {
            _ = scriptObject.executeAndReturnError(&error)
            return error == nil
        }
        return false
    }
}
