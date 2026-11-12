import AppKit
import SwiftUI
import Combine

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    static private(set) var shared: AppDelegate?
    
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var onboardingWindow: NSWindow?
    private var tipJarWindow: NSWindow?
    private var viewModel = AppViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        Self.shared = self
        
        // Setup Control Center Liquid Glass Popover
        popover = NSPopover()
        popover.appearance = NSAppearance(named: .vibrantDark)
        popover.contentSize = NSSize(width: 270, height: 195)
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(rootView: MenuView(viewModel: viewModel))
        
        // Setup Status Item in Menu Bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            updateStatusIcon(isActive: viewModel.isKeepAwakeEnabled)
            button.target = self
            button.action = #selector(handleStatusItemClick)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        // React to KeepAwake state changes to update the menu bar icon
        viewModel.$isKeepAwakeEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] active in
                self?.updateStatusIcon(isActive: active)
            }
            .store(in: &cancellables)
            
        // Listen to notifications for opening sheets
        DistributedNotificationCenter.default().addObserver(forName: NSNotification.Name("com.playlouder.Awake.openTipJar"), object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.showTipJarWindow()
            }
        }
        DistributedNotificationCenter.default().addObserver(forName: NSNotification.Name("com.playlouder.Awake.openOnboarding"), object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.showOnboardingWindow()
            }
        }
        DistributedNotificationCenter.default().addObserver(forName: NSNotification.Name("com.playlouder.Awake.openPopover"), object: nil, queue: .main) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.handleStatusItemClick()
            }
        }
            
        // Check first-launch onboarding or command-line flags
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "awake.hasCompletedOnboarding")
        if CommandLine.arguments.contains("--tipjar") {
            showTipJarWindow()
        } else if !hasCompletedOnboarding {
            showOnboardingWindow()
        }
    }
    
    @objc private func handleStatusItemClick() {
        guard let button = statusItem.button else { return }
        
        let isOptionPressed = NSApp.currentEvent?.modifierFlags.contains(.option) ?? false
        let isRightClick = (NSApp.currentEvent?.type == .rightMouseUp) || (NSApp.currentEvent?.type == .rightMouseDown)
        
        // Option-Click or Right-Click directly toggles Awake on/off immediately
        if isOptionPressed || isRightClick {
            viewModel.toggleKeepAwake()
            return
        }
        
        // Regular click toggles the Liquid Glass popover
        if popover.isShown {
            popover.performClose(nil)
        } else {
            viewModel.refreshSystemState()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    func showOnboardingWindow() {
        if let window = onboardingWindow {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        let window = BorderlessFloatingWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 520),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        window.delegate = self
        window.isMovableByWindowBackground = true
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = true
        window.level = .floating
        window.center()
        
        let onboardingView = OnboardingView(
            onDismiss: { [weak self] in
                UserDefaults.standard.set(true, forKey: "awake.hasCompletedOnboarding")
                self?.onboardingWindow?.close()
                self?.onboardingWindow = nil
            },
            onOpenTipJar: { [weak self] in
                self?.showTipJarWindow()
            }
        )
        
        window.contentViewController = NSHostingController(rootView: onboardingView)
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        self.onboardingWindow = window
    }
    
    func showTipJarWindow() {
        if let window = tipJarWindow {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        let window = BorderlessFloatingWindow(
            contentRect: NSRect(x: 0, y: 0, width: 370, height: 430),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        window.delegate = self
        window.isMovableByWindowBackground = true
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = true
        window.level = .floating
        window.center()
        
        let tipJarView = TipJarView { [weak self] in
            self?.tipJarWindow?.close()
            self?.tipJarWindow = nil
        }
        
        window.contentViewController = NSHostingController(rootView: tipJarView)
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        self.tipJarWindow = window
    }
    
    // MARK: - NSWindowDelegate
    
    func windowWillClose(_ notification: Notification) {
        if let closingWindow = notification.object as? NSWindow {
            if closingWindow === onboardingWindow {
                onboardingWindow = nil
            } else if closingWindow === tipJarWindow {
                tipJarWindow = nil
            }
        }
    }
    
    private func updateStatusIcon(isActive: Bool) {
        guard let button = statusItem.button else { return }
        
        // MacBook icon with "A!" rendered on the screen (bright when active, dimmed when asleep)
        let icon = createMacBookAIcon(isActive: isActive)
        button.image = icon
        button.toolTip = isActive 
            ? "Awake!: Activo (Clic para menú, ⌥-Clic para desactivar)" 
            : "Awake!: Inactivo (Clic para menú, ⌥-Clic para activar)"
    }
    
    /// Generates a crisp vector MacBook with "A!" on the screen for the menu bar.
    /// Uses full-alpha bright solid fill for ACTIVE state, and a clearly dimmed 35% alpha
    /// sleeping outline for INACTIVE state.
    private func createMacBookAIcon(isActive: Bool) -> NSImage {
        let size = NSSize(width: 19, height: 18)
        let img = NSImage(size: size)
        img.lockFocus()
        
        let w: CGFloat = 17.0
        let h: CGFloat = 12.0
        let x: CGFloat = 1.0
        let y: CGFloat = 3.0
        
        // Screen
        let screenW = w * 0.82
        let screenH = h * 0.78
        let screenX = x + (w - screenW) / 2
        let screenY = y + (h - screenH)
        
        let screenRect = CGRect(x: screenX, y: screenY, width: screenW, height: screenH)
        let screenPath = NSBezierPath(roundedRect: screenRect, xRadius: 1.5, yRadius: 1.5)
        
        if isActive {
            // Bright solid screen
            NSColor.labelColor.setFill()
            screenPath.fill()
            
            // Text "A!" inside inverted
            let font = NSFont.systemFont(ofSize: 7.0, weight: .black)
            let text = "A!" as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: NSColor.windowBackgroundColor
            ]
            let textSize = text.size(withAttributes: attrs)
            let textRect = CGRect(
                x: screenRect.midX - textSize.width / 2,
                y: screenRect.midY - textSize.height / 2 + 0.3,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attrs)
            
            // Solid laptop Base
            let baseW = w
            let baseH: CGFloat = 2.0
            let baseY = y
            let baseRect = CGRect(x: x, y: baseY, width: baseW, height: baseH)
            let basePath = NSBezierPath(roundedRect: baseRect, xRadius: 1.0, yRadius: 1.0)
            NSColor.labelColor.setFill()
            basePath.fill()
        } else {
            // Translucent dimmed sleeping screen (35% alpha clearly signals INACTIVE)
            let dimmedColor = NSColor.labelColor.withAlphaComponent(0.35)
            dimmedColor.setStroke()
            screenPath.lineWidth = 1.0
            screenPath.stroke()
            
            // Subtle "z" sleep indicator inside screen
            let font = NSFont.systemFont(ofSize: 6.5, weight: .bold)
            let text = "z" as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: dimmedColor
            ]
            let textSize = text.size(withAttributes: attrs)
            let textRect = CGRect(
                x: screenRect.midX - textSize.width / 2,
                y: screenRect.midY - textSize.height / 2 + 0.2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attrs)
            
            // Dimmed laptop Base
            let baseW = w
            let baseH: CGFloat = 2.0
            let baseY = y
            let baseRect = CGRect(x: x, y: baseY, width: baseW, height: baseH)
            let basePath = NSBezierPath(roundedRect: baseRect, xRadius: 1.0, yRadius: 1.0)
            dimmedColor.setFill()
            basePath.fill()
        }
        
        img.unlockFocus()
        img.isTemplate = true
        return img
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        PowerManager.shared.restoreOnQuit()
        BrightnessController.shared.restoreOnQuit()
        AudioManager.shared.restoreOnQuit()
    }
}

// MARK: - Key-capable Borderless Window

final class BorderlessFloatingWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}
