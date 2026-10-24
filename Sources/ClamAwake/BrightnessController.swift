import Foundation
import CoreGraphics

/// Controls the physical backlight of the MacBook's built-in display
/// using macOS DisplayServices private framework.
///
/// Crucially, setting brightness to 0.0 turns off the internal panel backlight
/// without sleeping WindowServer. This keeps the GPU framebuffer live, allowing
/// remote access applications (like Sills, Screens, VNC) to render window contents
/// properly instead of displaying a black screen.
final class BrightnessController: @unchecked Sendable {
    static let shared = BrightnessController()
    
    private typealias GetBrightnessFn = @convention(c) (UInt32, UnsafeMutablePointer<Float>) -> Int32
    private typealias SetBrightnessFn = @convention(c) (UInt32, Float) -> Int32
    
    private var getBrightness: GetBrightnessFn?
    private var setBrightness: SetBrightnessFn?
    private var savedBrightness: Float?
    private var isDimmed: Bool = false
    
    private init() {
        if let handle = dlopen("/System/Library/PrivateFrameworks/DisplayServices.framework/DisplayServices", RTLD_LAZY) {
            if let getSym = dlsym(handle, "DisplayServicesGetBrightness") {
                getBrightness = unsafeBitCast(getSym, to: GetBrightnessFn.self)
            }
            if let setSym = dlsym(handle, "DisplayServicesSetBrightness") {
                setBrightness = unsafeBitCast(setSym, to: SetBrightnessFn.self)
            }
        }
    }
    
    /// Finds the CGDirectDisplayID of the built-in MacBook panel.
    func getBuiltInDisplayID() -> CGDirectDisplayID? {
        var count: UInt32 = 0
        CGGetOnlineDisplayList(0, nil, &count)
        guard count > 0 else { return nil }
        
        var displays = [CGDirectDisplayID](repeating: 0, count: Int(count))
        CGGetOnlineDisplayList(count, &displays, &count)
        
        for d in displays {
            if CGDisplayIsBuiltin(d) != 0 {
                return d
            }
        }
        return nil
    }
    
    /// Dims the built-in display to 0.0 when the lid closes.
    /// Preserves the WindowServer framebuffer for remote access sessions.
    func dimForLidClose() {
        guard let displayID = getBuiltInDisplayID(), let setBrightness = setBrightness else { return }
        
        if let getBrightness = getBrightness {
            var current: Float = 0.5
            if getBrightness(displayID, &current) == 0 && current > 0.05 {
                savedBrightness = current
            }
        }
        
        _ = setBrightness(displayID, 0.0)
        isDimmed = true
    }
    
    /// Restores the built-in display brightness when the lid is reopened.
    func restoreForLidOpen() {
        guard isDimmed, let displayID = getBuiltInDisplayID(), let setBrightness = setBrightness else { return }
        
        let target = savedBrightness ?? 0.5
        _ = setBrightness(displayID, target)
        isDimmed = false
    }
    
    func restoreOnQuit() {
        if isDimmed {
            restoreForLidOpen()
        }
    }
}
