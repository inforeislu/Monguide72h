import SwiftUI
import UIKit

public struct RescueSignalingView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @ObservedObject var torch = TorchManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAdviceSheet = false
    @State private var batteryLevel: Float = UIDevice.current.batteryLevel
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Live flashing background (Screen Strobe)
            if torch.useScreenStrobe && torch.isScreenFlashing {
                Color(torch.screenStrobeColor)
                    .ignoresSafeArea()
            } else {
                Color.black
                    .ignoresSafeArea()
            }
            
            // Foreground UI HUD
            VStack(spacing: 16) {
                // Top Navigation Bar
                HStack {
                    Button(action: {
                        torch.stopSignaling()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text(loc.tr("close_btn"))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.18))
                        .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    Button(action: { showingAdviceSheet = true }) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.85))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                // Status Header
                VStack(spacing: 4) {
                    if let mode = torch.activeMode {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 12, height: 12)
                            Text(loc.tr("strobe_status_active").uppercased())
                                .font(.caption.bold())
                                .foregroundColor(.red)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(12)
                        
                        Text(mode.rawValue)
                            .font(.system(.title2, design: .default).weight(.heavy))
                            .foregroundColor(.white)
                    } else {
                        Text(loc.tr("strobe_status_standby"))
                            .font(.subheadline.bold())
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 10)
                
                // Morse Code / Frequency Visualizer
                morseVisualizer
                
                Spacer()
                
                // Big Emergency Action Button (START / STOP)
                if torch.activeMode != nil {
                    Button(action: {
                        torch.stopSignaling()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "stop.circle.fill")
                                .font(.title)
                            Text(loc.tr("strobe_btn_stop"))
                                .font(.system(.title3, design: .default).weight(.heavy))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.red)
                        .cornerRadius(18)
                        .shadow(color: Color.red.opacity(0.6), radius: 15, x: 0, y: 6)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Mode Selection Grid
                VStack(spacing: 10) {
                    Text(loc.tr("strobe_section_modes"))
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        modeButton(mode: .sos, title: "SOS Morse", icon: "sos", color: .red)
                        modeButton(mode: .strobe, title: "Estroboscópio (8 Hz)", icon: "bolt.horizontal.fill", color: .yellow)
                        modeButton(mode: .beacon, title: "Baliza Noturna (0.5 Hz)", icon: "light.beacon.max.fill", color: .green)
                        modeButton(mode: .redAlert, title: "Alerta Vermelho", icon: "exclamationmark.shield.fill", color: .orange)
                    }
                }
                .padding(14)
                .background(Color.white.opacity(0.08))
                .cornerRadius(16)
                .padding(.horizontal, 16)
                
                // Hardware Toggles
                HStack(spacing: 20) {
                    Toggle(isOn: $torch.useRearLED) {
                        HStack(spacing: 6) {
                            Image(systemName: "flashlight.on.fill")
                            Text("LED Traseiro")
                                .font(.caption.bold())
                        }
                        .foregroundColor(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                    
                    Toggle(isOn: $torch.useScreenStrobe) {
                        HStack(spacing: 6) {
                            Image(systemName: "iphone")
                            Text("Ecrã Estroboscópico")
                                .font(.caption.bold())
                        }
                        .foregroundColor(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .sheet(isPresented: $showingAdviceSheet) {
            signalingAdviceSheet
        }
    }
    
    // MARK: - VISUALIZER
    
    private var morseVisualizer: some View {
        VStack(spacing: 8) {
            if torch.activeMode == .sos {
                HStack(spacing: 10) {
                    Text("● ● ●")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                    Text("— — —")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.yellow)
                    Text("● ● ●")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                }
                Text("CÓDIGO MORSE DE SOCORRO INTERNACIONAL")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.gray)
            } else if torch.activeMode == .beacon {
                HStack(spacing: 6) {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.green)
                    Text(loc.tr("strobe_beacon_battery_note"))
                        .font(.caption)
                        .foregroundColor(.green)
                }
            } else if torch.activeMode == .strobe {
                HStack(spacing: 6) {
                    Image(systemName: "airplane")
                        .foregroundColor(.yellow)
                    Text(loc.tr("strobe_air_rescue_note"))
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - MODE BUTTON
    
    private func modeButton(mode: SignalingMode, title: String, icon: String, color: Color) -> some View {
        let isSelected = torch.activeMode == mode
        
        return Button(action: {
            if isSelected {
                torch.stopSignaling()
            } else {
                torch.startSignaling(mode: mode)
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : color)
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .lineLimit(1)
                Spacer()
            }
            .padding(12)
            .background(isSelected ? color : Color.white.opacity(0.12))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
        }
    }
    
    // MARK: - ADVICE SHEET
    
    private var signalingAdviceSheet: some View {
        NavigationView {
            List {
                Section(header: Text(loc.tr("strobe_sheet_title"))) {
                    adviceRow(
                        icon: "airplane.departure",
                        color: .blue,
                        title: loc.tr("strobe_tip_1_title"),
                        desc: loc.tr("strobe_tip_1_desc")
                    )
                    adviceRow(
                        icon: "cup.and.saucer.fill",
                        color: .green,
                        title: loc.tr("strobe_tip_2_title"),
                        desc: loc.tr("strobe_tip_2_desc")
                    )
                    adviceRow(
                        icon: "light.beacon.max.fill",
                        color: .orange,
                        title: loc.tr("strobe_tip_3_title"),
                        desc: loc.tr("strobe_tip_3_desc")
                    )
                    adviceRow(
                        icon: "eye.slash.fill",
                        color: .red,
                        title: loc.tr("strobe_tip_4_title"),
                        desc: loc.tr("strobe_tip_4_desc")
                    )
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(loc.tr("strobe_sheet_header"))
            .navigationBarItems(trailing: Button(loc.tr("close_btn")) {
                showingAdviceSheet = false
            })
        }
    }
    
    private func adviceRow(icon: String, color: Color, title: String, desc: String) -> some View {
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
