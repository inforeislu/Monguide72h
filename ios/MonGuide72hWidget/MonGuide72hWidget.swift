//
//  MonGuide72hWidget.swift
//  MonGuide72hWidget
//
//  Created by iNFOREIS on 15/10/2026.
//  Official Luxembourg Civil Protection (HCPN / Lëtz Prepare!) Widgets
//

import WidgetKit
import SwiftUI

// MARK: - SHARED EMERGENCY SNAPSHOT

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

// MARK: - TIMELINE PROVIDER

struct EmergencyWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetEmergencySnapshot
}

struct Provider: TimelineProvider {
    private let appGroup = "group.lu.gouvernement.MonGuide72h"
    
    private func loadSnapshot() -> WidgetEmergencySnapshot {
        let defaults = UserDefaults(suiteName: appGroup) ?? UserDefaults.standard
        if let data = defaults.data(forKey: "mon_guide_72h_widget_snapshot"),
           let decoded = try? JSONDecoder().decode(WidgetEmergencySnapshot.self, from: data) {
            return decoded
        }
        return WidgetEmergencySnapshot()
    }
    
    func placeholder(in context: Context) -> EmergencyWidgetEntry {
        EmergencyWidgetEntry(date: Date(), snapshot: WidgetEmergencySnapshot())
    }

    func getSnapshot(in context: Context, completion: @escaping (EmergencyWidgetEntry) -> ()) {
        completion(EmergencyWidgetEntry(date: Date(), snapshot: loadSnapshot()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EmergencyWidgetEntry>) -> ()) {
        let current = EmergencyWidgetEntry(date: Date(), snapshot: loadSnapshot())
        // Refresh every 30 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
        let timeline = Timeline(entries: [current], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - WIDGET VIEWS

struct MonGuide72hWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    private var blueLux: Color {
        Color(red: 0/255, green: 43/255, blue: 73/255)
    }
    
    private var redLux: Color {
        Color(red: 234/255, green: 40/255, blue: 57/255)
    }

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidgetView
        case .systemMedium:
            mediumWidgetView
        case .accessoryCircular:
            lockScreenCircularView
        case .accessoryRectangular:
            lockScreenRectangularView
        case .accessoryInline:
            lockScreenInlineView
        default:
            smallWidgetView
        }
    }
    
    // MARK: - SYSTEM SMALL (1x1 Home Screen)
    private var smallWidgetView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                ZStack {
                    Circle()
                        .fill(blueLux)
                        .frame(width: 24, height: 24)
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
                Spacer()
                Text("72h")
                    .font(.caption2.bold())
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(blueLux.opacity(0.12))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            Text("\(entry.snapshot.readinessScore)%")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundColor(entry.snapshot.readinessScore >= 80 ? .green : (entry.snapshot.readinessScore >= 50 ? .orange : redLux))
            
            Text("Préparation Civile")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                Label("\(Int(entry.snapshot.waterLitersReady))L", systemImage: "drop.fill")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.blue)
                Label("\(entry.snapshot.bagCheckedCount)/\(entry.snapshot.bagTotalCount)", systemImage: "backpack.fill")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.orange)
            }
        }
        .padding(12)
    }
    
    // MARK: - SYSTEM MEDIUM (2x1 Home Screen)
    private var mediumWidgetView: some View {
        HStack(spacing: 14) {
            // Left score card
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "shield.checkered")
                        .foregroundColor(blueLux)
                    Text("MON GUIDE 72H")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(blueLux)
                }
                
                Spacer()
                
                Text("\(entry.snapshot.readinessScore)%")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(entry.snapshot.readinessScore >= 80 ? .green : (entry.snapshot.readinessScore >= 50 ? .orange : redLux))
                
                Text("Autonomie: \(entry.snapshot.daysOfAutonomy) Jours")
                    .font(.caption2.bold())
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            // Right quick stats & emergency shortcuts
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Eau Potable")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                        Text("\(Int(entry.snapshot.waterLitersReady)) / \(Int(entry.snapshot.waterLitersTarget)) L")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Sac 72h")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                        Text("\(entry.snapshot.bagCheckedCount)/\(entry.snapshot.bagTotalCount) Prêts")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 9))
                        Text("112 Secours")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(redLux)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 9))
                        Text("LU-Alert")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(blueLux)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
    }
    
    // MARK: - LOCK SCREEN CIRCULAR
    private var lockScreenCircularView: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 1) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 12))
                Text("\(entry.snapshot.readinessScore)%")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                Text("72h")
                    .font(.system(size: 8, weight: .bold))
            }
        }
    }
    
    // MARK: - LOCK SCREEN RECTANGULAR
    private var lockScreenRectangularView: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "shield.checkered")
                    .font(.system(size: 10, weight: .bold))
                Text("PRÉPARATION 72H")
                    .font(.system(size: 10, weight: .bold))
                Spacer()
                Text("\(entry.snapshot.readinessScore)%")
                    .font(.system(size: 11, weight: .black))
            }
            Text("💧 Eau: \(Int(entry.snapshot.waterLitersReady))L • 🎒 Sac: \(entry.snapshot.bagCheckedCount)/\(entry.snapshot.bagTotalCount)")
                .font(.system(size: 10))
            Text("SOS: 112 • LU-Alert Actif")
                .font(.system(size: 9))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - LOCK SCREEN INLINE
    private var lockScreenInlineView: some View {
        Label("72h: \(entry.snapshot.readinessScore)% Prêt • \(Int(entry.snapshot.waterLitersReady))L Eau", systemImage: "shield.fill")
    }
}

// MARK: - MAIN WIDGET CONFIGURATION

struct MonGuide72hWidget: Widget {
    let kind: String = "MonGuide72hWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MonGuide72hWidgetEntryView(entry: entry)
                    .containerBackground(.background, for: .widget)
            } else {
                MonGuide72hWidgetEntryView(entry: entry)
                    .background(Color(UIColor.systemBackground))
            }
        }
        .configurationDisplayName("Mon Guide 72h")
        .description("Consultez votre niveau de préparation 72h et l'état de vos réserves d'urgence au Luxembourg.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}
