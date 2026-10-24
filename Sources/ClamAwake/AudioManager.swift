import Foundation
import CoreAudio
import AppKit

/// Handles comprehensive audio muting, external DAC/USB redirection,
/// and media playback pausing when the lid closes.
final class AudioManager: @unchecked Sendable {
    static let shared = AudioManager()
    
    private typealias MRMediaRemoteSendCommandFunction = @convention(c) (Int32, AnyObject?) -> Bool
    private var sendMediaRemoteCommand: MRMediaRemoteSendCommandFunction?
    
    private var originalDeviceID: AudioDeviceID?
    private var didRedirectDevice: Bool = false
    private var didMuteByApp: Bool = false
    
    private init() {
        // Resolve private MediaRemote framework for system-wide media pause
        if let handle = dlopen("/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote", RTLD_LAZY) {
            if let sym = dlsym(handle, "MRMediaRemoteSendCommand") {
                sendMediaRemoteCommand = unsafeBitCast(sym, to: MRMediaRemoteSendCommandFunction.self)
            }
        }
    }
    
    /// Called when the lid closes with audio control enabled.
    func handleLidClosed() {
        // 1. Pause active media players safely without triggering application picker dialogs
        pauseAllMedia()
        
        // 2. Handle audio routing for external interfaces (like Focusrite Scarlett Solo / USB / HDMI)
        let current = getDefaultOutputDevice()
        if let builtIn = getBuiltInSpeakerID() {
            if current != builtIn {
                originalDeviceID = current
                didRedirectDevice = setDefaultOutputDevice(id: builtIn)
            }
        }
        
        // 3. Mute system volume
        muteSystemOutput()
    }
    
    /// Called when the lid opens.
    func handleLidOpened() {
        // 1. Restore external audio device if it was redirected
        if didRedirectDevice, let orig = originalDeviceID {
            _ = setDefaultOutputDevice(id: orig)
            didRedirectDevice = false
            originalDeviceID = nil
        }
        
        // 2. Unmute system volume
        if didMuteByApp {
            unmuteSystemOutput()
            didMuteByApp = false
        }
    }
    
    func restoreOnQuit() {
        if didRedirectDevice, let orig = originalDeviceID {
            _ = setDefaultOutputDevice(id: orig)
            didRedirectDevice = false
            originalDeviceID = nil
        }
        if didMuteByApp {
            unmuteSystemOutput()
            didMuteByApp = false
        }
    }
    
    // MARK: - Media Controls
    
    private func pauseAllMedia() {
        // Command 1 = kMRPause (MediaRemote system-wide pause for NowPlaying apps:
        // YouTube, Chrome, Safari, Podcasts, VLC, IINA, etc.)
        _ = sendMediaRemoteCommand?(1, nil)
        
        // Only target apps by bundle identifier if they are actually running,
        // preventing macOS from opening "Choose Application" (e.g. "Where is VLC?") dialogs.
        let runningApps = NSWorkspace.shared.runningApplications
        
        if runningApps.contains(where: { $0.bundleIdentifier == "com.spotify.client" }) {
            runAppleScript("tell application id \"com.spotify.client\" to pause")
        }
        if runningApps.contains(where: { $0.bundleIdentifier == "com.apple.Music" }) {
            runAppleScript("tell application id \"com.apple.Music\" to pause")
        }
    }
    
    // MARK: - CoreAudio Device Routing
    
    func getDefaultOutputDevice() -> AudioDeviceID {
        var dev = AudioDeviceID(0)
        var size = UInt32(MemoryLayout<AudioDeviceID>.size)
        var addr = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        _ = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &addr, 0, nil, &size, &dev)
        return dev
    }
    
    @discardableResult
    func setDefaultOutputDevice(id: AudioDeviceID) -> Bool {
        var dev = id
        let size = UInt32(MemoryLayout<AudioDeviceID>.size)
        var addr = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        return AudioObjectSetPropertyData(AudioObjectID(kAudioObjectSystemObject), &addr, 0, nil, size, &dev) == noErr
    }
    
    func getBuiltInSpeakerID() -> AudioDeviceID? {
        var size: UInt32 = 0
        var addr = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        guard AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &addr, 0, nil, &size) == noErr else {
            return nil
        }
        
        let count = Int(size) / MemoryLayout<AudioDeviceID>.size
        var ids = [AudioDeviceID](repeating: 0, count: count)
        guard AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &addr, 0, nil, &size, &ids) == noErr else {
            return nil
        }
        
        for id in ids {
            var streamAddr = AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyStreamConfiguration,
                mScope: kAudioDevicePropertyScopeOutput,
                mElement: kAudioObjectPropertyElementMain
            )
            var streamSize: UInt32 = 0
            if AudioObjectGetPropertyDataSize(id, &streamAddr, 0, nil, &streamSize) == noErr && streamSize > 0 {
                var transportAddr = AudioObjectPropertyAddress(
                    mSelector: kAudioDevicePropertyTransportType,
                    mScope: kAudioObjectPropertyScopeGlobal,
                    mElement: kAudioObjectPropertyElementMain
                )
                var transportType: UInt32 = 0
                var transportSize = UInt32(MemoryLayout<UInt32>.size)
                if AudioObjectGetPropertyData(id, &transportAddr, 0, nil, &transportSize, &transportType) == noErr {
                    if transportType == kAudioDeviceTransportTypeBuiltIn {
                        var bufList = AudioBufferList()
                        var bufSize = UInt32(MemoryLayout<AudioBufferList>.size)
                        if AudioObjectGetPropertyData(id, &streamAddr, 0, nil, &bufSize, &bufList) == noErr {
                            if bufList.mNumberBuffers > 0 {
                                return id
                            }
                        }
                    }
                }
            }
        }
        return nil
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
