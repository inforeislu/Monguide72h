import Foundation
import SwiftUI
import Combine
import UIKit

public class TacticalModeManager: ObservableObject {
    public static let shared = TacticalModeManager()
    
    private let storageKey = "mon_guide_72h_tactical_mode_active"
    private var originalBrightness: CGFloat = 0.5
    
    @Published public var isTacticalActive: Bool {
        didSet {
            UserDefaults.standard.set(isTacticalActive, forKey: storageKey)
        }
    }
    
    @Published public var batteryLevel: Float = 1.0
    @Published public var batteryState: UIDevice.BatteryState = .unknown
    @Published public var isLowPowerMode: Bool = false
    
    private init() {
        self.isTacticalActive = UserDefaults.standard.bool(forKey: storageKey)
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        self.updateBatteryStatus()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryLevelDidChange),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateDidChange),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(powerStateDidChange),
            name: NSNotification.Name.NSProcessInfoPowerStateDidChange,
            object: nil
        )
    }
    
    public func toggleTacticalMode() {
        isTacticalActive.toggle()
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
    
    @objc private func batteryLevelDidChange() {
        updateBatteryStatus()
    }
    
    @objc private func batteryStateDidChange() {
        updateBatteryStatus()
    }
    
    @objc private func powerStateDidChange() {
        updateBatteryStatus()
    }
    
    public func updateBatteryStatus() {
        let level = UIDevice.current.batteryLevel
        self.batteryLevel = level >= 0 ? level : 1.0
        self.batteryState = UIDevice.current.batteryState
        self.isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    public var batteryPercentageString: String {
        let pct = Int(batteryLevel * 100)
        return "\(pct)%"
    }
    
    public var batteryIcon: String {
        if batteryState == .charging {
            return "battery.100.bolt"
        }
        if batteryLevel > 0.8 { return "battery.100" }
        if batteryLevel > 0.5 { return "battery.75" }
        if batteryLevel > 0.25 { return "battery.50" }
        return "battery.25"
    }
    
    public var batteryColor: Color {
        if isLowPowerMode { return .yellow }
        if batteryLevel > 0.3 { return .green }
        if batteryLevel > 0.15 { return .orange }
        return .red
    }
    
    /// Estimated battery life remaining in normal vs tactical mode
    public var estimatedRemainingHoursNormal: Int {
        let baseHours = 18.0
        return max(1, Int(Double(batteryLevel) * baseHours))
    }
    
    public var estimatedRemainingHoursTactical: Int {
        // Red OLED + low brightness uses 60-70% less display power
        let baseHours = 38.0
        return max(2, Int(Double(batteryLevel) * baseHours))
    }
}
