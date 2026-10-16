import SwiftUI

public struct CrisisScenario: Identifiable {
    public let id: String
    public let title: String
    public let icon: String
    public let color: Color
    public let urgentTimeSeconds: Int
    public let primaryNumber: String
    public let primaryNumberLabel: String
    public let immediateActions: [String]
    public let whatNotToDo: [String]
    public let officialNote: String
}

public struct CrisisTriageView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedScenario: CrisisScenario? = nil
    @State private var checkedActions: Set<String> = []
    @State private var timerRemaining: Int = 0
    @State private var isTimerActive: Bool = false
    @State private var timer: Timer? = nil
    
    private var isFR: Bool {
        loc.currentLanguage == .fr || loc.currentLanguage == .lu || loc.currentLanguage == .de
    }
    
    private var scenarios: [CrisisScenario] {
        if isFR {
            return [
                CrisisScenario(
                    id: "siren",
                    title: "Sirène en Cours ou Alerte LU-Alert",
                    icon: "bell.badge.fill",
                    color: Color.red,
                    urgentTimeSeconds: 600,
                    primaryNumber: "80027788",
                    primaryNumberLabel: "Info-Crise (8002 7788)",
                    immediateActions: [
                        "Entrez immédiatement dans le bâtiment ou l'habitation la plus proche.",
                        "Fermez toutes les portes et fenêtres extérieures.",
                        "Coupez la ventilation mécanique (VMC) et la climatisation.",
                        "Allumez la radio sur RTL 88.9 / 92.5 FM ou 100.7 FM.",
                        "Consultez les informations sur le site officiel infocrise.public.lu.",
                        "Laissez les lignes téléphoniques libres pour les secours."
                    ],
                    whatNotToDo: [
                        "N'allez PAS chercher vos enfants à l'école (les écoles ont un plan de confinement sûr).",
                        "Ne restez PAS à l'intérieur des véhicules ou sur la voie publique.",
                        "Ne surchargez PAS le 112 pour de simples demandes d'information."
                    ],
                    officialNote: "En cas d'alerte nucléaire (Cattenom) ou chimique, le confinement hermétique immédiat est votre meilleure protection."
                ),
                CrisisScenario(
                    id: "gas",
                    title: "Odeur Suspecte de Gaz",
                    icon: "flame.fill",
                    color: Color.orange,
                    urgentTimeSeconds: 300,
                    primaryNumber: "112",
                    primaryNumberLabel: "Appeler le 112 (de l'extérieur)",
                    immediateActions: [
                        "Ouvrez rapidement portes et fenêtres pour aérer si possible sans délai.",
                        "Fermez la vanne générale de gaz (si accessible en toute sécurité).",
                        "Évacuez immédiatement tous les occupants et animaux à l'extérieur.",
                        "Avertissez les voisins en frappant aux portes (sans sonnette électrique).",
                        "Appelez le 112 dès que vous êtes à distance sécurisée à l'extérieur."
                    ],
                    whatNotToDo: [
                        "N'allumez PAS d'allumettes, de briquets et ne fumez pas.",
                        "Ne touchez à AUCUN interrupteur électrique (ni allumer ni éteindre).",
                        "N'utilisez pas de téléphone fixe ni de portable dans le logement.",
                        "N'utilisez PAS l'ascenseur."
                    ],
                    officialNote: "Une simple étincelle d'un interrupteur électrique peut provoquer une explosion de gaz."
                ),
                CrisisScenario(
                    id: "blackout",
                    title: "Panne d'Électricité Générale (Blackout)",
                    icon: "bolt.slash.fill",
                    color: Color(red: 0/255, green: 43/255, blue: 73/255),
                    urgentTimeSeconds: 900,
                    primaryNumber: "112",
                    primaryNumberLabel: "112 (Urgences Médicales)",
                    immediateActions: [
                        "Débranchez les appareils sensibles pour éviter les surtensions au retour.",
                        "Maintenez le réfrigérateur et le congélateur strictement fermés.",
                        "Allumez la lampe torche LED du Kit 72h (évitez les flammes nues).",
                        "Allumez la radio à piles ou manivelle sur RTL 88.9 FM.",
                        "Vérifiez si des proches âgés ou des voisins vulnérables ont besoin d'aide.",
                        "Ouvrez le Kit 72h et vérifiez vos réserves d'eau et de vivres."
                    ],
                    whatNotToDo: [
                        "N'allumez JAMAIS de groupe électrogène ou barbecue à l'intérieur (danger de mort CO).",
                        "Ne laissez PAS de bougies allumées sans surveillance.",
                        "N'ouvrez pas le réfrigérateur de manière répétée."
                    ],
                    officialNote: "Le réfrigérateur conserve les aliments au frais environ 4 à 6 heures s'il reste fermé."
                ),
                CrisisScenario(
                    id: "flood",
                    title: "Montée Rapide des Eaux / Inondation",
                    icon: "water.waves",
                    color: Color.blue,
                    urgentTimeSeconds: 420,
                    primaryNumber: "112",
                    primaryNumberLabel: "112 (Sauvetage CGDIS)",
                    immediateActions: [
                        "Montez immédiatement aux étages supérieurs avec votre Sac 72h.",
                        "Coupez le disjoncteur électrique général et la vanne de gaz.",
                        "Placez les documents importants et appareils électroniques en hauteur.",
                        "Consultez le niveau des cours d'eau sur inondations.lu.",
                        "Restez à l'écoute des alertes LU-Alert et de la radio RTL."
                    ],
                    whatNotToDo: [
                        "Ne descendez JAMAIS dans les caves ou sous-sols (risque mortel de noyade).",
                        "Ne vous engagez JAMAIS à pied ou en voiture sur une route inondée.",
                        "Ne touchez PAS aux câbles électriques tombés dans l'eau."
                    ],
                    officialNote: "Plus de 50% des noyades lors d'inondations surviennent dans des véhicules tentant de franchir une zone inondée."
                ),
                CrisisScenario(
                    id: "fire",
                    title: "Incendie dans le Logement / Fumée",
                    icon: "smoke.fill",
                    color: Color.red,
                    urgentTimeSeconds: 180,
                    primaryNumber: "112",
                    primaryNumberLabel: "112 Secours Incendie",
                    immediateActions: [
                        "Alertez tous les occupants à voix haute.",
                        "Évacuez immédiatement en rampant au sol (l'air respirable reste sous la fumée).",
                        "Fermez les portes derrière vous pour freiner la propagation du feu.",
                        "Rassemblez la famille au point de rencontre convenu hors du bâtiment.",
                        "Appelez le 112 immédiatement depuis la rue."
                    ],
                    whatNotToDo: [
                        "Ne revenez JAMAIS sur vos pas pour récupérer des objets ou animaux.",
                        "N'utilisez JAMAIS l'ascenseur pendant un incendie.",
                        "N'ouvrez pas les portes si la poignée est chaude au toucher."
                    ],
                    officialNote: "L'inhalation de fumées toxiques est responsable de plus de 80% des décès en cas d'incendie."
                ),
                CrisisScenario(
                    id: "attack",
                    title: "Attaque / Attentat (Plan VIGILNAT)",
                    icon: "shield.slash.fill",
                    color: Color.purple,
                    urgentTimeSeconds: 300,
                    primaryNumber: "113",
                    primaryNumberLabel: "113 Police Grand-Ducale",
                    immediateActions: [
                        "1. S'ÉCHAPPER : fuyez immédiatement si une issue sécurisée est accessible.",
                        "2. SE CACHER : barricadez-vous, verrouillez les portes, éteignez les lumières et mettez les téléphones en silencieux.",
                        "3. ALERTER : contactez la Police Grand-Ducale au 113 dès que vous êtes en sécurité.",
                        "À l'arrivée des forces de l'ordre : levez les mains ouvertes et sans gestes brusques."
                    ],
                    whatNotToDo: [
                        "Ne vous exposez PAS pour filmer ou observer la situation.",
                        "Ne partagez PAS la position des forces d'intervention sur les réseaux sociaux.",
                        "Ne criez pas et ne courez pas vers les policiers les mains fermées."
                    ],
                    officialNote: "Les consignes VIGILNAT du gouvernement luxembourgeois : Échapper, Se Cacher, Alerter."
                )
            ]
        }
        return [
            CrisisScenario(
                id: "siren",
                title: "Sirene a Tocar ou Alerta LU-Alert",
                icon: "bell.badge.fill",
                color: Color.red,
                urgentTimeSeconds: 600, // 10 min
                primaryNumber: "80027788",
                primaryNumberLabel: "Info-Crise (8002 7788)",
                immediateActions: [
                    "Entre imediatamente no edifício ou habitação mais próxima.",
                    "Feche todas as portas e janelas exteriores.",
                    "Desligue a ventilação mecânica (VMC) e ar condicionado.",
                    "Ligue o rádio em RTL 88.9 / 92.5 FM ou 100.7 FM.",
                    "Consulte as informações no site governamental infocrise.public.lu.",
                    "Mantenha as linhas telefónicas livres para as equipas de socorro."
                ],
                whatNotToDo: [
                    "NÃO vá buscar os seus filhos à escola (as escolas têm plano de confinamento seguro).",
                    "NÃO permaneça no interior de viaturas ou na via pública.",
                    "NÃO sobrecarregue o 112 para pedidos de informação simples."
                ],
                officialNote: "Em caso de alarme nuclear (Cattenom) ou químico, o confinamento hermético imediato é a sua melhor proteção."
            ),
            CrisisScenario(
                id: "gas",
                title: "Cheiro Suspeito a Gás",
                icon: "flame.fill",
                color: Color.orange,
                urgentTimeSeconds: 300, // 5 min
                primaryNumber: "112",
                primaryNumberLabel: "Ligar 112 (da rua)",
                immediateActions: [
                    "Abra rapidamente portas e janelas para ventilar se o puder fazer sem demora.",
                    "Feche a válvula geral do gás (se tiver acesso seguro).",
                    "Evacue imediatamente todos os membros e animais para a rua.",
                    "Avise os vizinhos batendo à porta (sem usar a campainha elétrica).",
                    "Ligue para o 112 assim que estiver a uma distância segura no exterior."
                ],
                whatNotToDo: [
                    "NÃO acenda fósforos, isqueiros nem fume.",
                    "NÃO toque em NENHUM interruptor elétrico (nem para ligar nem para desligar).",
                    "NÃO use telefones fixos nem telemóveis dentro da habitação.",
                    "NÃO utilize o elevador."
                ],
                officialNote: "Uma única faísca microscópica de um interruptor pode desencadear uma explosão de gás."
            ),
            CrisisScenario(
                id: "blackout",
                title: "Apagão Elétrico Geral (Blackout)",
                icon: "bolt.slash.fill",
                color: Color(red: 0/255, green: 43/255, blue: 73/255),
                urgentTimeSeconds: 900, // 15 min
                primaryNumber: "112",
                primaryNumberLabel: "112 (Apenas Emergências Médicas)",
                immediateActions: [
                    "Desligue aparelhos elétricos sensíveis e televisores para evitar picos no retorno.",
                    "Mantenha o frigorífico e o congelador rigorosamente fechados.",
                    "Acenda a lanterna LED do Kit 72h (evite chamas abertas).",
                    "Sintonize o rádio a pilhas ou dínamo nas frequências oficiais do Luxemburgo.",
                    "Verifique se familiares idosos ou vizinhos vulneráveis necessitam de auxílio.",
                    "Abra o Kit 72h e confirme as provisões de água e alimentos prontos a consumir."
                ],
                whatNotToDo: [
                    "NUNCA ligue geradores ou churrasqueiras no interior da habitação (risco fatal de monóxido de carbono).",
                    "NÃO deixe velas acesas sem vigilância ou junto a cortinas.",
                    "NÃO abra repetidamente o frigorífico."
                ],
                officialNote: "O frigorífico mantém os alimentos frios cerca de 4 a 6 horas se permanecer fechado."
            ),
            CrisisScenario(
                id: "flood",
                title: "Subida Rápida das Águas / Inundação",
                icon: "water.waves",
                color: Color.blue,
                urgentTimeSeconds: 900,
                primaryNumber: "112",
                primaryNumberLabel: "112 CGDIS Secours",
                immediateActions: [
                    "Corte imediatamente a eletricidade e o gás na habitação.",
                    "Suba com a família para os pisos superiores.",
                    "Leve consigo a Mochila de Evacuação, documentos e medicação vital.",
                    "Coloque sacos de areia ou barreiras nas portas baixas.",
                    "Acompanhe o nível dos rios em inondations.lu e siga as instruções das autoridades."
                ],
                whatNotToDo: [
                    "NUNCA desça a caves, garagens ou pisos subterrâneos.",
                    "NÃO atravesse ruas ou pontes submersas a pé ou de automóvel (30 cm de água arrastam um carro).",
                    "NÃO toque em cabos elétricos caídos na água."
                ],
                officialNote: "Mais de 50% dos afogamentos em inundações acontecem dentro de viaturas que tentaram atravessar água em movimento."
            ),
            CrisisScenario(
                id: "fire",
                title: "Incêndio na Habitação / Fumo",
                icon: "smoke.fill",
                color: Color.red,
                urgentTimeSeconds: 180, // 3 min
                primaryNumber: "112",
                primaryNumberLabel: "112 Secours Incendie",
                immediateActions: [
                    "Dê o alerta a todos os ocupantes em voz alta.",
                    "Evacue imediatamente rastejando junto ao chão (o ar respirável fica por baixo do fumo).",
                    "Feche as portas atrás de si ao sair para conter a propagação do fogo.",
                    "Reúna a família no ponto de encontro acordado fora do edifício.",
                    "Ligue 112 imediatamente da via pública."
                ],
                whatNotToDo: [
                    "NÃO volte para trás para recolher pertences ou animais.",
                    "NUNCA use o elevador durante um incêndio.",
                    "NÃO abra portas que estejam quentes ao toque na maçaneta."
                ],
                officialNote: "A inalação de fumos tóxicos é a causa de mais de 80% das vítimas mortais em incêndios."
            ),
            CrisisScenario(
                id: "attack",
                title: "Ataque / Atentado (Plano VIGILNAT)",
                icon: "shield.slash.fill",
                color: Color.purple,
                urgentTimeSeconds: 300,
                primaryNumber: "113",
                primaryNumberLabel: "113 Police Grand-Ducale",
                immediateActions: [
                    "1. FUGIR: escape imediatamente se existir uma rota de saída segura e sem risco evidente.",
                    "2. ESCONDER-SE: se a fuga for perigosa, barricar portas com móveis pesados.",
                    "Apague todas as luzes e deite-se no chão longe das janelas.",
                    "Coloque todos os telemóveis em modo silêncio TOTAL (desligue também a vibração).",
                    "3. ALERTAR: ligue para o 113 assim que estiver totalmente em segurança."
                ],
                whatNotToDo: [
                    "NÃO corra em direção às forças de intervenção com as mãos nos bolsos.",
                    "NÃO partilhe nas redes sociais a posição das forças de segurança durante o evento.",
                    "NÃO faça ruídos nem use o flash da câmara."
                ],
                officialNote: "Ao aproximar-se da polícia: mostre as mãos bem abertas e palmas visíveis, não faça movimentos bruscos."
            )
        ]
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let scenario = selectedScenario {
                        scenarioDetailView(scenario)
                    } else {
                        scenarioListView
                    }
                }
                .padding()
            }
            .navigationTitle(selectedScenario == nil ? "Triagem de Crise" : "Protocolo Imediato")
            .navigationBarItems(
                leading: selectedScenario != nil ? Button("Voltar") {
                    stopTimer()
                    VoiceGuideManager.shared.stop()
                    selectedScenario = nil
                } : nil,
                trailing: Button(isFR ? "Fermer" : "Fechar") {
                    stopTimer()
                    VoiceGuideManager.shared.stop()
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onDisappear {
                stopTimer()
                VoiceGuideManager.shared.stop()
            }
        }
    }
    
    // MARK: - SCENARIO LIST VIEW
    
    private var scenarioListView: some View {
        VStack(spacing: 16) {
            // Header Banner
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                        .font(.title2)
                    Text("O QUE FAZER AGORA?")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                Text("Selecione a situação de emergência em que se encontra para obter a lista imediata de ações prioritárias e os erros fatais a evitar nos primeiros minutos.")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0/255, green: 43/255, blue: 73/255))
            .cornerRadius(14)
            
            // Grid / List of scenarios
            ForEach(scenarios) { scenario in
                Button(action: {
                    selectScenario(scenario)
                }) {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(scenario.color.opacity(0.15))
                                .frame(width: 48, height: 48)
                            Image(systemName: scenario.icon)
                                .font(.title3)
                                .foregroundColor(scenario.color)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(scenario.title)
                                .font(.subheadline.bold())
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            
                            HStack(spacing: 8) {
                                Text("\(scenario.urgentTimeSeconds / 60) min vitais")
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(scenario.color.opacity(0.2))
                                    .foregroundColor(scenario.color)
                                    .cornerRadius(4)
                                
                                Text("Ligar \(scenario.primaryNumber)")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // MARK: - SCENARIO DETAIL VIEW
    
    private func scenarioDetailView(_ scenario: CrisisScenario) -> some View {
        VStack(spacing: 16) {
            // Scenario Banner with Countdown
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: scenario.icon)
                        .font(.title)
                        .foregroundColor(.white)
                    VStack(alignment: .leading) {
                        Text(scenario.title)
                            .font(.headline.bold())
                            .foregroundColor(.white)
                        Text("Regra dos Primeiros Minutos")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                }
                
                // Countdown Timer Bar
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TEMPO DE RESPOSTA RECOMENDADO")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white.opacity(0.8))
                        Text(timeString(from: timerRemaining))
                            .font(.system(size: 26, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {
                        if isTimerActive {
                            stopTimer()
                        } else {
                            startTimer()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: isTimerActive ? "pause.fill" : "play.fill")
                            Text(isTimerActive ? "Pausar" : "Iniciar")
                                .bold()
                        }
                        .font(.caption)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .foregroundColor(scenario.color)
                        .cornerRadius(8)
                    }
                }
                .padding(10)
                .background(Color.black.opacity(0.2))
                .cornerRadius(10)
                
                // One-touch Emergency Call
                Button(action: {
                    if let url = URL(string: "tel://\(scenario.primaryNumber)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text(scenario.primaryNumberLabel)
                            .bold()
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.red)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
            }
            .padding()
            .background(scenario.color)
            .cornerRadius(14)
            
            // Voice Guide Bar (for spoken accessibility and hands-free emergency listening)
            VoiceGuideBar(
                title: scenario.title,
                textToSpeak: narrationText(for: scenario)
            )
            
            // Immediate Actions Checklist
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "checklist")
                        .foregroundColor(.green)
                    Text(isFR ? "ACTIONS IMMÉDIATES PRIORITAIRES" : "AÇÕES IMEDIATAS PRIORITÁRIAS")
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                }
                
                ForEach(scenario.immediateActions, id: \.self) { action in
                    let isChecked = checkedActions.contains(action)
                    Button(action: {
                        if isChecked {
                            checkedActions.remove(action)
                        } else {
                            checkedActions.insert(action)
                        }
                    }) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                                .font(.headline)
                                .foregroundColor(isChecked ? .green : .secondary)
                                .padding(.top, 1)
                            
                            Text(action)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .strikethrough(isChecked, color: .secondary)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    Divider()
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            
            // What NOT to do (Official Fatal Mistakes)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "xmark.octagon.fill")
                        .foregroundColor(.red)
                    Text("O QUE NUNCA DEVE FAZER")
                        .font(.caption.bold())
                        .foregroundColor(.red)
                }
                
                ForEach(scenario.whatNotToDo, id: \.self) { mistake in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(.top, 2)
                        
                        Text(mistake)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(.vertical, 2)
                }
            }
            .padding()
            .background(Color.red.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(12)
            
            // Official Authority Note
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text(scenario.officialNote)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.blue.opacity(0.08))
            .cornerRadius(10)
        }
    }
    
    private func narrationText(for scenario: CrisisScenario) -> String {
        var parts: [String] = []
        parts.append("Emergência: \(scenario.title).")
        parts.append("Tempo recomendado de resposta: \(scenario.urgentTimeSeconds / 60) minutos.")
        parts.append("Ações prioritárias:")
        for (idx, action) in scenario.immediateActions.enumerated() {
            parts.append("Passo \(idx + 1): \(action)")
        }
        parts.append("Atenção ao que nunca deve fazer:")
        for mistake in scenario.whatNotToDo {
            parts.append(mistake)
        }
        parts.append("Nota oficial governamental: \(scenario.officialNote)")
        return parts.joined(separator: ". ")
    }
    
    private func selectScenario(_ scenario: CrisisScenario) {
        VoiceGuideManager.shared.stop()
        self.selectedScenario = scenario
        self.checkedActions.removeAll()
        self.timerRemaining = scenario.urgentTimeSeconds
        startTimer()
    }
    
    private func startTimer() {
        stopTimer()
        isTimerActive = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timerRemaining > 0 {
                self.timerRemaining -= 1
            } else {
                self.stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        isTimerActive = false
        timer?.invalidate()
        timer = nil
    }
    
    private func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
