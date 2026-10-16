import SwiftUI

public struct TacticalNightVisionView: View {
    @ObservedObject var tactical = TacticalModeManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var redBrightness: Double = 0.65
    @State private var isStrobeActive: Bool = false
    @State private var strobeTimer: Timer? = nil
    @State private var strobeState: Bool = true
    @State private var showingLampOnly: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // OLED True Black Base
            Color.black.ignoresSafeArea()
            
            if showingLampOnly {
                // Full Screen Red Lantern View
                fullScreenLampOverlay
            } else {
                // Tactical Dashboard & Controls
                tacticalDashboard
            }
        }
        .onDisappear {
            stopStrobe()
        }
    }
    
    // MARK: - FULL SCREEN LAMP OVERLAY
    
    private var fullScreenLampOverlay: some View {
        ZStack {
            // Red spectrum lantern illumination (preserves human night vision rhodopsin)
            (isStrobeActive && !strobeState ? Color.black : Color(red: 1.0, green: 0.05, blue: 0.05))
                .opacity(redBrightness)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        stopStrobe()
                        showingLampOnly = false
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Painel Tático")
                                .bold()
                        }
                        .font(.caption)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    // Strobe indicator
                    if isStrobeActive {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                            Text("BALIZAMENTO SOS")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                    }
                }
                .padding()
                
                Spacer()
                
                // Controls Bar at Bottom of Lamp
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "sun.min.fill")
                            .foregroundColor(.white.opacity(0.8))
                        Slider(value: $redBrightness, in: 0.05...1.0)
                            .accentColor(.white)
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 24)
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            toggleStrobe()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: isStrobeActive ? "stop.fill" : "bolt.horizontal.fill")
                                Text(isStrobeActive ? "Parar Pisca" : "Pisca de Balizamento")
                                    .bold()
                            }
                            .font(.caption)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    // MARK: - TACTICAL DASHBOARD
    
    private var tacticalDashboard: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Bar
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "eye.trianglebadge.exclamationmark.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                        VStack(alignment: .leading, spacing: 1) {
                            Text("MODO TÁTICO & APAGÃO")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(.red)
                            Text("Visão Noturna & Máxima Autonomia")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 14)
                
                // Red Lantern Quick Launch Button
                Button(action: {
                    showingLampOnly = true
                }) {
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.2))
                                .frame(width: 80, height: 80)
                            Circle()
                                .fill(Color.red)
                                .frame(width: 58, height: 58)
                            Image(systemName: "flashlight.on.fill")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("Ativar Lanterna de Luz Vermelha")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                            Text("Usa pixels OLED vermelhos para iluminar mapas sem perder a adaptação ao escuro")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color(white: 0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red.opacity(0.4), lineWidth: 1.5)
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal)
                
                // Global App Tactical Mode Switch
                HStack(spacing: 14) {
                    Image(systemName: tactical.isTacticalActive ? "moon.stars.fill" : "sun.max.fill")
                        .font(.title2)
                        .foregroundColor(tactical.isTacticalActive ? .red : .yellow)
                        .frame(width: 36)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tema Tático na Aplicação Inteira")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                        Text(tactical.isTacticalActive ? "Ativo (Fundo preto OLED e acentos vermelhos)" : "Desligado (Cores padrão)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: { tactical.isTacticalActive },
                        set: { _ in tactical.toggleTacticalMode() }
                    ))
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                }
                .padding()
                .background(Color(white: 0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Battery Autonomy Monitor Card
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Image(systemName: tactical.batteryIcon)
                            .font(.title3)
                            .foregroundColor(tactical.batteryColor)
                        Text("AUTONOMIA EM BLACKOUT")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white)
                        Spacer()
                        Text(tactical.batteryPercentageString)
                            .font(.headline.bold())
                            .foregroundColor(tactical.batteryColor)
                    }
                    
                    HStack(spacing: 12) {
                        // Standard Mode Estimate
                        VStack(alignment: .leading, spacing: 4) {
                            Text("USO NORMAL")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.gray)
                            Text("~\(tactical.estimatedRemainingHoursNormal)h")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color(white: 0.05))
                        .cornerRadius(8)
                        
                        // Tactical Mode Estimate
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("MODO TÁTICO OLED")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.red)
                                Spacer()
                                Text("+110%")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(.green)
                            }
                            Text("~\(tactical.estimatedRemainingHoursTactical)h")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundColor(.red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color(white: 0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(white: 0.08))
                .cornerRadius(14)
                .padding(.horizontal)
                
                // 6 Golden Rules of 72h Battery Survival
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "bolt.badge.clock.fill")
                            .foregroundColor(.yellow)
                        Text("6 REGRAS DE POUPANÇA DE BATERIA (72H)")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white)
                    }
                    
                    ruleItem(num: "1", title: "Ative o Modo de Poupança do iOS", desc: "Reduz a taxa de atualização do ecrã e desliga processos de fundo.")
                    ruleItem(num: "2", title: "Ative o Modo de Voo se não houver rede", desc: "Quando as antenas caem, o telemóvel consome 10x mais energia à procura de sinal.")
                    ruleItem(num: "3", title: "Mantenha o ecrã a preto OLED e vermelho", desc: "Os pixels pretos em ecrãs OLED não consomem qualquer energia.")
                    ruleItem(num: "4", title: "Desligue Wi-Fi e Bluetooth", desc: "Impede a busca contínua por redes inexistentes durante o corte.")
                    ruleItem(num: "5", title: "Reduza o brilho do ecrã ao mínimo legível", desc: "O ecrã é o componente que consome mais de 65% da bateria.")
                    ruleItem(num: "6", title: "Não feche apps repetidamente", desc: "Reabrir aplicações consome mais CPU do que mantê-las em repouso na memória.")
                }
                .padding()
                .background(Color(white: 0.08))
                .cornerRadius(14)
                .padding(.horizontal)
                
                // Why Red Light Matters (Science Callout)
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Porquê a Luz Vermelha?")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                        Text("A luz branca destrói a rodopsina nos olhos (a molécula responsável pela visão noturna), demorando até 30 minutos a recuperar. O comprimento de onda vermelho permite ler sem cegar a visão periférica no escuro.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineSpacing(3)
                    }
                }
                .padding()
                .background(Color.red.opacity(0.08))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.bottom, 24)
        }
    }
    
    private func ruleItem(num: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(num)
                .font(.system(size: 11, weight: .black))
                .foregroundColor(.black)
                .frame(width: 20, height: 20)
                .background(Color.yellow)
                .clipShape(Circle())
                .padding(.top, 1)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                Text(desc)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 2)
    }
    
    private func toggleStrobe() {
        if isStrobeActive {
            stopStrobe()
        } else {
            isStrobeActive = true
            strobeTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                strobeState.toggle()
            }
        }
    }
    
    private func stopStrobe() {
        isStrobeActive = false
        strobeTimer?.invalidate()
        strobeTimer = nil
        strobeState = true
    }
}
