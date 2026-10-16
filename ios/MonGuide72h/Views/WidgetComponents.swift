import SwiftUI

// MARK: - SMALL HOME SCREEN WIDGET (155 x 155)

public struct SmallReadinessWidgetView: View {
    public var snapshot: WidgetEmergencySnapshot
    
    public init(snapshot: WidgetEmergencySnapshot = WidgetDataManager.shared.currentSnapshot) {
        self.snapshot = snapshot
    }
    
    public var body: some View {
        ZStack {
            // Background
            (snapshot.isTacticalActive ? Color.black : Color(red: 0/255, green: 35/255, blue: 60/255))
            
            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack {
                    Image("AppLogo")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    Text("72H STATUS")
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .foregroundColor(snapshot.isTacticalActive ? .red : .yellow)
                    
                    Spacer()
                    
                    Text("\(snapshot.readinessScore)%")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(badgeColor)
                        .cornerRadius(4)
                }
                
                // Gauge Ring & Summary
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.15), lineWidth: 5)
                            .frame(width: 44, height: 44)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(snapshot.readinessScore) / 100.0)
                            .stroke(
                                snapshot.isTacticalActive ? Color.red : Color.green,
                                style: StrokeStyle(lineWidth: 5, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "shield.fill")
                            .font(.system(size: 16))
                            .foregroundColor(snapshot.isTacticalActive ? .red : .white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("PRONTIDÃO")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.gray)
                        Text(readinessLabel)
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Bottom Metrics
                HStack(spacing: 8) {
                    metricChip(icon: "drop.fill", val: "\(Int(snapshot.waterLitersReady))L", color: .cyan)
                    metricChip(icon: "backpack.fill", val: "\(snapshot.bagCheckedCount)/\(snapshot.bagTotalCount)", color: .orange)
                }
            }
            .padding(12)
        }
        .frame(width: 155, height: 155)
        .cornerRadius(22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(snapshot.isTacticalActive ? Color.red.opacity(0.4) : Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var badgeColor: Color {
        if snapshot.isTacticalActive { return .red }
        if snapshot.readinessScore >= 80 { return .green }
        if snapshot.readinessScore >= 50 { return .orange }
        return .red
    }
    
    private var readinessLabel: String {
        if snapshot.readinessScore >= 80 { return "Excelente" }
        if snapshot.readinessScore >= 50 { return "A Preparar" }
        return "Incompleto"
    }
    
    private func metricChip(icon: String, val: String, color: Color) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 9))
                .foregroundColor(color)
            Text(val)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.1))
        .cornerRadius(6)
    }
}

// MARK: - MEDIUM HOME SCREEN WIDGET (320 x 155)

public struct MediumEmergencyWidgetView: View {
    public var snapshot: WidgetEmergencySnapshot
    
    public init(snapshot: WidgetEmergencySnapshot = WidgetDataManager.shared.currentSnapshot) {
        self.snapshot = snapshot
    }
    
