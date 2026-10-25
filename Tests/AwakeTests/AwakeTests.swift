import XCTest
@testable import Awake

final class AwakeTests: XCTestCase {
    func testLanguageSwitching() async throws {
        let loc = await LocalizationManager.shared
        await MainActor.run {
            loc.currentLanguage = .spanish
            XCTAssertEqual(loc.awakeSubtitle, "Mantén despierta tu mac")
            XCTAssertEqual(loc.shhSubtitle, "Silenciar al cerrar")
            XCTAssertEqual(loc.statusActive, "ACTIVO")
            XCTAssertEqual(loc.statusInactive, "INACTIVO")

            loc.currentLanguage = .english
            XCTAssertEqual(loc.awakeSubtitle, "Keep your Mac awake")
            XCTAssertEqual(loc.shhSubtitle, "Mute on lid close")
            XCTAssertEqual(loc.statusActive, "ACTIVE")
            XCTAssertEqual(loc.statusInactive, "INACTIVE")
        }
    }

    func testLanguageMetadata() {
        XCTAssertEqual(AppLanguage.spanish.label, "ES")
        XCTAssertEqual(AppLanguage.english.label, "EN")
        XCTAssertEqual(AppLanguage.spanish.fullName, "Español")
        XCTAssertEqual(AppLanguage.english.fullName, "English")
    }

    func testTipTierConfiguration() {
        XCTAssertEqual(TipTier.allCases.count, 3)
        XCTAssertEqual(TipTier.small.amountUSD, 1)
        XCTAssertEqual(TipTier.medium.amountUSD, 3)
        XCTAssertEqual(TipTier.large.amountUSD, 5)
        XCTAssertEqual(TipTier.small.rawValue, "com.playlouder.Awake.tip.1")
        XCTAssertEqual(TipTier.medium.rawValue, "com.playlouder.Awake.tip.3")
        XCTAssertEqual(TipTier.large.rawValue, "com.playlouder.Awake.tip.5")
    }

    func testPowerAssertionsLifecycle() {
        let pm = PowerManager.shared
        pm.acquirePowerAssertions()
        pm.releasePowerAssertions()
    }

    func testBrightnessController() {
        let bc = BrightnessController.shared
        let id = bc.getBuiltInDisplayID()
        XCTAssertNotNil(id)
    }

    func testAudioManagerSafeRouting() {
        let am = AudioManager.shared
        let defDevice = am.getDefaultOutputDevice()
        XCTAssertNotEqual(defDevice, 0)
        am.ensureUnmuted()
    }
}
