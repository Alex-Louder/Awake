import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory) // Runs as a menu bar accessory (no Dock icon, light footprint)
app.run()
