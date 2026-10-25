import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            // 1. Header Bar
            headerSection
            
            // 2. Control Center Liquid Glass Capsules
            VStack(spacing: 7) {
                // Capsule 1: Mantener Activa
                controlCapsule(
                    title: "Mantener activa",
                    subtitle: "Nunca se duerme",
                    systemImage: "bolt.shield.fill",
                    isOn: viewModel.isKeepAwakeEnabled,
                    isBusy: viewModel.isBusy
                ) {
                    viewModel.toggleKeepAwake()
                }
                
                // Capsule 2: Silenciar Sonido
                controlCapsule(
                    title: "Silenciar sonido",
                    subtitle: "Muta al cerrar",
                    systemImage: "speaker.slash.fill",
                    isOn: viewModel.isMuteOnLidCloseEnabled,
                    isBusy: false
                ) {
                    viewModel.toggleMuteOnLidClose()
                }
            }
            
            // 3. Diagnostics Status Capsule
            diagnosticsCapsule
            
            if let error = viewModel.errorMessage {
                errorBanner(message: error)
            }
            
            // 4. Footer
            footerSection
        }
        .padding(10)
        .frame(width: 240)
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
            
            HStack(spacing: 4) {
                Circle()
                    .fill(viewModel.isKeepAwakeEnabled ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color.white.opacity(0.35))
                    .frame(width: 5.5, height: 5.5)
                
                Text(viewModel.isKeepAwakeEnabled ? "ACTIVO" : "INACTIVO")
                    .font(.system(size: 9.5, weight: .heavy))
                    .foregroundColor(viewModel.isKeepAwakeEnabled ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color.white.opacity(0.6))
            }
            .padding(.horizontal, 7)
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
                
                // Text (Max 3 words, ultra concise)
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 12.5, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 10.5, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }
                
                Spacer(minLength: 4)
                
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
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
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
                
                Text("Tapa:")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Circle()
                    .fill(viewModel.isLidClosed ? Color.orange : Color(red: 0.2, green: 0.85, blue: 0.55))
                    .frame(width: 5, height: 5)
                
                Text(viewModel.isLidClosed ? "Cerrada" : "Abierta")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // USB
            HStack(spacing: 4) {
                Image(systemName: "cable.connector.horizontal")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
                
                Text("USB:")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                if viewModel.isKeepAwakeEnabled {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 8))
                        .foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.55))
                }
                
                Text(viewModel.isKeepAwakeEnabled ? "Activo" : "Normal")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
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
        HStack {
            Text("v2.3")
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.4))
            
            Spacer()
            
            Button("Salir") {
                PowerManager.shared.restoreOnQuit()
                BrightnessController.shared.restoreOnQuit()
                AudioManager.shared.restoreOnQuit()
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(.white.opacity(0.85))
            .padding(.horizontal, 9)
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
