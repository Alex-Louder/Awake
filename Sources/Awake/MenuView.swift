import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: AppViewModel
    @ObservedObject private var loc = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: 8) {
            // 1. Header Bar
            headerSection
            
            // 2. Control Center Liquid Glass Capsules
            VStack(spacing: 7) {
                // Capsule 1: Awake!
                controlCapsule(
                    title: loc.awakeTitle,
                    subtitle: loc.awakeSubtitle,
                    systemImage: "bolt.shield.fill",
                    isOn: viewModel.isKeepAwakeEnabled,
                    isBusy: viewModel.isBusy
                ) {
                    viewModel.toggleKeepAwake()
                }
                
                // Capsule 2: Shh!
                controlCapsule(
                    title: loc.shhTitle,
                    subtitle: loc.shhSubtitle,
                    systemImage: "speaker.slash.fill",
                    isOn: viewModel.isMuteOnLidCloseEnabled,
                    isBusy: false
                ) {
                    viewModel.toggleMuteOnLidClose()
                }
            }
            .frame(maxWidth: .infinity)
            
            // 3. Diagnostics Status Capsule
            diagnosticsCapsule
            
            if let error = viewModel.errorMessage {
                errorBanner(message: error)
            }
            
            // 4. Footer
            footerSection
        }
        .padding(10)
        .frame(width: 270)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack(spacing: 7) {
            // MacBook with A!
            MacBookAIconView(size: 18)
            
            Text("Awake!")
                .font(.system(size: 13.5, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // Language selector in header
            HStack(spacing: 2) {
                Button(action: { loc.currentLanguage = .spanish }) {
                    Text("ES")
                        .font(.system(size: 8.5, weight: .bold))
                        .foregroundColor(loc.currentLanguage == .spanish ? .white : .white.opacity(0.45))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(loc.currentLanguage == .spanish ? Color(red: 0.0, green: 0.48, blue: 1.0) : Color.clear)
                        )
                }
                .buttonStyle(.plain)
                
                Button(action: { loc.currentLanguage = .english }) {
                    Text("EN")
                        .font(.system(size: 8.5, weight: .bold))
                        .foregroundColor(loc.currentLanguage == .english ? .white : .white.opacity(0.45))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(loc.currentLanguage == .english ? Color(red: 0.0, green: 0.48, blue: 1.0) : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(1.5)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.10))
            )
            
            HStack(spacing: 4) {
                Circle()
                    .fill(viewModel.isKeepAwakeEnabled ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color.white.opacity(0.35))
                    .frame(width: 5.5, height: 5.5)
                
                Text(viewModel.isKeepAwakeEnabled ? loc.statusActive : loc.statusInactive)
                    .font(.system(size: 9.5, weight: .heavy))
                    .foregroundColor(viewModel.isKeepAwakeEnabled ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color.white.opacity(0.6))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                    )
            )
        }
        .padding(.horizontal, 4)
        .padding(.top, 2)
    }
    
    // MARK: - Control Center Liquid Glass Capsule
    
    private func controlCapsule(
        title: String,
        subtitle: String,
        systemImage: String,
        isOn: Bool,
        isBusy: Bool,
        onToggle: @escaping () -> Void
    ) -> some View {
        Button(action: onToggle) {
            HStack(spacing: 10) {
                // Circular Button (Matching Control Center Wi-Fi / Bluetooth)
                ZStack {
                    Circle()
                        .fill(isOn ? Color.white : Color.white.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: systemImage)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(isOn ? Color(red: 0.0, green: 0.48, blue: 1.0) : Color.white.opacity(0.8))
                }
                
                // Text - expansive leading frame
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 12.5, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Toggle Switch or Progress Spinner
                if isBusy {
                    ProgressView()
                        .scaleEffect(0.6)
                        .frame(width: 32, height: 20)
                } else {
                    Toggle("", isOn: Binding(
                        get: { isOn },
                        set: { _ in onToggle() }
                    ))
                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.0, green: 0.48, blue: 1.0)))
                    .labelsHidden()
                    .scaleEffect(0.75)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .frame(maxWidth: .infinity, minHeight: 46)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(white: 0.20).opacity(0.42))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.65), Color.white.opacity(0.14)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )
                )
        )
    }
    
    // MARK: - Diagnostics Capsule
    
    private var diagnosticsCapsule: some View {
        HStack {
            // Lid Sensor
            HStack(spacing: 4) {
                Image(systemName: "macbook")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(loc.lidPrefix)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                
                Circle()
                    .fill(viewModel.isLidClosed ? Color.orange : Color(red: 0.2, green: 0.85, blue: 0.55))
                    .frame(width: 5, height: 5)
                
                Text(viewModel.isLidClosed ? loc.lidClosed : loc.lidOpen)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
            
            Spacer(minLength: 12)
            
            // USB
            HStack(spacing: 4) {
                Image(systemName: "cable.connector.horizontal")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(loc.usbPrefix)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                
                if viewModel.isKeepAwakeEnabled {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 8))
                        .foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.55))
                }
                
                Text(viewModel.isKeepAwakeEnabled ? loc.usbActive : loc.usbNormal)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(white: 0.15).opacity(0.35))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.25), lineWidth: 0.6)
                )
        )
    }
    
    // MARK: - Error Banner
    
    private func errorBanner(message: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 10))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.system(size: 9.5))
                .foregroundColor(.white)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color.orange.opacity(0.25))
        )
    }
    
    // MARK: - Footer
    
    private var footerSection: some View {
        HStack(spacing: 5) {
            Text("v1.0")
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.4))
            
            Spacer()
            
            // Guía / Guide
            Button(loc.guideButton) {
                AppDelegate.shared?.showOnboardingWindow()
            }
            .buttonStyle(.plain)
            .font(.system(size: 9.5, weight: .medium))
            .foregroundColor(.white.opacity(0.7))
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                    )
            )
            
            // Apoyar / Support
            Button(action: {
                AppDelegate.shared?.showTipJarWindow()
            }) {
                HStack(spacing: 3) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 8))
                        .foregroundColor(Color(red: 0.95, green: 0.35, blue: 0.45))
                    Text(loc.supportButton)
                }
                .font(.system(size: 9.5, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.10))
                        .overlay(
                            Capsule()
                                .stroke(Color(red: 0.95, green: 0.35, blue: 0.45).opacity(0.4), lineWidth: 0.5)
                        )
                )
            }
            .buttonStyle(.plain)
            
            // Salir / Quit
            Button(loc.quitButton) {
                PowerManager.shared.restoreOnQuit()
                BrightnessController.shared.restoreOnQuit()
                AudioManager.shared.restoreOnQuit()
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 9.5, weight: .semibold))
            .foregroundColor(.white.opacity(0.85))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                    )
            )
        }
        .padding(.horizontal, 4)
        .padding(.top, 2)
    }
}

// MacBook icon with "A!" rendered on the screen
struct MacBookAIconView: View {
    var size: CGFloat = 18
    
    var body: some View {
        ZStack {
            VStack(spacing: 1) {
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.1)
                        .stroke(Color.white, lineWidth: 1.2)
                        .frame(width: size * 0.85, height: size * 0.58)
                    
                    Text("A!")
                        .font(.system(size: size * 0.32, weight: .black, design: .default))
                        .foregroundColor(.white)
                }
                
                RoundedRectangle(cornerRadius: 0.7)
                    .fill(Color.white)
                    .frame(width: size, height: size * 0.09)
            }
        }
        .frame(width: size, height: size)
    }
}

// Native macOS visual effect helper with dark HUD liquid glass
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.appearance = NSAppearance(named: .vibrantDark)
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
        nsView.appearance = NSAppearance(named: .vibrantDark)
    }
}
