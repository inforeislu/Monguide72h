import SwiftUI

public struct EmergencyRadioGuideView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedStation: EmergencyRadioStation? = EmergencyRadioRepository.shared.stations.first
    @State private var showingRadioAdviceSheet: Bool = false
    
    private let stations = EmergencyRadioRepository.shared.stations
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 18) {
                    // Top Alert Banner
                    heroEmergencyBanner
                    
                    // Interactive Radio Dial Visualizer
                    radioDialVisualizer
                    
                    // Radio Stations List
                    VStack(alignment: .leading, spacing: 14) {
                        Text(loc.tr("radio_section_stations"))
                            .font(.headline)
                            .padding(.horizontal, 16)
                        
                        ForEach(stations) { station in
                            stationCard(station)
                        }
                    }
                    
                    // Advice Card & Recommendations
                    batteryAdviceCard
                }
                .padding(.vertical, 14)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(loc.tr("radio_view_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(loc.tr("close_btn")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingRadioAdviceSheet) {
                radioTipsDetailSheet
            }
        }
    }
    
    // MARK: - HERO BANNER
    
    private var heroEmergencyBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.title2.bold())
                    .foregroundColor(.yellow)
                
                VStack(alignment: .leading, spacing: 1) {
                    Text(loc.tr("radio_hero_title"))
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(loc.tr("radio_hero_sub"))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.85))
                }
                
                Spacer()
            }
            
            Text(loc.tr("radio_hero_desc"))
                .font(.footnote)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(2)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color(red: 20/255, green: 40/255, blue: 70/255), Color(red: 10/255, green: 25/255, blue: 45/255)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(14)
        .padding(.horizontal, 16)
        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - VISUAL RADIO DIAL
    
    private var radioDialVisualizer: some View {
        VStack(spacing: 8) {
            HStack {
                Text("FM BAND II (87.5 — 108.0 MHz)")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundColor(.secondary)
                Spacer()
                Text("LUXEMBOURG")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 16)
            
            // Dial Graphic
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 25/255, green: 28/255, blue: 33/255))
                    .frame(height: 70)
                
                // Frequency markers lines
                HStack(spacing: 0) {
                    ForEach(0..<21) { i in
                        VStack {
                            Rectangle()
                                .fill(i % 5 == 0 ? Color.white : Color.gray.opacity(0.4))
                                .frame(width: i % 5 == 0 ? 2 : 1, height: i % 5 == 0 ? 20 : 10)
                            if i % 5 == 0 {
                                Text("\(88 + i)")
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 10)
                
                // Station Indicator Chips on Dial
                HStack {
                    dialTag(title: "RTL 88.9", color: .red)
                        .offset(x: 20)
                    Spacer()
                    dialTag(title: "100,7", color: .blue)
                    Spacer()
                    dialTag(title: "ELDO 105", color: .orange)
                        .offset(x: -15)
                }
                .padding(.horizontal, 20)
                .offset(y: 12)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func dialTag(title: String, color: Color) -> some View {
        Text(title)
            .font(.system(size: 9, weight: .black, design: .rounded))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(4)
            .shadow(radius: 2)
    }
    
    // MARK: - STATION CARD
    
    private func stationCard(_ station: EmergencyRadioStation) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(station.name)
                            .font(.title3.bold())
                        
                        if station.isPrimaryEmergencyChannel {
                            Text("GOV / 112")
                                .font(.system(size: 9, weight: .black))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(station.broadcasterType)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Big frequency badge
                VStack(alignment: .trailing, spacing: 0) {
                    Text(station.mainFrequency)
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundColor(.blue)
                    Text(station.language)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            Text(station.details)
                .font(.footnote)
                .foregroundColor(.primary.opacity(0.85))
                .lineSpacing(2)
            
            // Frequency Table
            VStack(alignment: .leading, spacing: 6) {
                Text(loc.tr("radio_freq_by_region"))
                    .font(.caption2.bold())
                    .foregroundColor(.secondary)
                
                ForEach(station.frequencies) { f in
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text(f.region)
                            .font(.caption.bold())
                        Spacer()
                        Text(f.freq)
                            .font(.caption.bold())
                            .foregroundColor(.primary)
                        Text("(\(f.transmitter))")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
            .padding(10)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(8)
            
            // Web Stream Live Test (when phone is online)
            if let stream = station.streamURL {
                Link(destination: stream) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text(loc.tr("radio_test_stream_btn"))
                            .bold()
                    }
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.12))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                }
            }
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
        .padding(.horizontal, 16)
    }
    
    // MARK: - BATTERY & ADVICE CARD
    
    private var batteryAdviceCard: some View {
        Button(action: { showingRadioAdviceSheet = true }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.2))
                        .frame(width: 44, height: 44)
                    Image(systemName: "battery.100.bolt")
                        .foregroundColor(.orange)
                        .font(.title3)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(loc.tr("radio_tips_title"))
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(loc.tr("radio_tips_sub"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding(14)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(14)
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - ADVICE DETAIL SHEET
    
    private var radioTipsDetailSheet: some View {
        NavigationView {
            List {
                Section(header: Text(loc.tr("radio_sheet_guidelines_header"))) {
                    tipRow(
                        icon: "bolt.slash.fill",
                        color: .red,
                        title: loc.tr("radio_tip_1_title"),
                        desc: loc.tr("radio_tip_1_desc")
                    )
                    tipRow(
                        icon: "clock.badge.checkmark.fill",
                        color: .blue,
                        title: loc.tr("radio_tip_2_title"),
                        desc: loc.tr("radio_tip_2_desc")
                    )
                    tipRow(
                        icon: "battery.75",
                        color: .green,
                        title: loc.tr("radio_tip_3_title"),
                        desc: loc.tr("radio_tip_3_desc")
                    )
                    tipRow(
                        icon: "antenna.radiowaves.left.and.right",
                        color: .orange,
                        title: loc.tr("radio_tip_4_title"),
                        desc: loc.tr("radio_tip_4_desc")
                    )
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(loc.tr("radio_tips_title"))
            .navigationBarItems(trailing: Button(loc.tr("close_btn")) {
                showingRadioAdviceSheet = false
            })
        }
    }
    
    private func tipRow(icon: String, color: Color, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                Text(desc)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineSpacing(2)
            }
        }
        .padding(.vertical, 6)
    }
}
