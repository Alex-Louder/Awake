import AppKit
import SwiftUI
import Combine

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var viewModel = AppViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Setup Popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 295, height: 440)
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
        
        // Setup local monitor for ⌘K shortcut
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.modifierFlags.contains(.command) && event.charactersIgnoringModifiers == "k" {
                self?.viewModel.toggleKeepAwake()
                return nil
            }
            return event
        }
    }
    
    @objc private func handleStatusItemClick() {
        guard statusItem.button != nil else { return }
        
        // If popover is already open, close it
        if popover.isShown {
            popover.performClose(nil)
            return
        }
        
        guard let event = NSApp.currentEvent else {
            togglePopover()
            return
        }
        
        let isRightClick = event.type == .rightMouseUp || event.modifierFlags.contains(.control)
        
        if isRightClick {
            // Right-click: Open the options popover
            togglePopover()
        } else {
            // Left-click:
            if viewModel.leftClickToggles {
                // Instantly toggle Awake! mode
                viewModel.toggleKeepAwake()
            } else {
                togglePopover()
            }
        }
    }
    
    private func togglePopover() {
        guard let button = statusItem.button else { return }
        viewModel.refreshSystemState()
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        popover.contentViewController?.view.window?.makeKey()
    }
    
    private func updateStatusIcon(isActive: Bool) {
        guard let button = statusItem.button else { return }
        
        // Caffeinate coffee cup icon: outline when inactive, filled when active
        let symbolName = isActive ? "cup.and.saucer.fill" : "cup.and.saucer"
        if let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "Awake!") {
            let config = NSImage.SymbolConfiguration(pointSize: 13, weight: .regular)
            button.image = image.withSymbolConfiguration(config)
            button.image?.isTemplate = true
        }
        
        button.toolTip = isActive ? "Awake!: Activo (Clic izquierdo para desactivar, clic derecho para opciones)" : "Awake!: Inactivo (Clic izquierdo para activar, clic derecho para opciones)"
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        PowerManager.shared.restoreOnQuit()
        BrightnessController.shared.restoreOnQuit()
        AudioManager.shared.restoreOnQuit()
    }
}
