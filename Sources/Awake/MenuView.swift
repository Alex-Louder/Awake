import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Top Header Card
            topHeaderCard
                .padding(.horizontal, 14)
                .padding(.top, 14)
                .padding(.bottom, 10)
            
            Divider()
                .opacity(0.4)
            
            // 2. Primary Quick-Action Row (Sun / Power banner)
            quickActionButton
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            
            Divider()
                .opacity(0.4)
            
            // 3. Scrollable/List Content
            VStack(spacing: 12) {
                // Section: BLOQUEOS
                assertionsSection
                
                // Section: ESTADO Y SENSORES
                diagnosticsSection
                
                // Section: AJUSTES
                settingsSection
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            
            if let error = viewModel.errorMessage {
                errorBanner(message: error)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 8)
            }
            
            // 4. Terminal Command Box (Monospace Caffeinate-style banner)
            terminalCommandPill
                .padding(.horizontal, 14)
                .padding(.bottom, 8)
            
            Divider()
                .opacity(0.4)
            
            // 5. Quit Row
            quitRow
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
        }
        .frame(width: 295)
        .background(VisualEffectView(material: .popover, blendingMode: .behindWindow))
    }
    
    // MARK: - 1. Top Header Card
    
    private var topHeaderCard: some View {
        HStack(spacing: 12) {
            Image(systemName: viewModel.isKeepAwakeEnabled ? "cup.and.saucer.fill" : "cup.and.saucer")
                .font(.system(size: 26, weight: .regular))
                .foregroundColor(viewModel.isKeepAwakeEnabled ? .primary : .secondary.opacity(0.8))
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.isKeepAwakeEnabled ? "Awake! Activo" : "Reposo permitido")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(viewModel.isKeepAwakeEnabled ? "La Mac permanecerá despierta al cerrar" : "La pantalla puede entrar en reposo...")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Circle()
                .fill(viewModel.isKeepAwakeEnabled ? Color.green : Color.secondary.opacity(0.35))
                .frame(width: 8, height: 8)
        }
    }
    
    // MARK: - 2. Quick Action Row
    
    private var quickActionButton: some View {
        Button(action: {
            viewModel.toggleKeepAwake()
        }) {
            HStack(spacing: 8) {
                Image(systemName: viewModel.isKeepAwakeEnabled ? "moon.stars.fill" : "sun.max.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(viewModel.isKeepAwakeEnabled ? .indigo : .orange)
                
                Text(viewModel.isKeepAwakeEnabled ? "Desactivar Awake!" : "Activar Awake!")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if viewModel.isBusy {
                    ProgressView()
                        .scaleEffect(0.6)
                        .frame(width: 20, height: 16)
                } else {
                    Text("⌘K")
                        .font(.system(size: 11, weight: .medium, design: .default))
                        .foregroundColor(.secondary.opacity(0.7))
                }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - 3. BLOQUEOS Section
    
    private var assertionsSection: some View {
        VStack(spacing: 7) {
            sectionHeader(title: "BLOQUEOS", icon: "slider.horizontal.3")
            
            // Row 1: Mantener activa al cerrar tapa
            menuRow(
                icon: "laptopcomputer",
                iconColor: .blue,
                title: "Evitar reposo con tapa",
                tag: "-pm",
                isOn: Binding(
                    get: { viewModel.isKeepAwakeEnabled },
                    set: { _ in viewModel.toggleKeepAwake() }
                )
            )
            
            // Row 2: Silenciar sonido
            menuRow(
                icon: "speaker.slash",
                iconColor: .cyan,
                title: "Silenciar sonido al cerrar",
                tag: "mute",
                isOn: Binding(
                    get: { viewModel.isMuteOnLidCloseEnabled },
                    set: { _ in viewModel.toggleMuteOnLidClose() }
                )
            )
            
            // Row 3: Evitar reposo de pantalla
            menuRow(
                icon: "display",
                iconColor: .blue,
                title: "Evitar reposo de pantalla",
                tag: "-d",
                isOn: Binding(
                    get: { viewModel.preventScreenSleep },
                    set: { _ in viewModel.togglePreventScreenSleep() }
                )
            )
        }
    }
    
    // MARK: - 4. ESTADO Y SENSORES Section
    
    private var diagnosticsSection: some View {
        VStack(spacing: 7) {
            sectionHeader(title: "ESTADO Y SENSORES", icon: "gauge.with.dots.needle.bottom.50percent")
            
            // Row 1: Sensor de tapa
            HStack(spacing: 8) {
                Image(systemName: "macbook.gen2")
                    .font(.system(size: 12))
                    .foregroundColor(.purple)
                    .frame(width: 18)
                
                Text("Sensor físico de tapa")
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(viewModel.isLidClosed ? Color.orange : Color.green)
                        .frame(width: 5, height: 5)
                    Text(viewModel.isLidClosed ? "Cerrada" : "Abierta")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 2)
            
            // Row 2: Hub USB y servicios
            HStack(spacing: 8) {
                Image(systemName: "cable.connector.horizontal")
                    .font(.system(size: 12))
                    .foregroundColor(.teal)
                    .frame(width: 18)
                
                Text("Hub USB & servicios")
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 3) {
                    if viewModel.isKeepAwakeEnabled {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.green)
                    }
                    Text(viewModel.isKeepAwakeEnabled ? "Protegidos" : "Normal")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(viewModel.isKeepAwakeEnabled ? .primary : .secondary)
                }
            }
            .padding(.vertical, 2)
        }
    }
    
    // MARK: - 5. AJUSTES Section
    
    private var settingsSection: some View {
        VStack(spacing: 7) {
            sectionHeader(title: "AJUSTES", icon: "gearshape")
            
            // Row 1: Abrir al iniciar sesión
            menuRow(
                icon: "power",
                iconColor: .secondary,
                title: "Abrir al iniciar sesión",
                tag: nil,
                isOn: Binding(
                    get: { viewModel.isLaunchAtLoginEnabled },
                    set: { _ in viewModel.toggleLaunchAtLogin() }
                )
            )
            
            // Row 2: Clic izquierdo para activar
            menuRow(
                icon: "cursorarrow.rays",
                iconColor: .secondary,
                title: "Clic izquierdo para activar",
                tag: nil,
                isOn: Binding(
                    get: { viewModel.leftClickToggles },
                    set: { _ in viewModel.toggleLeftClickMode() }
                )
            )
        }
    }
    
    // MARK: - Helper Views
    
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.8))
            
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.secondary.opacity(0.8))
            
            Spacer()
            
            Image(systemName: "chevron.down")
                .font(.system(size: 8, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(.bottom, 1)
    }
    
    private func menuRow(
        icon: String,
        iconColor: Color,
        title: String,
        tag: String?,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(iconColor)
                .frame(width: 18)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.primary)
            
            if let tag = tag {
                Text(tag)
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary.opacity(0.8))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(Color.primary.opacity(0.06))
                    .cornerRadius(3)
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .labelsHidden()
                .scaleEffect(0.85)
        }
        .padding(.vertical, 1)
    }
    
    // MARK: - Terminal Command Box
    
    private var terminalCommandPill: some View {
        HStack(spacing: 6) {
            Image(systemName: "terminal")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            
            Text(viewModel.isKeepAwakeEnabled ? "pmset -a disablesleep 1 -d -s" : "pmset -a disablesleep 0")
                .font(.system(size: 10, weight: .regular, design: .monospaced))
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.primary.opacity(0.12), lineWidth: 0.5)
                .background(Color.primary.opacity(0.03).cornerRadius(6))
        )
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
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.orange.opacity(0.12))
        )
    }
    
    // MARK: - Quit Row
    
    private var quitRow: some View {
        Button(action: {
            PowerManager.shared.restoreOnQuit()
            BrightnessController.shared.restoreOnQuit()
            AudioManager.shared.restoreOnQuit()
            NSApplication.shared.terminate(nil)
        }) {
            HStack(spacing: 8) {
                Image(systemName: "power")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Text("Salir de Awake!")
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("⌘Q")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary.opacity(0.7))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
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
