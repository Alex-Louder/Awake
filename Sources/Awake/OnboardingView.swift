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
    var onOpenTipJar: (() -> Void)? = nil
    
    @StateObject private var viewModel = OnboardingViewModel()
    @ObservedObject private var loc = LocalizationManager.shared
    
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
                    title: loc.awakeTitle,
                    subtitle: loc.awakeSubtitle,
                    description: loc.awakeFeatureDescription
                )
                
                featureCard(
                    icon: "speaker.slash.fill",
                    iconColor: Color(red: 0.0, green: 0.48, blue: 1.0),
                    title: loc.shhTitle,
                    subtitle: loc.shhSubtitle,
                    description: loc.shhFeatureDescription
                )
            }
            .padding(.top, 18)
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
        .frame(width: 400, height: 520)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack(spacing: 14) {
            appIconView
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("Awake!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.1")")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundColor(Color.white.opacity(0.5))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.12))
                        )
                }
                
                Text(loc.onboardingTagline)
                    .font(.system(size: 11.5, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Language Toggle (ES / EN)
            languageSelector
        }
    }
    
    private var appIconView: some View {
        Group {
            if let path = Bundle.main.path(forResource: "Memoji", ofType: "png"),
               let nsImg = NSImage(contentsOfFile: path) {
                Image(nsImage: nsImg)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
            } else if let resourcePath = Bundle.main.resourcePath,
                      let nsImg = NSImage(contentsOfFile: (resourcePath as NSString).appendingPathComponent("Memoji.png")) {
                Image(nsImage: nsImg)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
            } else if let fallbackImg = NSImage(contentsOfFile: "/Users/playlouder/.gemini/antigravity/scratch/ClamAwake/Resources/Memoji.png") {
                Image(nsImage: fallbackImg)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
            } else {
                MacBookAIconView(size: 38)
            }
        }
    }
    
    private var languageSelector: some View {
        HStack(spacing: 2) {
            Button(action: { loc.currentLanguage = .spanish }) {
                Text("ES")
                    .font(.system(size: 9.5, weight: .bold))
                    .foregroundColor(loc.currentLanguage == .spanish ? .white : .white.opacity(0.45))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(loc.currentLanguage == .spanish ? Color(red: 0.0, green: 0.48, blue: 1.0) : Color.clear)
                    )
            }
            .buttonStyle(.plain)
            
            Button(action: { loc.currentLanguage = .english }) {
                Text("EN")
                    .font(.system(size: 9.5, weight: .bold))
                    .foregroundColor(loc.currentLanguage == .english ? .white : .white.opacity(0.45))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(loc.currentLanguage == .english ? Color(red: 0.0, green: 0.48, blue: 1.0) : Color.clear)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(2)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.12))
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                )
        )
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
                
                Text(loc.permissionTitle)
                    .font(.system(size: 11.5, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if viewModel.isPermissionReady {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.85, blue: 0.55))
                            .frame(width: 5, height: 5)
                        Text(loc.permissionConfigured)
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
                            Text(loc.permissionAuthorizeBtn)
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
            
            Text(viewModel.isPermissionReady ? loc.permissionReadyDesc : loc.permissionNotReadyDesc)
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
                    Text(loc.startButton)
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
            
            HStack {
                Text(loc.menuBarHint)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.white.opacity(0.45))
                
                Spacer()
                
                if let openTip = onOpenTipJar {
                    Button(action: openTip) {
                        HStack(spacing: 3) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color(red: 0.95, green: 0.35, blue: 0.45))
                            Text(loc.supportButton)
                        }
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
