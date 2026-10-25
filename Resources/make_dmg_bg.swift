import Cocoa

func createDmgBackground() {
    let width: CGFloat = 660
    let height: CGFloat = 400
    let scale: CGFloat = 2.0 // Retina @2x
    
    let size = NSSize(width: width, height: height)
    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(width * scale),
        pixelsHigh: Int(height * scale),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!
    rep.size = size
    
    NSGraphicsContext.saveGraphicsState()
    let context = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = context
    
    // Draw background gradient
    let bgRect = NSRect(origin: .zero, size: size)
    let gradient = NSGradient(
        starting: NSColor(red: 0.08, green: 0.09, blue: 0.12, alpha: 1.0),
        ending: NSColor(red: 0.03, green: 0.03, blue: 0.04, alpha: 1.0)
    )!
    gradient.draw(in: bgRect, angle: -45)
    
    // Subtle border highlight
    let borderPath = NSBezierPath(rect: bgRect)
    NSColor(white: 1.0, alpha: 0.08).setStroke()
    borderPath.lineWidth = 1.0
    borderPath.stroke()
    
    // Header Title
    let title = "Awake! v1.0.0"
    let titleStyle = NSMutableParagraphStyle()
    titleStyle.alignment = .center
    let titleAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 22, weight: .bold),
        .foregroundColor: NSColor.white,
        .paragraphStyle: titleStyle
    ]
    title.draw(in: NSRect(x: 20, y: height - 60, width: width - 40, height: 30), withAttributes: titleAttrs)
    
    // Header Subtitle
    let subtitle = "Arrastra Awake! a la carpeta Aplicaciones • Drag Awake! to Applications"
    let subStyle = NSMutableParagraphStyle()
    subStyle.alignment = .center
    let subAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 13, weight: .medium),
        .foregroundColor: NSColor(white: 0.7, alpha: 1.0),
        .paragraphStyle: subStyle
    ]
    subtitle.draw(in: NSRect(x: 20, y: height - 85, width: width - 40, height: 22), withAttributes: subAttrs)
    
    // Subtle placeholder guides for icons
    // create-dmg coordinates are from top-left:
    // x=180, y=190 -> in Cocoa bottom-left, y = 400 - 190 = 210.
    let leftGuideRect = NSRect(x: 180 - 64, y: 210 - 64, width: 128, height: 128)
    let rightGuideRect = NSRect(x: 480 - 64, y: 210 - 64, width: 128, height: 128)
    
    let leftGuide = NSBezierPath(roundedRect: leftGuideRect, xRadius: 28, yRadius: 28)
    NSColor(white: 1.0, alpha: 0.04).setFill()
    leftGuide.fill()
    NSColor(white: 1.0, alpha: 0.08).setStroke()
    leftGuide.lineWidth = 1.5
    leftGuide.stroke()
    
    let rightGuide = NSBezierPath(roundedRect: rightGuideRect, xRadius: 28, yRadius: 28)
    NSColor(white: 1.0, alpha: 0.04).setFill()
    rightGuide.fill()
    NSColor(white: 1.0, alpha: 0.08).setStroke()
    rightGuide.lineWidth = 1.5
    rightGuide.stroke()
    
    // Arrow in the center between x=180 and x=480: center is x=330, y=210
    let arrow = "➔"
    let arrowStyle = NSMutableParagraphStyle()
    arrowStyle.alignment = .center
    let arrowAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 38, weight: .light),
        .foregroundColor: NSColor(red: 0.38, green: 0.72, blue: 0.98, alpha: 0.85),
        .paragraphStyle: arrowStyle
    ]
    arrow.draw(in: NSRect(x: 290, y: 210 - 24, width: 80, height: 48), withAttributes: arrowAttrs)
    
    // Footer badge
    let footer = "macOS 14+ Sonoma & Sequoia • Apple Silicon & Intel • 100% Open Source • Cero Contraseñas"
    let footStyle = NSMutableParagraphStyle()
    footStyle.alignment = .center
    let footAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: 11, weight: .regular),
        .foregroundColor: NSColor(white: 0.45, alpha: 1.0),
        .paragraphStyle: footStyle
    ]
    footer.draw(in: NSRect(x: 20, y: 22, width: width - 40, height: 18), withAttributes: footAttrs)
    
    NSGraphicsContext.restoreGraphicsState()
    
    let pngData = rep.representation(using: .png, properties: [:])!
    let outputPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "Resources/dmg_background.png"
    try! pngData.write(to: URL(fileURLWithPath: outputPath))
    print("DMG background generated at: \(outputPath)")
}

createDmgBackground()
