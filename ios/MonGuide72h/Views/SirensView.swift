import SwiftUI

public struct SirensView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @ObservedObject var player = SirenAudioPlayer.shared
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Radio Info Callout
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "radio.fill")
                                .foregroundColor(.blue)
                            Text("Rádios Oficiais de Emergência")
                                .font(.headline)
                        }
                        Text("Em caso de corte elétrico geral, a rádio a pilhas ou do automóvel é o meio mais fiável para receber comunicados.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack(spacing: 12) {
                            Text("📻 RTL Radio : 88.9 & 92.5 MHz")
                                .font(.caption.bold())
                            Text("📻 Radio 100.7 : 100.7 MHz")
                                .font(.caption.bold())
                        }
                        .padding(.top, 4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Sirens List
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Sinais de Sirene no Luxemburgo")
                            .font(.headline)
                        
                        sirenCard(type: .monthlyTest, title: loc.tr("siren_test"), desc: "Tom contínuo de 60s. Realizado na 1ª segunda-feira do mês ao meio-dia. Nenhuma ação necessária.")
                        sirenCard(type: .warning, title: loc.tr("siren_alert"), desc: "Tom contínuo longo de 2 min. Procure abrigo, feche portas/janelas e ligue a rádio oficial.")
                        sirenCard(type: .nationalAlarm, title: loc.tr("siren_alarm"), desc: "Tom oscilante ascendente e descendente (60s). Perigo iminente! Abrigue-se num edifício sólido.")
                        sirenCard(type: .allClear, title: loc.tr("siren_end"), desc: "Tom de 60s com interrupções a cada 12 segundos. Perigo afastado, regresso à normalidade.")
                    }
                    
                    // Awareness Levels
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Níveis de Vigilância LU-Alert")
                            .font(.headline)
                        
                        levelRow(color: .yellow, title: "AMARELO / ATENÇÃO", desc: "Risco reduzido ou perigo potencial")
                        levelRow(color: .orange, title: "LARANJA / PRUDÊNCIA", desc: "Risco médio ou perigo verificado")
                        levelRow(color: .red, title: "VERMELHO / MÁXIMA VIGILÂNCIA", desc: "Risco elevado ou perigo grave")
                        levelRow(color: .purple, title: "ROXO / DANGER IMINENT", desc: "Perigo extremo e ação de proteção imediata")
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle(loc.tr("tab_sirens"))
        }
    }
    
    private func sirenCard(type: SirenType, title: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(type.durationLabel)
                    .font(.caption2.bold())
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.red.opacity(0.15))
                    .foregroundColor(.red)
                    .cornerRadius(4)
                Spacer()
            }
            Text(title).font(.headline)
            Text(desc).font(.caption).foregroundColor(.secondary)
            
            Button(action: { player.toggleSiren(type) }) {
                HStack {
                    Image(systemName: player.currentPlaying == type ? "stop.fill" : "play.fill")
                    Text(player.currentPlaying == type ? loc.tr("stop_audio") : loc.tr("play_audio"))
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(player.currentPlaying == type ? Color.red : Color(red: 0/255, green: 43/255, blue: 73/255))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func levelRow(color: Color, title: String, desc: String) -> some View {
        HStack(spacing: 12) {
            Circle().fill(color).frame(width: 14, height: 14)
            VStack(alignment: .leading) {
                Text(title).font(.caption.bold())
                Text(desc).font(.caption2).foregroundColor(.secondary)
            }
        }
    }
}
