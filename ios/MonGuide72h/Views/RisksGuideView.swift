import SwiftUI

public struct RisksGuideView: View {
    @ObservedObject var loc = LocalizationManager.shared
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            List {
                Section(header: Text("Comportamentos Adequados")) {
                    NavigationLink(destination: RiskDetailView(
                        title: "Fenómenos Meteorológicos & Tempestades",
                        icon: "cloud.bolt.rain.fill",
                        color: .blue,
                        content: "• Limite deslocações ao estritamente necessário e permaneça no interior.\n• Avise familiares sobre saídas e destinos previstos.\n• Guarde no interior objetos soltos no jardim ou varandas que possam voar com o vento.\n• Em caso de onda de calor, hidrate-se com regularidade (consultar santesecu.public.lu).",
                        url: "https://meteolux.lu"
                    )) {
                        Label("Tempestades & Meteorologia", systemImage: "cloud.bolt.rain.fill")
                    }
                    
                    NavigationLink(destination: RiskDetailView(
                        title: "Inundações & Cheias Súbitas",
                        icon: "water.waves",
                        color: .cyan,
                        content: "• Verifique se reside em zona inundável em inondations.lu e eau.geoportail.lu.\n• Eleve eletrodomésticos e produtos poluentes guardados nas caves.\n• Retire viaturas de zonas de risco a tempo.\n• Corte a eletricidade nas divisões inundáveis.\n• NUNCA caminhe em águas que possam estar sob tensão elétrica.\n• Evite caves e parques de estacionamento subterrâneos.",
                        url: "https://inondations.lu"
                    )) {
                        Label("Inundações & Cheias", systemImage: "water.waves")
                    }
                    
                    NavigationLink(destination: RiskDetailView(
                        title: "Ciberataques & Falhas Informáticas",
                        icon: "lock.shield.fill",
                        color: .indigo,
                        content: "• Confirme qualquer pedido estranho diretamente junto da entidade oficial.\n• Digite os endereços web diretamente no navegador sem clicar em links suspeitos.\n• Use gestor de senhas e ative autenticação de 2 fatores (2FA).\n• Em caso de fraude bancária, contacte imediatamente o seu banco ou a Worldline e isole os equipamentos infetados da rede.",
                        url: "https://bee-secure.lu"
                    )) {
                        Label("Ciberataques & Fraude", systemImage: "lock.shield.fill")
                    }
                    
                    NavigationLink(destination: RiskDetailView(
                        title: "Ameaça Terrorista",
                        icon: "exclamationmark.octagon.fill",
                        color: .red,
                        content: "• FUGIR: Afaste-se da zona de perigo sem se expor desnecessariamente.\n• ESCONDER-SE: Procure abrigo sólido, feche e tranque acessos, coloque telemóvel no silêncio absoluto e evite qualquer ruído.\n• ALERTAR: Ligue para o 113 Polícia assim que estiver em segurança.\n• Facilite o trabalho dos serviços de emergência fornecendo informações úteis.",
                        url: "tel:113"
                    )) {
                        Label("Ameaça Terrorista", systemImage: "exclamationmark.octagon.fill")
                    }
                    
                    NavigationLink(destination: RiskDetailView(
                        title: "Acidente Nuclear",
                        icon: "atom",
                        color: .orange,
                        content: "• Abrigue-se imediatamente num edifício sólido e feche portas, janelas e estores.\n• Desligue a ventilação mecânica, ar condicionado e entrada de ar exterior.\n• Tenha à mão as pastilhas de iodeto de potássio.\n• ATENÇÃO: Tome os comprimidos APENAS POR ORDEM EXPRESSA DAS AUTORIDADES. São recomendados exclusivamente para pessoas com menos de 45 anos.",
                        url: "https://infocrise.lu"
                    )) {
                        Label("Acidente Nuclear & Iodo", systemImage: "atom")
                    }
                }
            }
            .navigationTitle(loc.tr("tab_risks"))
        }
    }
}

struct RiskDetailView: View {
    let title: String
    let icon: String
    let color: Color
    let content: String
    let url: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 36))
                        .foregroundColor(color)
                    Text(title)
                        .font(.title2.bold())
                }
                .padding(.bottom, 6)
                
                Text(content)
                    .font(.body)
                    .lineSpacing(6)
                
                if let targetURL = URL(string: url) {
                    Link(destination: targetURL) {
                        HStack {
                            Image(systemName: "safari.fill")
                            Text("Aceder ao portal oficial")
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 14)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
