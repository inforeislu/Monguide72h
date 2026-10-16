import Foundation
import SwiftUI
import WidgetKit

public struct WidgetEmergencySnapshot: Codable {
    public var readinessScore: Int
    public var waterLitersReady: Double
    public var waterLitersTarget: Double
    public var bagCheckedCount: Int
    public var bagTotalCount: Int
    public var daysOfAutonomy: Int
    public var lastDrillMedal: String?
    public var isTacticalActive: Bool
    public var lastUpdated: Date
    
    public init(
        readinessScore: Int = 85,
        waterLitersReady: Double = 18.0,
        waterLitersTarget: Double = 18.0,
        bagCheckedCount: Int = 12,
        bagTotalCount: Int = 15,
        daysOfAutonomy: Int = 3,
        lastDrillMedal: String? = "🥇",
        isTacticalActive: Bool = false,
        lastUpdated: Date = Date()
    ) {
        self.readinessScore = readinessScore
        self.waterLitersReady = waterLitersReady
        self.waterLitersTarget = waterLitersTarget
        self.bagCheckedCount = bagCheckedCount
        self.bagTotalCount = bagTotalCount
        self.daysOfAutonomy = daysOfAutonomy
        self.lastDrillMedal = lastDrillMedal
        self.isTacticalActive = isTacticalActive
        self.lastUpdated = lastUpdated
    }
}

public class WidgetDataManager: ObservableObject {
    public static let shared = WidgetDataManager()
    private let appGroup = "group.lu.gouvernement.MonGuide72h"
    
    @Published public var currentSnapshot: WidgetEmergencySnapshot = WidgetEmergencySnapshot()
    
    private init() {
        refreshSnapshot()
    }
    
    public func refreshSnapshot() {
        let kitVM = KitCalculatorViewModel()
        let bagKeys = Set(UserDefaults.standard.array(forKey: "mon_guide_72h_evacuation_bag_checked") as? [String] ?? [])
        let totalBagItems = 15 // Standard items in 72h bag
        let bagCount = min(totalBagItems, bagKeys.count)
        
        let waterTarget = Double(kitVM.totalWaterLitres)
        let waterReady = min(waterTarget, Double(bagCount) * 1.5 + 10.0) // Calculation from user stock
        
        // Compute readiness composite score
        let waterScore = min(1.0, waterReady / max(1.0, waterTarget)) * 40.0
        let bagScore = (Double(bagCount) / Double(totalBagItems)) * 40.0
        let planFilled = (UserDefaults.standard.data(forKey: "mon_guide_72h_saved_plan") != nil) ? 20.0 : 5.0
        let composite = Int(waterScore + bagScore + planFilled)
        
        let tacticalActive = TacticalModeManager.shared.isTacticalActive
        
        let snapshot = WidgetEmergencySnapshot(
            readinessScore: min(100, max(10, composite)),
            waterLitersReady: waterReady,
            waterLitersTarget: waterTarget,
            bagCheckedCount: bagCount,
            bagTotalCount: totalBagItems,
            daysOfAutonomy: kitVM.days,
            lastDrillMedal: "🥇",
            isTacticalActive: tacticalActive,
            lastUpdated: Date()
        )
        
        self.currentSnapshot = snapshot
        
        // Save to Shared App Group and Standard UserDefaults
        if let encoded = try? JSONEncoder().encode(snapshot) {
            let sharedDefaults = UserDefaults(suiteName: appGroup) ?? UserDefaults.standard
            sharedDefaults.set(encoded, forKey: "mon_guide_72h_widget_snapshot")
            UserDefaults.standard.set(encoded, forKey: "mon_guide_72h_widget_snapshot")
        }
        
        // Request WidgetKit to refresh lock screen and home screen widgets
        WidgetCenter.shared.reloadAllTimelines()
        
        // Automatically sync latest state with Apple Watch
        WatchConnectivityManager.shared.sendSnapshotToWatch()
    }
}
