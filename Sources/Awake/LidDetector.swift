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
    private var isHighFrequency: Bool = true
    
    init() {
        self.isLidClosed = Self.readCurrentLidState() ?? false
        self.lastRecordedState = self.isLidClosed
        startMonitoring(interval: 0.5)
    }
    
    isolated deinit {
        timer?.invalidate()
    }
    
    /// Adjusts monitoring frequency depending on whether keepawake or popover is active.
    /// Fast (0.5s) when Awake! is ON or popover is open.
    /// Gentle (5.0s) when Awake! is inactive, avoiding C-state wakeups and saving battery.
    func setHighFrequencyMonitoring(_ enabled: Bool) {
        guard enabled != isHighFrequency else { return }
        self.isHighFrequency = enabled
        startMonitoring(interval: enabled ? 0.5 : 5.0)
    }
    
    func startMonitoring(interval: TimeInterval = 0.5) {
        timer?.invalidate()
        let t = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.checkState()
            }
        }
        RunLoop.main.add(t, forMode: .common)
        self.timer = t
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
