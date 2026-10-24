import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            // Header Bar
            headerSection
            
            // Primary Control Cards (Compact Liquid Glass Pods)
            VStack(spacing: 7) {
                // Pod 1: Mantener Activa (Clamshell Awake)
                controlPod(
                    title: "Mantener activa",
                    subtitle: "Tapa cerrada sin suspender",
                    systemImage: "bolt.shield.fill",
                    isOn: viewModel.isKeepAwakeEnabled,
                    isBusy: viewModel.isBusy
                ) {
                    viewModel.toggleKeepAwake()
                }
                
                // Pod 2: Silenciar al Cerrar Tapa
                controlPod(
                    title: "Silenciar al cerrar",
                    subtitle: "Pausa medios y silencia audio",
                    systemImage: "speaker.slash.fill",
                    isOn: viewModel.isMuteOnLidCloseEnabled,
                    isBusy: false
                ) {
                    viewModel.toggleMuteOnLidClose()
                }
            }
            
            // Status Bar (Compact Diagnostics Pill)
            statusBar
            
            if let error = viewModel.errorMessage {
                errorBanner(message: error)
            }
            
            // Footer
            footerSection
        }
        .padding(11)
        .frame(width: 250)
        .background(NativeGlassBackground())
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack(spacing: 6) {
            MacBookAIconView(size: 18)
            
            Text("Awake!")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 4) {
                Circle()
                    .fill(viewModel.isKeepAwakeEnabled ? Color.green : Color.secondary.opacity(0.4))
                    .frame(width: 5, height: 5)
                
                Text(viewModel.isKeepAwakeEnabled ? "ACTIVO" : "INACTIVO")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(viewModel.isKeepAwakeEnabled ? .green : .secondary)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 2.5)
            .background(
                Capsule()
                    .fill(viewModel.isKeepAwakeEnabled ? Color.green.opacity(0.12) : Color.primary.opacity(0.06))
            )
        }
        .padding(.horizontal, 2)
    }
    
    // MARK: - Compact Liquid Glass Pod
    
    private func controlPod(
        title: String,
        subtitle: String,
        systemImage: String,
        isOn: Bool,
        isBusy: Bool,
        onToggle: @escaping () -> Void
    ) -> some View {
        HStack(spacing: 9) {
            // Circular Glass Badge
            ZStack {
                Circle()
                    .fill(isOn ? Color.accentColor : Color.primary.opacity(0.08))
                    .frame(width: 26, height: 26)
                
                Image(systemName: systemImage)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(isOn ? .white : .secondary)
            }
            
            // Titles (Concise, zero truncation)
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 4)
            
            // Toggle Switch or Spinner
            if isBusy {
                ProgressView()
                    .scaleEffect(0.6)
                    .frame(width: 32, height: 20)
            } else {
                Toggle("", isOn: Binding(
                    get: { isOn },
                    set: { _ in onToggle() }
                ))
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .labelsHidden()
                .scaleEffect(0.75)
            }
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.38), Color.white.opacity(0.08)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 0.6
                        )
                )
        )
    }
    
    // MARK: - Compact Diagnostics Status Bar
    
    private var statusBar: some View {
        HStack {
            // Lid Sensor
            HStack(spacing: 4) {
                Image(systemName: viewModel.isLidClosed ? "macbook.gen2" : "macbook")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                Text("Tapa:")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                Circle()
                    .fill(viewModel.isLidClosed ? Color.orange : Color.green)
                    .frame(width: 5, height: 5)
                
                Text(viewModel.isLidClosed ? "Cerrada" : "Abierta")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // USB & Services
            HStack(spacing: 4) {
                Image(systemName: "cable.connector.horizontal")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                Text("USB:")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                if viewModel.isKeepAwakeEnabled {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 8))
                        .foregroundColor(.green)
                }
                
                Text(viewModel.isKeepAwakeEnabled ? "Activo" : "Normal")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(viewModel.isKeepAwakeEnabled ? .primary : .secondary)
            }
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.primary.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
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
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color.orange.opacity(0.12))
        )
    }
    
    // MARK: - Footer
    
    private var footerSection: some View {
        HStack {
            Text("v2.2")
                .font(.system(size: 9))
                .foregroundColor(.secondary.opacity(0.6))
            
            Spacer()
            
            Button("Salir") {
                PowerManager.shared.restoreOnQuit()
                BrightnessController.shared.restoreOnQuit()
                AudioManager.shared.restoreOnQuit()
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.secondary)
            .padding(.horizontal, 7)
            .padding(.vertical, 2.5)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color.primary.opacity(0.06))
            )
        }
        .padding(.horizontal, 2)
        .padding(.top, 1)
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
                        .stroke(Color.primary, lineWidth: 1.1)
                        .frame(width: size * 0.85, height: size * 0.58)
                    
                    Text("A!")
                        .font(.system(size: size * 0.32, weight: .black, design: .default))
                        .foregroundColor(.primary)
                }
                
                RoundedRectangle(cornerRadius: 0.7)
                    .fill(Color.primary)
                    .frame(width: size, height: size * 0.09)
            }
        }
        .frame(width: size, height: size)
    }
}

// Native Apple Liquid Glass background using NSGlassEffectView where available,
// falling back to NSVisualEffectView popover material with behindWindow blending.
struct NativeGlassBackground: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        if let glassClass = NSClassFromString("NSGlassEffectView") as? NSView.Type {
            let v = glassClass.init(frame: .zero)
            v.setValue(14.0, forKey: "cornerRadius")
            return v
        } else {
            let v = NSVisualEffectView()
            v.material = .popover
            v.blendingMode = .behindWindow
            v.state = .active
            return v
        }
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
