//
//  ContentView.swift
//  MonGuide72hWatch Watch App
//
//  Created by iNFOREIS on 15/10/2026.
//  Official Luxembourg Emergency & Civil Protection App for Apple Watch
//

import SwiftUI
import WatchKit
import AVFoundation

struct ContentView: View {
    @ObservedObject private var session = WatchSessionManager.shared
    @State private var selectedTab = UserDefaults.standard.integer(forKey: "watchTab")
    @State private var isFlashlightActive = false
    @State private var flashlightColor: Color = .white
    @State private var isStrobeActive = false
    @State private var strobeTimer: Timer? = nil
    @State private var isWhistleActive = false
    @State private var whistleTimer: Timer? = nil
    
    // Luxembourg Official Colors
    private let luxBlue = Color(red: 0/255, green: 43/255, blue: 73/255)
    private let luxRed = Color(red: 234/255, green: 40/255, blue: 57/255)
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // TAB 0: SOS & ICE (CONTACTOS DIRETOS NO PULSO)
            emergencyTab
                .tag(0)
            
            // TAB 1: PLANO FAMILIAR & VÁLVULAS DA CASA
            planTab
                .tag(1)
            
            // TAB 2: ESTADO PRONTIDÃO 72H SINCRONIZADO
            readinessTab
                .tag(2)
            
            // TAB 3: LANTERNA TÁTICA & STROBE RESGATE
            tacticalToolsTab
                .tag(3)
            
