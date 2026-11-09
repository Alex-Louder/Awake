import Foundation
import ServiceManagement
import Combine

@MainActor
final class LaunchAtLoginManager: ObservableObject {
    static let shared = LaunchAtLoginManager()
    
    @Published var isEnabled: Bool = false
    
    private let launchAgentLabel = "com.playlouder.Awake"
    private var launchAgentURL: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/LaunchAgents")
            .appendingPathComponent("\(launchAgentLabel).plist")
    }
    
    private init() {
        checkStatus()
    }
    
    func checkStatus() {
        cleanLegacyLaunchAgentIfModernAvailable()
        
        if #available(macOS 13.0, *) {
            isEnabled = SMAppService.mainApp.status == .enabled
            return
        }
        isEnabled = FileManager.default.fileExists(atPath: launchAgentURL.path)
            || UserDefaults.standard.bool(forKey: "awake.launchAtLogin")
    }
    
    func toggle() {
        if isEnabled {
            disable()
        } else {
            enable()
        }
    }
    
    func enable() {
        cleanLegacyLaunchAgentIfModernAvailable()
        
        if #available(macOS 13.0, *) {
            do {
                try SMAppService.mainApp.register()
                isEnabled = SMAppService.mainApp.status == .enabled
            } catch {
                // If modern SMAppService fails, fallback to LaunchAgent
                installLaunchAgent()
                isEnabled = FileManager.default.fileExists(atPath: launchAgentURL.path)
            }
        } else {
            installLaunchAgent()
            isEnabled = true
        }
        UserDefaults.standard.set(isEnabled, forKey: "awake.launchAtLogin")
    }
    
    func disable() {
        if #available(macOS 13.0, *) {
            try? SMAppService.mainApp.unregister()
        }
        removeLaunchAgent()
        isEnabled = false
        UserDefaults.standard.set(false, forKey: "awake.launchAtLogin")
    }
    
    /// Cleans up any legacy LaunchAgent plist so launchd never launches duplicate jobs on login.
    private func cleanLegacyLaunchAgentIfModernAvailable() {
        if #available(macOS 13.0, *) {
            if FileManager.default.fileExists(atPath: launchAgentURL.path) {
                let proc = Process()
                proc.executableURL = URL(fileURLWithPath: "/bin/launchctl")
                proc.arguments = ["bootout", "gui/\(getuid())/\(launchAgentLabel)"]
                try? proc.run()
                proc.waitUntilExit()
                
                try? FileManager.default.removeItem(at: launchAgentURL)
            }
        }
    }
    
    private func installLaunchAgent() {
        let launchAgentsDir = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/LaunchAgents")
        try? FileManager.default.createDirectory(at: launchAgentsDir, withIntermediateDirectories: true)
        
        let appPath = "/Applications/Awake!.app/Contents/MacOS/Awake"
        let plistContent = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>\(launchAgentLabel)</string>
            <key>ProgramArguments</key>
            <array>
                <string>\(appPath)</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <false/>
            <key>ProcessType</key>
            <string>Interactive</string>
        </dict>
        </plist>
        """
        try? plistContent.write(to: launchAgentURL, atomically: true, encoding: .utf8)
    }
    
    private func removeLaunchAgent() {
        try? FileManager.default.removeItem(at: launchAgentURL)
    }
}
