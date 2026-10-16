import SwiftUI

public struct ScenarioTimelineView: View {
    @ObservedObject var loc = LocalizationManager.shared
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    
                    timelineCard(
                        day: "DIA 1",
                        title: "O Choque Inicial & A Primeira Noite",
                        icon: "1.circle.fill",
                        color: .red,
                        text: "Corte elétrico repentino à tarde no inverno. Semáforos apagados, comboios parados, telecomunicações saturadas.\n\nRegresso à habitação, apoio aos vizinhos idosos, uso do fogão a gás e lanternas. Recolha de água da torneira enquanto os reservatórios ainda mantêm pressão."
                    )
                    
                    timelineCard(
                        day: "DIA 2",
                        title: "O Frio, Saneamento & Rotina de Crise",
                        icon: "2.circle.fill",
                        color: .orange,
                        text: "Sem aquecimento e sem autoclismo nas sanitas. Conservar a comida lá fora no frio de inverno sem abrir o congelador.\n\nPoupança rigorosa da bateria do smartphone. Acompanhamento dos boletins oficiais via rádio a pilhas. Desligar aparelhos das tomadas para prevenir picos de sobretensão no regresso da luz."
                    )
                    
                    timelineCard(
                        day: "DIA 3",
                        title: "A Solidariedade & O Restabelecimento",
                        icon: "3.circle.fill",
                        color: .green,
                        text: "Rede de entreajuda entre vizinhos. Abertura dos centros municipais de acolhimento temporário (RESILIENZBONUS) com salas aquecidas e postos de carregamento de emergência.\n\nCafé das línguas improvisado para apoiar cidadãos estrangeiros. A rádio anuncia o restabelecimento progressivo por zonas."
                    )
                }
                .padding()
            }
            .navigationTitle(loc.tr("tab_timeline"))
        }
    }
    
    private func timelineCard(day: String, title: String, icon: String, color: Color, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(day, systemImage: icon)
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.15))
                    .foregroundColor(color)
                    .cornerRadius(6)
                Spacer()
            }
            
            Text(title)
                .font(.headline)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(14)
    }
}