            // TAB 4: GUIAS RÁPIDOS NO PULSO
            quickActionsTab
                .tag(4)
        }
        .tabViewStyle(.page)
        .fullScreenCover(isPresented: $isFlashlightActive) {
            flashlightView
        }
        .onAppear {
            session.requestSyncFromPhone()
        }
    }
    
    // MARK: - TAB 0: SOS & CONTACTOS ICE
    private var emergencyTab: some View {
        ScrollView {
            VStack(spacing: 8) {
                // Header
                HStack(spacing: 4) {
                    Image(systemName: "shield.fill")
                        .foregroundColor(luxRed)
                    Text("URGÊNCIA LUXEMBOURG")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.primary)
                }
                
                // GIANT 112 SOS CALL BUTTON
                if let url112 = URL(string: "tel://112") {
                    Link(destination: url112) {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 36, height: 36)
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("112 SECOURS")
                                    .font(.system(size: 15, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                Text("CGDIS • Ambulância / Bombeiros")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            Spacer()
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .background(luxRed)
                        .cornerRadius(12)
                        .shadow(color: luxRed.opacity(0.5), radius: 4, x: 0, y: 2)
                    }
                }
                
                // 113 Police
                if let url113 = URL(string: "tel://113") {
                    Link(destination: url113) {
                        HStack(spacing: 8) {
                            Image(systemName: "shield.checkered")
                                .font(.system(size: 14, weight: .bold))
                            Text("113 POLÍCIA")
                                .font(.system(size: 13, weight: .black))
                            Spacer()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .background(luxBlue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                
                // ICE CONTACTS FROM IPHONE
                if !session.iceContacts.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CONTACTOS FAMÍLIA (ICE)")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                        
                        ForEach(session.iceContacts) { contact in
                            if let phoneUrl = cleanPhoneUrl(contact.phone) {
                                Link(destination: phoneUrl) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "phone.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.system(size: 16))
                                        
                                        VStack(alignment: .leading, spacing: 1) {
                                            Text(contact.name)
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                            Text(contact.phone)
                                                .font(.system(size: 9))
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 8)
                                    .background(Color(white: 0.16))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                
                // Quick Flashlight Button
                Button {
                    WKInterfaceDevice.current().play(.click)
                    flashlightColor = .white
                    isStrobeActive = false
                    isFlashlightActive = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "flashlight.on.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 14))
                        Text("LANTERNA")
                            .font(.system(size: 12, weight: .bold))
                        Spacer()
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(Color(white: 0.16))
                    .cornerRadius(8)
                }
                
                // Rescue Whistle
                Button(action: toggleRescueWhistle) {
                    HStack(spacing: 8) {
                        Image(systemName: isWhistleActive ? "speaker.wave.3.fill" : "speaker.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(isWhistleActive ? .yellow : .white)
                        Text(isWhistleActive ? "PARAR ALARME" : "Alarme de Resgate")
                            .font(.system(size: 11, weight: .bold))
                        Spacer()
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                    .background(isWhistleActive ? Color.orange : Color(white: 0.16))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal, 2)
        }
    }
    
    // MARK: - TAB 1: PLANO FAMILIAR & VÁLVULAS
    private var planTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "map.fill")
                        .foregroundColor(luxBlue)
                    Text("PLANO & CASA")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.primary)
                }
                
                // Meeting Point 1
                planRow(
                    icon: "mappin.circle.fill",
                    color: .green,
                    title: "Ponto 1 (Bairro)",
                    desc: session.meetingPoint1.isEmpty ? "Configure no iPhone" : session.meetingPoint1
                )
                
                // Meeting Point 2
                planRow(
                    icon: "mappin.and.ellipse",
                    color: .orange,
                    title: "Ponto 2 (Regional)",
                    desc: session.meetingPoint2.isEmpty ? "Configure no iPhone" : session.meetingPoint2
                )
                
                Text("CORTES DE CASA")
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
                
                // Water
                planRow(
                    icon: "drop.fill",
                    color: .blue,
                    title: "Torneira Geral Água",
                    desc: session.valveLocations.water.isEmpty ? "Não anotado" : session.valveLocations.water
                )
                
                // Gas
                planRow(
                    icon: "flame.fill",
                    color: .orange,
                    title: "Corte de Gás",
                    desc: session.valveLocations.gas.isEmpty ? "Não anotado" : session.valveLocations.gas
                )
                
                // Electricity
                planRow(
                    icon: "bolt.fill",
                    color: .yellow,
                    title: "Quadro Elétrico",
                    desc: session.valveLocations.breaker.isEmpty ? "Não anotado" : session.valveLocations.breaker
                )
                
                // Extinguisher
                planRow(
                    icon: "fire.extinguisher.fill",
                    color: .red,
                    title: "Extintor",
                    desc: session.valveLocations.extinguisher.isEmpty ? "Não anotado" : session.valveLocations.extinguisher
                )
                
                if !session.emergencyNotes.isEmpty {
                    Text("NOTAS DE EMERGÊNCIA")
                        .font(.system(size: 9, weight: .black))
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                    
                    Text(session.emergencyNotes)
                        .font(.system(size: 10))
                        .foregroundColor(.primary)
                        .padding(6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(white: 0.15))
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal, 2)
        }
    }
    
    private func planRow(icon: String, color: Color, title: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 11))
                Text(title)
                    .font(.system(size: 10, weight: .bold))
            }
            Text(desc)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(white: 0.15))
        .cornerRadius(6)
    }
    
    // MARK: - TAB 2: ESTADO PRONTIDÃO
    private var readinessTab: some View {
        ScrollView {
            VStack(spacing: 6) {
                Text("PRONTIDÃO 72H")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.secondary)
                
                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 6)
                        .frame(width: 66, height: 66)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(min(100, max(0, session.readinessScore))) / 100.0)
                        .stroke(readinessColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 66, height: 66)
                    
                    VStack(spacing: 0) {
                        Text("\(session.readinessScore)%")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                        Text(readinessStatusText)
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(readinessColor)
                    }
                }
                .padding(.vertical, 2)
                
                HStack(spacing: 8) {
                    VStack {
                        Text("💧 Água")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                        Text("\(Int(session.waterReadyLitres))L")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .background(Color(white: 0.15))
                    .cornerRadius(6)
                    
                    VStack {
                        Text("🎒 Saco")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                        Text("\(session.bagCheckedCount)/\(session.bagTotalCount)")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .background(Color(white: 0.15))
                    .cornerRadius(6)
                }
                
                // Sync button with phone
                Button(action: {
                    session.requestSyncFromPhone()
                }) {
                    HStack(spacing: 4) {
                        if session.isSyncing {
                            ProgressView()
                                .scaleEffect(0.6)
                        } else {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.system(size: 10))
                        }
                        Text(session.isSyncing ? "A atualizar..." : "Sincronizar iPhone")
                            .font(.system(size: 9, weight: .bold))
                    }
                    .padding(.vertical, 4)
                }
                .disabled(session.isSyncing)
                
                Text(formatSyncTime(session.lastSyncDate))
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 2)
        }
    }
    
    private var readinessColor: Color {
        if session.readinessScore >= 80 {
            return .green
        } else if session.readinessScore >= 50 {
            return .orange
        } else {
            return .red
        }
    }
    
    private var readinessStatusText: String {
        if session.readinessScore >= 80 {
            return "PRONTO"
        } else if session.readinessScore >= 50 {
            return "PARCIAL"
        } else {
            return "ATENÇÃO"
        }
    }
    
    private func formatSyncTime(_ date: Date?) -> String {
        guard let date = date else { return "Aguardando iPhone" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "Sinc: " + formatter.string(from: date)
    }
    
    // MARK: - TAB 3: LANTERNA & SINALIZADOR SOS
    private var tacticalToolsTab: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("FERRAMENTAS DE RESGATE")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.secondary)
                
                // White Flashlight
                Button {
                    flashlightColor = .white
                    isStrobeActive = false
                    isFlashlightActive = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "flashlight.on.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Lanterna Branca")
                                .font(.system(size: 12, weight: .bold))
                            Text("Brilho 100%")
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                
                // Red Tactical Light
                Button {
                    flashlightColor = .red
                    isStrobeActive = false
                    isFlashlightActive = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "eye.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Luz Vermelha Tática")
                                .font(.system(size: 12, weight: .bold))
                            Text("Visão noturna")
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                
                // SOS Strobe
                Button {
                    flashlightColor = .white
                    isStrobeActive = true
                    isFlashlightActive = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.yellow)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Estroboscópio SOS")
                                .font(.system(size: 12, weight: .bold))
                            Text("Sinalização Morse")
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(.horizontal, 2)
        }
    }
    
    // MARK: - TAB 4: GUIAS RÁPIDOS
    private var quickActionsTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text("AÇÕES IMEDIATAS")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.secondary)
                
                actionMiniRow(icon: "bell.fill", color: .red, title: "Sirene / LU-Alert", desc: "Entre num edifício, feche tudo, rádio 100.7 FM")
                actionMiniRow(icon: "flame.fill", color: .orange, title: "Fuga de Gás", desc: "Corte torneira geral, ventile, não ligue interruptores")
                actionMiniRow(icon: "bolt.slash.fill", color: .purple, title: "Blackout", desc: "Desligue aparelhos, use rádio e lanternas")
                actionMiniRow(icon: "atom", color: .green, title: "Nuclear / Iodo", desc: "Tome comprimidos de iodo apenas sob ordem oficial")
            }
            .padding(.horizontal, 4)
        }
    }
    
    private func actionMiniRow(icon: String, color: Color, title: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 11, weight: .bold))
            }
            Text(desc)
                .font(.system(size: 9))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(6)
        .background(Color(white: 0.15))
        .cornerRadius(8)
    }
    
    // MARK: - FLASHLIGHT FULL SCREEN
    private var flashlightView: some View {
        ZStack {
            flashlightColor
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        isFlashlightActive = false
                        stopStrobe()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(flashlightColor == .white ? .black.opacity(0.6) : .white.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                    .padding()
                }
                Spacer()
                if isStrobeActive {
                    Text("SOS SINALIZADOR")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.black)
                        .padding(5)
                        .background(Color.yellow)
                        .cornerRadius(6)
                }
                Spacer()
            }
        }
        .onAppear {
            if isStrobeActive {
                startStrobe()
            }
        }
        .onDisappear {
            stopStrobe()
        }
    }
    
    // MARK: - AUDIO & STROBE HELPERS
    private func toggleRescueWhistle() {
        isWhistleActive.toggle()
        if isWhistleActive {
            whistleTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
                WKInterfaceDevice.current().play(.directionUp)
            }
        } else {
            whistleTimer?.invalidate()
            whistleTimer = nil
        }
    }
    
    private func startStrobe() {
        strobeTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
            flashlightColor = (flashlightColor == .white) ? .black : .white
            WKInterfaceDevice.current().play(.click)
        }
    }
    
    private func stopStrobe() {
        strobeTimer?.invalidate()
        strobeTimer = nil
    }
    
    private func cleanPhoneUrl(_ raw: String) -> URL? {
        let cleaned = raw.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
        guard !cleaned.isEmpty else { return nil }
        return URL(string: "tel://\(cleaned)")
    }
}

#Preview {
    ContentView()
}
