import Foundation
import StoreKit
import SwiftUI
import Combine

enum TipTier: String, CaseIterable, Identifiable {
    case small = "com.playlouder.Awake.tip.1"
    case medium = "com.playlouder.Awake.tip.3"
    case large = "com.playlouder.Awake.tip.5"
    
    var id: String { rawValue }
    
    var amountUSD: Int {
        switch self {
        case .small: return 1
        case .medium: return 3
        case .large: return 5
        }
    }
    
    var symbol: String {
        switch self {
        case .small: return "cup.and.saucer.fill"
        case .medium: return "heart.fill"
        case .large: return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .small: return Color(red: 0.95, green: 0.65, blue: 0.25)
        case .medium: return Color(red: 0.95, green: 0.35, blue: 0.45)
        case .large: return Color(red: 0.45, green: 0.65, blue: 0.95)
        }
    }
}

@MainActor
final class TipJarStore: ObservableObject {
    static let shared = TipJarStore()
    
    @Published var products: [Product] = []
    @Published var isPurchasing: Bool = false
    @Published var purchaseSuccess: Bool = false
    @Published var errorMessage: String? = nil
    
    private var updatesTask: Task<Void, Never>?
    
    private init() {
        listenForTransactions()
        Task {
            await loadProducts()
        }
    }
    
    deinit {
        updatesTask?.cancel()
    }
    
    func loadProducts() async {
        do {
            let productIDs = TipTier.allCases.map(\.rawValue)
            self.products = try await Product.products(for: productIDs)
        } catch {
            // StoreKit might fail in local non-AppStore environments
            self.products = []
        }
    }
    
    func purchase(tier: TipTier) async {
        isPurchasing = true
        errorMessage = nil
        
        // 1. Native StoreKit 2 Purchase
        if let product = products.first(where: { $0.id == tier.rawValue }) {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        await transaction.finish()
                        self.purchaseSuccess = true
                        self.isPurchasing = false
                        UserDefaults.standard.set(true, forKey: "awake.hasDonated")
                    case .unverified(_, let error):
                        self.errorMessage = error.localizedDescription
                        self.isPurchasing = false
                    }
                case .userCancelled:
                    self.isPurchasing = false
                case .pending:
                    self.isPurchasing = false
                @unknown default:
                    self.isPurchasing = false
                }
            } catch {
                self.errorMessage = error.localizedDescription
                self.isPurchasing = false
            }
            return
        }
        
        // 2. Direct Ko-fi fallback when running outside Mac App Store
        isPurchasing = false
        openKofiDonation()
    }
    
    func openKofiDonation() {
        let kofiBase = UserDefaults.standard.string(forKey: "awake.kofiUrl") ?? "https://ko-fi.com/alexlouder"
        if let url = URL(string: kofiBase) {
            NSWorkspace.shared.open(url)
            self.purchaseSuccess = true
        }
    }
    
    func openWebDonation(amount: Int? = nil) {
        let base = UserDefaults.standard.string(forKey: "awake.donationUrl") ?? "https://ko-fi.com/alexlouder"
        if let url = URL(string: base) {
            NSWorkspace.shared.open(url)
            self.purchaseSuccess = true
        }
    }
    
    private func listenForTransactions() {
        updatesTask = Task.detached { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await MainActor.run {
                        self?.purchaseSuccess = true
                    }
                }
            }
        }
    }
}
