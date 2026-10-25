import Testing
@testable import Awake

@Suite("Awake Localization and Configuration Tests")
struct AwakeTests {
    @Test func testLanguageSwitching() async throws {
        let loc = await LocalizationManager.shared
        await MainActor.run {
            loc.currentLanguage = .spanish
            #expect(loc.awakeSubtitle == "Mantén despierta tu mac")
            #expect(loc.shhSubtitle == "Silenciar al cerrar")
            #expect(loc.statusActive == "ACTIVO")
            #expect(loc.statusInactive == "INACTIVO")

            loc.currentLanguage = .english
            #expect(loc.awakeSubtitle == "Keep your Mac awake")
            #expect(loc.shhSubtitle == "Mute on lid close")
            #expect(loc.statusActive == "ACTIVE")
            #expect(loc.statusInactive == "INACTIVE")
        }
    }

    @Test func testLanguageMetadata() {
        #expect(AppLanguage.spanish.label == "ES")
        #expect(AppLanguage.english.label == "EN")
        #expect(AppLanguage.spanish.fullName == "Español")
        #expect(AppLanguage.english.fullName == "English")
    }

    @Test func testTipTierConfiguration() {
        #expect(TipTier.allCases.count == 3)
        #expect(TipTier.small.amountUSD == 1)
        #expect(TipTier.medium.amountUSD == 3)
        #expect(TipTier.large.amountUSD == 5)
        #expect(TipTier.small.rawValue == "com.playlouder.Awake.tip.1")
        #expect(TipTier.medium.rawValue == "com.playlouder.Awake.tip.3")
        #expect(TipTier.large.rawValue == "com.playlouder.Awake.tip.5")
    }
}