    public var body: some View {
        ZStack {
            (snapshot.isTacticalActive ? Color.black : Color(red: 0/255, green: 35/255, blue: 60/255))
            
            HStack(spacing: 12) {
                // Left Column: 72h Readiness Overview
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image("AppLogo")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("MON GUIDE 72H")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(snapshot.isTacticalActive ? .red : .yellow)
                            Text("Lëtz prepare !")
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.15), lineWidth: 6)
                                .frame(width: 52, height: 52)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(snapshot.readinessScore) / 100.0)
                                .stroke(
                                    snapshot.isTacticalActive ? Color.red : Color.green,
                                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .frame(width: 52, height: 52)
                            
                            VStack(spacing: 0) {
                                Text("\(snapshot.readinessScore)%")
                                    .font(.system(size: 13, weight: .black))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Reserva 72h")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "drop.fill").font(.system(size: 9)).foregroundColor(.cyan)
                                Text("\(Int(snapshot.waterLitersReady))L / \(Int(snapshot.waterLitersTarget))L")
                                    .font(.system(size: 9))
                                    .foregroundColor(.gray)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "backpack.fill").font(.system(size: 9)).foregroundColor(.orange)
                                Text("\(snapshot.bagCheckedCount)/\(snapshot.bagTotalCount) Itens")
                                    .font(.system(size: 9))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Text("Atualizado: hoje")
                        .font(.system(size: 8))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .background(Color.white.opacity(0.2))
                    .padding(.vertical, 4)
                
                // Right Column: Quick Emergency Actions
                VStack(spacing: 8) {
                    Text("SOCORRO RÁPIDO")
                        .font(.system(size: 9, weight: .black))
                        .foregroundColor(snapshot.isTacticalActive ? .red : .white)
                    
                    // 112 Call
                    emergencyWidgetButton(title: "112 CGDIS", icon: "phone.fill", color: Color(red: 220/255, green: 38/255, blue: 38/255))
                    
                    // 113 Police
                    emergencyWidgetButton(title: "113 POLICE", icon: "shield.fill", color: Color(red: 30/255, green: 58/255, blue: 138/255))
                    
                    // SOS Alarm / Torch
                    HStack(spacing: 6) {
                        emergencyMiniButton(title: "SOS", icon: "speaker.wave.3.fill", color: .red)
                        emergencyMiniButton(title: "LUZ", icon: "flashlight.on.fill", color: Color(white: 0.2))
                    }
                }
                .frame(width: 120)
            }
            .padding(12)
        }
        .frame(width: 320, height: 155)
        .cornerRadius(22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(snapshot.isTacticalActive ? Color.red.opacity(0.4) : Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    private func emergencyWidgetButton(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 10, weight: .bold))
            Text(title).font(.system(size: 10, weight: .black))
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7)
        .background(color)
        .cornerRadius(8)
    }
    
    private func emergencyMiniButton(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 9))
            Text(title).font(.system(size: 9, weight: .black))
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7)
        .background(color)
        .cornerRadius(8)
    }
}

// MARK: - LOCK SCREEN CIRCULAR WIDGET (accessoryCircular)

public struct LockScreenCircularWidgetView: View {
    public var score: Int
    
    public init(score: Int = 85) {
        self.score = score
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: CGFloat(score) / 100.0)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            VStack(spacing: 0) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 11))
                Text("\(score)%")
                    .font(.system(size: 10, weight: .black, design: .rounded))
            }
            .foregroundColor(.white)
        }
        .frame(width: 48, height: 48)
    }
}

// MARK: - LOCK SCREEN RECTANGULAR WIDGET (accessoryRectangular)

public struct LockScreenRectangularWidgetView: View {
    public var snapshot: WidgetEmergencySnapshot
    
    public init(snapshot: WidgetEmergencySnapshot = WidgetDataManager.shared.currentSnapshot) {
        self.snapshot = snapshot
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 10, weight: .bold))
                Text("MON GUIDE 72H")
                    .font(.system(size: 10, weight: .black))
                Spacer()
                Text("\(snapshot.readinessScore)%")
                    .font(.system(size: 10, weight: .black))
            }
            
            Text("Água: \(Int(snapshot.waterLitersReady))L / \(Int(snapshot.waterLitersTarget))L • Saco: \(snapshot.bagCheckedCount)/\(snapshot.bagTotalCount)")
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(1)
            
            HStack(spacing: 6) {
                Text("Emergência: 112")
                    .font(.system(size: 9, weight: .bold))
                Text("•")
                    .foregroundColor(.white.opacity(0.5))
                Text("SOS Rápido")
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 4)
    }
}

// MARK: - LOCK SCREEN INLINE WIDGET (accessoryInline)

public struct LockScreenInlineWidgetView: View {
    public var score: Int
    
    public init(score: Int = 85) {
        self.score = score
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "shield.checkered")
            Text("72h Prontidão: \(score)% • Água OK")
        }
    }
}
