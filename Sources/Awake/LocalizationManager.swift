import SwiftUI
import Combine

enum AppLanguage: String, CaseIterable, Identifiable {
    case spanish = "es"
    case english = "en"
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .spanish: return "ES"
        case .english: return "EN"
        }
    }
    
    var fullName: String {
        switch self {
        case .spanish: return "Español"
        case .english: return "English"
        }
    }
}

@MainActor
final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "awake.language")
        }
    }
    
    private init() {
        if let saved = UserDefaults.standard.string(forKey: "awake.language"),
           let lang = AppLanguage(rawValue: saved) {
            self.currentLanguage = lang
        } else {
            let locale = Locale.current.language.languageCode?.identifier ?? "es"
            self.currentLanguage = locale.starts(with: "en") ? .english : .spanish
        }
    }
    
    // MARK: - Menu View Strings
    
    var awakeTitle: String { "Awake!" }
    var awakeSubtitle: String {
        currentLanguage == .spanish ? "Mantén despierta tu mac" : "Keep your Mac awake"
    }
    
    var shhTitle: String { "Shh!" }
    var shhSubtitle: String {
        currentLanguage == .spanish ? "Silenciar al cerrar" : "Mute on lid close"
    }
    
    var statusActive: String {
        currentLanguage == .spanish ? "ACTIVO" : "ACTIVE"
    }
    var statusInactive: String {
        currentLanguage == .spanish ? "INACTIVO" : "INACTIVE"
    }
    
    var lidPrefix: String {
        currentLanguage == .spanish ? "Tapa:" : "Lid:"
    }
    var lidOpen: String {
        currentLanguage == .spanish ? "Abierta" : "Open"
    }
    var lidClosed: String {
        currentLanguage == .spanish ? "Cerrada" : "Closed"
    }
    
    var usbPrefix: String { "USB:" }
    var usbActive: String {
        currentLanguage == .spanish ? "Activo" : "Active"
    }
    var usbNormal: String {
        currentLanguage == .spanish ? "Normal" : "Normal"
    }
    
    var guideButton: String {
        currentLanguage == .spanish ? "Guía" : "Guide"
    }
    var supportButton: String {
        currentLanguage == .spanish ? "Apoyar" : "Support"
    }
    var quitButton: String {
        currentLanguage == .spanish ? "Salir" : "Quit"
    }
    
    // MARK: - Onboarding View Strings
    
    var onboardingTagline: String {
        currentLanguage == .spanish
            ? "Tu Mac sigue funcionando con la tapa cerrada."
            : "Keep your Mac running with the lid closed."
    }
    
    var awakeFeatureDescription: String {
        currentLanguage == .spanish
            ? "Tu Mac no entra en reposo al cerrar la tapa. Mantiene activos descargas, discos USB, procesos y escritorios remotos (Sills, VNC) sin requerir pantallas externas."
            : "Your Mac won't sleep when closing the lid. Keeps downloads, USB drives, background tasks, and remote desktops (Sills, VNC) running without external displays."
    }
    
    var shhFeatureDescription: String {
        currentLanguage == .spanish
            ? "Pausa automáticamente la música o videos y silencia el sonido en AirPods, audífonos o altavoces cada vez que cierras la tapa."
            : "Automatically pauses music or videos and silences audio across AirPods, headphones, or external speakers whenever you close the lid."
    }
    
    var permissionTitle: String {
        currentLanguage == .spanish ? "Permiso de suspensión (pmset)" : "Sleep permission (pmset)"
    }
    
    var permissionConfigured: String {
        currentLanguage == .spanish ? "Configurado" : "Configured"
    }
    
    var permissionAuthorizeBtn: String {
        currentLanguage == .spanish ? "Autorizar (1 clic)" : "Authorize (1 click)"
    }
    
    var permissionReadyDesc: String {
        currentLanguage == .spanish
            ? "El comando del sistema está listo. Awake! alternará el reposo sin pedir contraseñas."
            : "System command is ready. Awake! will toggle sleep without asking for passwords."
    }
    
    var permissionNotReadyDesc: String {
        currentLanguage == .spanish
            ? "Para cambiar la suspensión al instante sin solicitar contraseñas cada vez, autoriza una sola vez."
            : "To toggle sleep instantly without entering passwords each time, authorize once."
    }
    
    var startButton: String {
        currentLanguage == .spanish ? "Empezar a usar Awake!" : "Start using Awake!"
    }
    
    var menuBarHint: String {
        currentLanguage == .spanish
            ? "Awake! vive discretamente en la barra de menú superior."
            : "Awake! lives discreetly in your top menu bar."
    }
    
    // MARK: - Tip Jar / Support Strings ($1, $3, $5)
    
    var supportSheetTitle: String {
        currentLanguage == .spanish ? "Apoyar Awake!" : "Support Awake!"
    }
    
    var supportSheetSubtitle: String {
        currentLanguage == .spanish
            ? "Tu propina ayuda a que Awake! siga mejorando, sea 100% nativa y sin anuncios."
            : "Your tip helps keep Awake! improving, 100% native, and completely ad-free."
    }
    
    var tip1Title: String {
        currentLanguage == .spanish ? "Gracias por tu apoyo" : "Thanks for your support"
    }
    var tip1Subtitle: String {
        currentLanguage == .spanish ? "Impulsa el desarrollo continuo" : "Fuels everyday development"
    }
    
    var tip3Title: String {
        currentLanguage == .spanish ? "¡Muchas gracias!" : "Thank you so much!"
    }
    var tip3Subtitle: String {
        currentLanguage == .spanish ? "Un gran gesto de agradecimiento" : "A great token of appreciation"
    }
    
    var tip5Title: String {
        currentLanguage == .spanish ? "¡Muchísimas gracias!" : "Thank you very much!"
    }
    var tip5Subtitle: String {
        currentLanguage == .spanish ? "Patrocinador oficial de Awake!" : "Official Awake! champion"
    }
    
    var thankYouMessage: String {
        currentLanguage == .spanish ? "¡Muchísimas gracias por tu apoyo! ☕️" : "Thank you so much for your support! ☕️"
    }
    
    var kofiDonationBtn: String {
        currentLanguage == .spanish ? "Donar en Ko-fi (0% comisión)" : "Donate on Ko-fi (0% fee)"
    }
    
    var webDonationBtn: String {
        currentLanguage == .spanish ? "Donar vía Web / Ko-fi" : "Donate via Web / Ko-fi"
    }
    
    var closeButton: String {
        currentLanguage == .spanish ? "Cerrar" : "Close"
    }
}
