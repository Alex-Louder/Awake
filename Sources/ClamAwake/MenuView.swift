import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            // Header Bar
            headerSection
            
            // Primary Control Cards (Control Center Liquid Glass Pods)
            VStack(spacing: 10) {
                // Pod 1: Mantener Activa (Clamshell Awake)
                controlPod(
                    title: "Mantener activa",
                    subtitle: "No suspender al cerrar. Hubs y procesos activos.",
                    systemImage: "bolt.shield.fill",
                    isOn: viewModel.isKeepAwakeEnabled,
                    isBusy: viewModel.isBusy
                ) {
                    viewModel.toggleKeepAwake()
                }
                
                // Pod 2: Silenciar al Cerrar Tapa
                controlPod(
                    title: "Silenciar al cerrar",
                    subtitle: "Pausa música y silencia audio automáticamente.",
                    systemImage: "speaker.slash.fill",
                    isOn: viewModel.isMuteOnLidCloseEnabled,
                    isBusy: false
                ) {
                    viewModel.toggleMuteOnLidClose()
                }
            }
            
            // Status Pod (Hardware & Sensor Diagnostics)
            statusPod
            
            if let error = viewModel.errorMessage {
                errorBanner(message: error)
            }
            
            // Footer
            footerSection
        }
        .padding(14)
        .frame(width: 330)
        .background(VisualEffectView(material: .popover, blendingMode: .behindWindow))
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack(alignment: .center) {
            HStack(spacing: 8) {
                Image(systemName: "laptopcomputer")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("ClamAwake")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Control Center Style Status Pill
            HStack(spacing: 5) {
                Circle()
                    .fill(viewModel.isKeepAwakeEnabled ? Color.green : Color.secondary.opacity(0.4))
                    .frame(width: 6, height: 6)
                
                Text(viewModel.isKeepAwakeEnabled ? "ACTIVO" : "INACTIVO")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(viewModel.isKeepAwakeEnabled ? .primary : .secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(viewModel.isKeepAwakeEnabled ? Color.green.opacity(0.14) : Color.primary.opacity(0.06))
            )
        }
    }
    
    // MARK: - Control Center Glass Pod
    
    private func controlPod(
        title: String,
        subtitle: String,
        systemImage: String,
        isOn: Bool,
        isBusy: Bool,
        onToggle: @escaping () -> Void
    ) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // Circular Control Center Icon Badge
            ZStack {
                Circle()
                    .fill(isOn ? Color.accentColor : Color.primary.opacity(0.08))
                    .frame(width: 34, height: 34)
                
                Image(systemName: systemImage)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(isOn ? .white : .secondary)
            }
            
            // Titles & Description (No text truncation)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 4)
            
            // Toggle Switch or Spinner
            if isBusy {
                ProgressView()
                    .scaleEffect(0.65)
                    .frame(width: 38, height: 22)
            } else {
                Toggle("", isOn: Binding(
                    get: { isOn },
                    set: { _ in onToggle() }
                ))
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .labelsHidden()
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.45))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.14), lineWidth: 0.5)
                )
        )
    }
    
    // MARK: - Status Pod (Diagnostics Glass Tile)
    
    private var statusPod: some View {
        VStack(spacing: 8) {
            // Row 1: Lid Sensor
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: viewModel.isLidClosed ? "macbook.gen2" : "macbook")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Text("Sensor de tapa")
                        .font(.system(size: 11.5, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Circle()
                        .fill(viewModel.isLidClosed ? Color.orange : Color.green)
                        .frame(width: 6, height: 6)
                    
                    Text(viewModel.isLidClosed ? "Cerrada" : "Abierta")
                        .font(.system(size: 11.5, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
            
            Divider()
                .opacity(0.3)
            
            // Row 2: Hub & Services
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "cable.connector.horizontal")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Text("Hub USB & servicios")
                        .font(.system(size: 11.5, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    if viewModel.isKeepAwakeEnabled {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.green)
                    }
                    Text(viewModel.isKeepAwakeEnabled ? "Siempre activos" : "Modo normal")
                        .font(.system(size: 11.5, weight: .medium))
                        .foregroundColor(viewModel.isKeepAwakeEnabled ? .primary : .secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
        )
    }
    
    // MARK: - Error Banner
    
    private func errorBanner(message: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 12))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.system(size: 11))
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.orange.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.orange.opacity(0.2), lineWidth: 0.5)
                )
        )
    }
    
    // MARK: - Footer
    
    private var footerSection: some View {
        HStack {
            Text("v1.2")
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.secondary.opacity(0.6))
            
            Spacer()
            
            Button("Salir") {
                PowerManager.shared.restoreOnQuit()
                BrightnessController.shared.restoreOnQuit()
                AudioManager.shared.restoreOnQuit()
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.primary.opacity(0.06))
            )
        }
    }
}

// Native macOS visual effect helper
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
