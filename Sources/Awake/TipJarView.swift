import SwiftUI

struct TipJarView: View {
    var onDismiss: () -> Void
    
    @ObservedObject private var store = TipJarStore.shared
    @ObservedObject private var loc = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
                .padding(.top, 22)
                .padding(.horizontal, 22)
            
            // Tiers
            VStack(spacing: 10) {
                ForEach(TipTier.allCases) { tier in
                    tierButton(tier: tier)
                }
            }
            .padding(.top, 18)
            .padding(.horizontal, 22)
            
            if store.purchaseSuccess {
                thankYouBanner
                    .padding(.top, 12)
                    .padding(.horizontal, 22)
            } else if let error = store.errorMessage {
                errorBanner(message: error)
                    .padding(.top, 12)
                    .padding(.horizontal, 22)
            }
            
            Spacer(minLength: 14)
            
            // Footer
            footer
                .padding(.horizontal, 22)
                .padding(.bottom, 20)
        }
        .frame(width: 360, height: 430)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(white: 0.20).opacity(0.6))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.95, green: 0.35, blue: 0.45))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(loc.supportSheetTitle)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                
                Text(loc.supportSheetSubtitle)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.65))
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Tier Button
    
    private func tierButton(tier: TipTier) -> some View {
        Button(action: {
            Task {
                await store.purchase(tier: tier)
            }
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(tier.color.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: tier.symbol)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(tier.color)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(titleForTier(tier))
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(subtitleForTier(tier))
                        .font(.system(size: 10.5, weight: .medium))
                        .foregroundColor(.white.opacity(0.65))
                }
                
                Spacer()
                
                Text("$\(tier.amountUSD)")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.12))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                            )
                    )
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, minHeight: 52)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(white: 0.18).opacity(0.45))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
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
        .disabled(store.isPurchasing)
    }
    
    private func titleForTier(_ tier: TipTier) -> String {
        switch tier {
        case .small: return loc.currentLanguage == .spanish ? "Un Café" : "A Coffee"
        case .medium: return loc.currentLanguage == .spanish ? "Super Café" : "Super Coffee"
        case .large: return loc.currentLanguage == .spanish ? "Mega Apoyo" : "Mega Support"
        }
    }
    
    private func subtitleForTier(_ tier: TipTier) -> String {
        switch tier {
        case .small: return loc.currentLanguage == .spanish ? "Impulsa el desarrollo continuo" : "Fuels everyday development"
        case .medium: return loc.currentLanguage == .spanish ? "Un gran gesto de agradecimiento" : "A great token of appreciation"
        case .large: return loc.currentLanguage == .spanish ? "Patrocinador oficial de Awake!" : "Official Awake! champion"
        }
    }
    
    // MARK: - Banners
    
    private var thankYouBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.55))
            
            Text(loc.thankYouMessage)
                .font(.system(size: 11.5, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(red: 0.2, green: 0.85, blue: 0.55).opacity(0.2))
        )
    }
    
    private func errorBanner(message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            
            Text(message)
                .font(.system(size: 10.5))
                .foregroundColor(.white)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.orange.opacity(0.2))
        )
    }
    
    // MARK: - Footer
    
    private var footer: some View {
        HStack {
            Button(action: { store.openWebDonation() }) {
                HStack(spacing: 4) {
                    Image(systemName: "safari")
                    Text(loc.webDonationBtn)
                }
                .font(.system(size: 10.5, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button(action: onDismiss) {
                Text(loc.closeButton)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.12))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                            )
                    )
            }
            .buttonStyle(.plain)
        }
    }
}
