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
        popover.contentSize = NSSize(width: 300, height: 260)
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(rootView: MenuView(viewModel: viewModel))
        
        // Setup Status Item in Menu Bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            updateStatusIcon(isActive: viewModel.isKeepAwakeEnabled)
            button.action = #selector(togglePopover)
            button.target = self
        }
        
        // React to KeepAwake state changes to update the menu bar icon
        viewModel.$isKeepAwakeEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] active in
                self?.updateStatusIcon(isActive: active)
            }
            .store(in: &cancellables)
    }
    
    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        
        if popover.isShown {
            popover.performClose(nil)
        } else {
            viewModel.refreshSystemState()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    private func updateStatusIcon(isActive: Bool) {
        guard let button = statusItem.button else { return }
        
        let symbolName = isActive ? "laptopcomputer" : "laptopcomputer"
        if let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "ClamAwake") {
            let config = NSImage.SymbolConfiguration(pointSize: 13, weight: .regular)
            button.image = image.withSymbolConfiguration(config)
            button.image?.isTemplate = true
        }
        
        // Set tooltip
        button.toolTip = isActive ? "ClamAwake: Activo (La Mac no se dormirá al cerrar la tapa)" : "ClamAwake: Inactivo"
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        PowerManager.shared.restoreOnQuit()
    }
}
