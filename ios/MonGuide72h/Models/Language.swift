import Foundation

public enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    // 24 Official European Union Languages + Luxembourgish (Civic regional)
    case fr // Français
    case pt // Português
    case en // English (EU Universal)
    case de // Deutsch
    case es // Español
    case it // Italiano
    case nl // Nederlands
    case pl // Polski
    case ro // Română
    case el // Ελληνικά
    case cs // Čeština
    case sv // Svenska
    case hu // Magyar
    case bg // Български
    case da // Dansk
    case fi // Suomi
    case sk // Slovenčina
    case hr // Hrvatski
    case lt // Lietuvių
    case sl // Slovenščina
    case lv // Latviešu
    case et // Eesti
    case ga // Gaeilge
    case mt // Malti
    case lu // Lëtzebuergesch (Luxembourg Regional)
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .fr: return "Français"
        case .pt: return "Português"
        case .en: return "English"
        case .de: return "Deutsch"
        case .es: return "Español"
        case .it: return "Italiano"
        case .nl: return "Nederlands"
        case .pl: return "Polski"
        case .ro: return "Română"
        case .el: return "Ελληνικά"
        case .cs: return "Čeština"
        case .sv: return "Svenska"
        case .hu: return "Magyar"
        case .bg: return "Български"
        case .da: return "Dansk"
        case .fi: return "Suomi"
        case .sk: return "Slovenčina"
        case .hr: return "Hrvatski"
        case .lt: return "Lietuvių"
        case .sl: return "Slovenščina"
        case .lv: return "Latviešu"
        case .et: return "Eesti"
        case .ga: return "Gaeilge"
        case .mt: return "Malti"
        case .lu: return "Lëtzebuergesch"
        }
    }
    
    public var flag: String {
        switch self {
        case .fr: return "🇫🇷"
        case .pt: return "🇵🇹"
        case .en: return "🇪🇺"
        case .de: return "🇩🇪"
        case .es: return "🇪🇸"
        case .it: return "🇮🇹"
        case .nl: return "🇳🇱"
        case .pl: return "🇵🇱"
        case .ro: return "🇷🇴"
        case .el: return "🇬🇷"
        case .cs: return "🇨🇿"
        case .sv: return "🇸🇪"
        case .hu: return "🇭🇺"
        case .bg: return "🇧🇬"
        case .da: return "🇩🇰"
        case .fi: return "🇫🇮"
        case .sk: return "🇸🇰"
        case .hr: return "🇭🇷"
        case .lt: return "🇱🇹"
        case .sl: return "🇸🇮"
        case .lv: return "🇱🇻"
        case .et: return "🇪🇪"
        case .ga: return "🇮🇪"
        case .mt: return "🇲🇹"
        case .lu: return "🇱🇺"
        }
    }
}
