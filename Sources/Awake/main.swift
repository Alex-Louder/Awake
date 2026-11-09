import AppKit
import Darwin

// MARK: - Single-Instance Enforcement
// Enforce strict single-instance execution via kernel file lock (flock)
// and NSRunningApplication check to prevent duplicate menu bar icons.

let lockFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("com.playlouder.Awake.singleinstance.lock")
let lockFD = open(lockFilePath, O_CREAT | O_WRONLY, 0o600)

var isAlreadyRunning = false
if lockFD >= 0 {
    if flock(lockFD, LOCK_EX | LOCK_NB) != 0 {
        isAlreadyRunning = true
    }
}

let currentPID = ProcessInfo.processInfo.processIdentifier
let bundleID = Bundle.main.bundleIdentifier ?? "com.playlouder.Awake"
let existingInstances = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
    .filter { $0.processIdentifier != currentPID }

if isAlreadyRunning || !existingInstances.isEmpty {
    // Notify the existing instance to toggle/show its menu popover
    DistributedNotificationCenter.default().postNotificationName(
        NSNotification.Name("com.playlouder.Awake.openPopover"),
        object: nil,
        userInfo: nil,
        deliverImmediately: true
    )
    exit(0)
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory) // Runs as a menu bar accessory (no Dock icon, light footprint)
app.run()
