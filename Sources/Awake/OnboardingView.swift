import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var isPermissionReady: Bool = false
    @Published var isAuthorizing: Bool = false
    @Published var authorizationError: String? = nil
    
    init() {
        checkPermissionStatus()
    }
    
    func checkPermissionStatus() {
        isPermissionReady = PowerManager.shared.isPasswordlessSudoConfigured()
    }
    
    func authorizePermission() {
        isAuthorizing = true
        authorizationError = nil
        
        Task {
            do {
                try await PowerManager.shared.setupPasswordlessSudo()
                await MainActor.run {
                    self.isAuthorizing = false
                    self.isPermissionReady = PowerManager.shared.isPasswordlessSudoConfigured()
                }
            } catch {
                await MainActor.run {
                    self.isAuthorizing = false
                    self.authorizationError = error.localizedDescription
                }
            }
        }
    }
}

struct OnboardingView: View {
    var onDismiss: () -> Void
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
                .padding(.top, 24)
                .padding(.horizontal, 24)
            
            // Feature cards
            VStack(spacing: 12) {
                featureCard(
                    icon: "bolt.shield.fill",
                    iconColor: Color(red: 0.0, green: 0.48, blue: 1.0),
                    title: "Awake!",
                    subtitle: "Mantén despierta tu mac",
                    description: "Tu Mac no entra en reposo al cerrar la tapa. Mantiene activos procesador, descargas, discos USB y escritorios remotos (Sills, VNC) sin requerir pantallas externas."
                )
                
                featureCard(
                    icon: "speaker.slash.fill",
                    iconColor: Color(red: 0.0, green: 0.48, blue: 1.0),
                    title: "Shh!",
                    subtitle: "Silencio al cerrar",
                    description: "Pausa automáticamente la música o videos en reproducción y silencia tanto los altavoces internos como interfaces de audio USB (Scarlett, Focusrite, etc.)."
                )
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)
            
            // System Permission Card
            permissionSection
                .padding(.top, 14)
                .padding(.horizontal, 24)
            
            Spacer(minLength: 16)
            
            // Bottom Action
            bottomBar
                .padding(.horizontal, 24)
                .padding(.bottom, 22)
        }
        .frame(width: 390, height: 500)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack(spacing: 14) {
            MacBookAIconView(size: 38)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("Awake!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("v1.0")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundColor(Color.white.opacity(0.5))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.12))
                        )
                }
                
                Text("Tu Mac sigue funcionando con la tapa cerrada.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
    }
    
    // MARK: - Feature Card
    
    private func featureCard(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        description: String
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 34, height: 34)
                
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("•")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.4))
                    
                    Text(subtitle)
                        .font(.system(size: 11.5, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Text(description)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.65))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(white: 0.18).opacity(0.45))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.45), Color.white.opacity(0.12)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.75
                        )
                )
        )
    }
    
    // MARK: - Permission Section
    
    private var permissionSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: viewModel.isPermissionReady ? "checkmark.seal.fill" : "lock.shield.fill")
                    .font(.system(size: 13))
                    .foregroundColor(viewModel.isPermissionReady ? Color(red: 0.2, green: 0.85, blue: 0.55) : Color.orange)
                
                Text("Permiso de suspensión (pmset)")
                    .font(.system(size: 11.5, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if viewModel.isPermissionReady {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.85, blue: 0.55))
                            .frame(width: 5, height: 5)
                        Text("Configurado")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.55))
                    }
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.15))
                    )
                } else {
                    Button(action: { viewModel.authorizePermission() }) {
                        if viewModel.isAuthorizing {
                            ProgressView()
                                .scaleEffect(0.6)
                                .frame(width: 50, height: 18)
                        } else {
                            Text("Autorizar (1 clic)")
                                .font(.system(size: 10.5, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3.5)
                                .background(
                                    Capsule()
                                        .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                                )
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isAuthorizing)
                }
            }
            
            Text(viewModel.isPermissionReady
                 ? "El comando del sistema está listo. Awake! alternará el reposo sin pedir contraseñas."
                 : "Para cambiar la suspensión al instante sin solicitar contraseñas cada vez, autoriza una sola vez.")
                .font(.system(size: 10.5, weight: .regular))
                .foregroundColor(.white.opacity(0.55))
                .lineLimit(2)
            
            if let error = viewModel.authorizationError {
                Text(error)
                    .font(.system(size: 9.5))
                    .foregroundColor(.orange)
            }
        }
        .padding(11)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(white: 0.14).opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.6)
                )
        )
    }
    
    // MARK: - Bottom Bar
    
    private var bottomBar: some View {
        VStack(spacing: 8) {
            Button(action: onDismiss) {
                HStack {
                    Spacer()
                    Text("Empezar a usar Awake!")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .frame(height: 34)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(red: 0.0, green: 0.48, blue: 1.0))
                )
            }
            .buttonStyle(.plain)
            
            Text("Awake! vive discretamente en la barra de menú superior.")
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.white.opacity(0.45))
        }
    }
}
