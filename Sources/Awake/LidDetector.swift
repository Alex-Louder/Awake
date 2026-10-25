import Foundation
import IOKit

/// Detects the physical state of the MacBook lid (open vs closed)
/// using IOKit's IOPMrootDomain "AppleClamshellState" property.
@MainActor
final class LidDetector: ObservableObject {
    @Published private(set) var isLidClosed: Bool = false
    
    var onLidStateChanged: ((Bool) -> Void)?
    
    private var timer: Timer?
    private var lastRecordedState: Bool?
    
    init() {
        self.isLidClosed = Self.readCurrentLidState() ?? false
        self.lastRecordedState = self.isLidClosed
        startMonitoring()
    }
    
    isolated deinit {
        timer?.invalidate()
    }
    
    func startMonitoring() {
        timer?.invalidate()
        // Query lid state rapidly (250ms) to ensure instantaneous reaction
        // without allowing macOS to initiate intermediate sleep or network drop.
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.checkState()
            }
        }
    }
    
    func checkState() {
        guard let current = Self.readCurrentLidState() else { return }
        if current != isLidClosed {
            isLidClosed = current
            lastRecordedState = current
            onLidStateChanged?(current)
        }
    }
    
    /// Reads the AppleClamshellState boolean directly from IOPMrootDomain.
    static func readCurrentLidState() -> Bool? {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPMrootDomain"))
        guard service != IO_OBJECT_NULL else { return nil }
        defer { IOObjectRelease(service) }
        
        let key = "AppleClamshellState" as CFString
        guard let property = IORegistryEntryCreateCFProperty(service, key, kCFAllocatorDefault, 0) else {
            return nil
        }
        return property.takeRetainedValue() as? Bool
    }
}
