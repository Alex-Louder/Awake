import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            headerSection
            
            Divider()
                .padding(.horizontal, 14)
            
            // Primary Controls
            VStack(spacing: 10) {
                // Control 1: Clamshell Keep-Awake
                keepAwakeControlRow
                
                // Control 2: Mute Audio on Lid Close
                muteAudioControlRow
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            
            Divider()
                .padding(.horizontal, 14)
            
            // Live Status Diagnostics
            statusSection
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            
            if let error = viewModel.errorMessage {
                errorBanner(message: error)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 8)
            }
            
            Divider()
            
            // Footer
            footerSection
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
        }
        .frame(width: 300)
        .background(VisualEffectView(material: .popover, blendingMode: .behindWindow))
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: viewModel.isKeepAwakeEnabled ? "laptopcomputer" : "laptopcomputer")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(viewModel.isKeepAwakeEnabled ? .primary : .secondary)
                
                Text("ClamAwake")
                    .font(.system(size: 13, weight: .semibold, design: .default))
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Status Pill
            HStack(spacing: 5) {
                Circle()
                    .fill(viewModel.isKeepAwakeEnabled ? Color.green : Color.secondary.opacity(0.4))
                    .frame(width: 6, height: 6)
                
                Text(viewModel.isKeepAwakeEnabled ? "ACTIVO" : "INACTIVO")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(viewModel.isKeepAwakeEnabled ? .primary : .secondary)
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(viewModel.isKeepAwakeEnabled ? Color.green.opacity(0.12) : Color.primary.opacity(0.05))
            )
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
    
    // MARK: - Control 1: Keep Awake
    
    private var keepAwakeControlRow: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "bolt.shield")
                .font(.system(size: 14))
                .foregroundColor(viewModel.isKeepAwakeEnabled ? .accentColor : .secondary)
                .frame(width: 20, height: 20)
                .padding(.top, 1)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Mantener activa al cerrar tapa")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                
                Text("La Mac continúa funcionando. Los puertos USB, hubs y procesos siguen activos.")
                    .font(.system(size: 10.5))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 8)
            
            if viewModel.isBusy {
                ProgressView()
                    .scaleEffect(0.65)
                    .frame(width: 38, height: 22)
            } else {
                Toggle("", isOn: Binding(
                    get: { viewModel.isKeepAwakeEnabled },
                    set: { _ in viewModel.toggleKeepAwake() }
                ))
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .labelsHidden()
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.primary.opacity(viewModel.isKeepAwakeEnabled ? 0.04 : 0.02))
        )
    }
    
    // MARK: - Control 2: Mute Audio
    
    private var muteAudioControlRow: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "speaker.slash")
                .font(.system(size: 14))
                .foregroundColor(viewModel.isMuteOnLidCloseEnabled ? .accentColor : .secondary)
                .frame(width: 20, height: 20)
                .padding(.top, 1)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Silenciar sonido al cerrar tapa")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                
                Text("Pausa la música y silencia el audio automáticamente cuando la tapa se cierra.")
                    .font(.system(size: 10.5))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 8)
            
            Toggle("", isOn: Binding(
                get: { viewModel.isMuteOnLidCloseEnabled },
                set: { _ in viewModel.toggleMuteOnLidClose() }
            ))
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .labelsHidden()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.primary.opacity(viewModel.isMuteOnLidCloseEnabled ? 0.04 : 0.02))
        )
    }
    
    // MARK: - Status Indicators
    
    private var statusSection: some View {
        VStack(spacing: 6) {
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: viewModel.isLidClosed ? "macbook.gen2" : "macbook")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    
                    Text("Sensor de Tapa:")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(viewModel.isLidClosed ? Color.orange : Color.green)
                        .frame(width: 5, height: 5)
                    
                    Text(viewModel.isLidClosed ? "Cerrada" : "Abierta")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
            
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "cable.connector")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    
                    Text("Hub USB & Procesos:")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(viewModel.isKeepAwakeEnabled ? "Siempre Activos" : "Modo Estándar")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(viewModel.isKeepAwakeEnabled ? .primary : .secondary)
            }
        }
    }
    
    // MARK: - Error Banner
    
    private func errorBanner(message: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 11))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.system(size: 10.5))
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(7)
        .background(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color.orange.opacity(0.12))
        )
    }
    
    // MARK: - Footer
    
    private var footerSection: some View {
        HStack {
            Text("v1.0")
                .font(.system(size: 10))
                .foregroundColor(.secondary.opacity(0.7))
            
            Spacer()
            
            Button("Salir") {
                PowerManager.shared.restoreOnQuit()
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 11, weight: .regular))
            .foregroundColor(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
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
