import Foundation

public enum SirenType: String, CaseIterable, Identifiable {
    case monthlyTest = "test"
    case warning = "alert"
    case nationalAlarm = "alarm"
    case allClear = "end"
    
    public var id: String { rawValue }
    
    public var durationLabel: String {
        switch self {
        case .monthlyTest: return "60 SECONDES"
        case .warning: return "2 MINUTES"
        case .nationalAlarm: return "60 SECONDES"
        case .allClear: return "60 SECONDES (12s / PAUSE)"
        }
    }
}
