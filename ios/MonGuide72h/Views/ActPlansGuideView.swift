import SwiftUI

public struct ActPlanEntry: Identifiable {
    public var id: String { title }
    public let title: String
    public let subtitle: String
    public let icon: String
    public let color: Color
    public let whatItIs: String
    public let keyActions: [String]
    public let warning: String?
    public let officialUrl: String
}

public struct ActPlansGuideView: View {
    @ObservedObject var loc = LocalizationManager.shared
    
    public init() {}
    
    private var entries: [ActPlanEntry] {
        switch loc.currentLanguage {
        case .pt:
            return ptEntries
        case .en:
            return enEntries
        default:
            return frEntries
        }
    }
    
    public var body: some View {
        List {
            Section(header: Text(loc.tr("act_header_title"))) {
                Text(loc.tr("act_intro_desc"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 2)
            }
            
            ForEach(entries) { entry in
                NavigationLink(destination: ActPlanDetailView(entry: entry)) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(entry.color.opacity(0.15))
                                .frame(width: 40, height: 40)
                            Image(systemName: entry.icon)
                                .foregroundColor(entry.color)
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.title)
                                .font(.subheadline.bold())
                            Text(entry.subtitle)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 3)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(loc.tr("act_menu_title"))
    }
    
    // MARK: - PORTUGUÊS
    private var ptEntries: [ActPlanEntry] {
        [
            ActPlanEntry(
                title: "Ruptura de Energia (Apagão)",
                subtitle: "Plano de intervenção governamental",
                icon: "bolt.slash.fill",
                color: .orange,
                whatItIs: "Falha maciça e duradoura na rede de distribuição elétrica que impede o funcionamento normal das telecomunicações, bombagem de água e abastecimento.",
                keyActions: [
                    "Desligue imediatamente eletrodomésticos sensíveis para evitar avarias no regresso da corrente.",
                    "Mantenha frigoríficos e congeladores fechados ao máximo.",
                    "Ligue a rádio oficial a pilhas (RTL 88.9/92.5 MHz) para instruções da Célula de Crise.",
                    "Visite os centros comunitários municipais de acolhimento (RESILIENZBONUS) para abrigo aquecido e carregamento."
                ],
                warning: "PERIGO DE MORTE: Nunca acenda grelhadores, braseiros ou geradores em recintos fechados por risco de monóxido de carbono (CO).",
                officialUrl: "https://infocrise.public.lu/fr/rupture-energie/comportements-a-adopter.html"
            ),
            ActPlanEntry(
                title: "VIGILNAT (Segurança e Terrorismo)",
                subtitle: "Plano nacional de vigilância e proteção",
                icon: "shield.checkered",
                color: .red,
                whatItIs: "Dispositivo permanente e escalável destinado a prevenir a ameaça terrorista no Luxemburgo e reforçar a segurança em locais públicos e infraestruturas vitais.",
                keyActions: [
                    "FUGIR: Evacue a zona de perigo sem se colocar na linha de fogo.",
                    "ESCONDER-SE: Se não conseguir fugir, isole-se num compartimento sólido, tranque portas, desligue luzes e silencie o telemóvel.",
                    "ALERTAR: Ligue imediatamente para o 113 da Polícia logo que esteja em local seguro.",
                    "Respeite integralmente os perímetros e instruções das autoridades."
                ],
                warning: "Não divulgue localizações ou operações policiais nas redes sociais.",
                officialUrl: "https://infocrise.public.lu/fr/vigilnat/comportements-adopter.html"
            ),
            ActPlanEntry(
                title: "Ruptura de Abastecimento em Petróleo",
                subtitle: "Gestão estratégica de combustíveis",
                icon: "fuelpump.fill",
                color: .purple,
                whatItIs: "Interrupção grave das cadeias de transporte e distribuição de combustíveis rodoviários e de aquecimento a nível nacional.",
                keyActions: [
                    "Evite deslocações supérfluas e privilegie transportes partilhados ou a pé.",
                    "Respeite os limites de abastecimento por viatura fixados pelo governo.",
                    "É expressamente proibido o enchimento desmesurado de jerricãs para revenda ou açambarcamento."
                ],
                warning: "O armazenamento doméstico incorreto de gasolina ou gasóleo acarreta grave risco de incêndio e intoxicação.",
                officialUrl: "https://infocrise.public.lu/fr/rupture-petrole/informations-au-public.html"
            ),
            ActPlanEntry(
                title: "Água Potável & Contaminação",
                subtitle: "Preservação da rede e saúde pública",
                icon: "drop.triangle.fill",
                color: .blue,
                whatItIs: "Poluição acidental ou falha de bombagem nos aquíferos e reservatórios municipais de distribuição de água potável.",
                keyActions: [
                    "Não consuma água da torneira caso as autoridades emitam aviso de contaminação.",
                    "Se indicado ferver a água, mantenha-a em ebulição plena durante pelo menos 3 a 5 minutos antes de beber.",
                    "Recorra às reservas de 3L/dia por pessoa do seu Kit 72h.",
                    "Consulte os pontos de distribuição de água de emergência abertos pela comuna."
                ],
                warning: "Filtros domésticos comuns de jarro não eliminam contaminações microbiológicas graves.",
                officialUrl: "https://infocrise.public.lu/fr/eau-potable/comportements-a-adopter.html"
            ),
            ActPlanEntry(
                title: "Riscos Químicos, Biológicos e CBRN",
                subtitle: "Substâncias perigosas e acidentes Seveso",
                icon: "exclamationmark.shield.fill",
                color: .yellow,
                whatItIs: "Libertação acidental ou intencional de agentes químicos, biológicos, radiológicos ou nucleares no ar ou ambiente.",
                keyActions: [
                    "Confinamento obrigatório e imediato no piso superior ou divisão sem janelas exteriores.",
                    "Vede frinchas de portas e entradas de ar com fita adesiva e panos húmidos.",
                    "Desligue climatização, sistemas VMC e aquecimento.",
                    "Respire através de tecido húmido se sentir odor suspeito e aguarde o sinal acústico oficial de Fim de Alarme."
                ],
                warning: "Não vá buscar os filhos à escola: eles ficam em confinamento seguro com os professores e equipas de proteção civil.",
                officialUrl: "https://infocrise.public.lu/fr/cbrn/plan-gouvernemental/informations-au-public.html"
            ),
            ActPlanEntry(
                title: "Gripe Pandémica & Crise Sanitária",
                subtitle: "Proteção contra vírus e contágio massivo",
                icon: "cross.vial.fill",
                color: .teal,
                whatItIs: "Propagação acelerada de agente patogénico com sobrecarga dos centros hospitalares e serviços de emergência.",
                keyActions: [
                    "Adote rigorosas medidas de barreira: lavagem frequente das mãos e desinfeção com gel hidroalcoólico.",
                    "Uso de máscara em locais com aglomeração ou junto de pessoas do grupo de risco.",
                    "Mantenha um stock doméstico preventivo de paracetamol e medicamentos receitados para 14 dias.",
                    "Ligue para as linhas de triagem médica antes de se deslocar a uma urgência hospitalar."
                ],
                warning: "Não se auto-medique com antibióticos sem prescrição formal.",
                officialUrl: "https://infocrise.public.lu/fr/grippe-pandemie/gestes-de-protection.html"
            ),
            ActPlanEntry(
                title: "Plano de Numerosas Vítimas (NOVI)",
                subtitle: "Mobilização de socorro a grande escala",
                icon: "cross.fill",
                color: .red,
                whatItIs: "Acidente grave rodoviário, ferroviário ou catástrofe que cause dezenas de feridos simultâneos no grão-ducado.",
                keyActions: [
                    "Liberte imediatamente os corredores de emergência na estrada para passagem de ambulâncias e bombeiros.",
                    "Não sature a linha 112 com pedidos de curiosidade; a linha deve estar reservada exclusivamente a chamadas de socorro.",
                    "Consulte a Linha Verde Info-Crise (8002 7788) para localização de familiares e informações oficiais."
                ],
                warning: "Não filme nem publique imagens de vítimas nas redes sociais: respeite a dignidade e facilite o socorro.",
                officialUrl: "https://infocrise.public.lu/fr/nombreuses-victimes/plan-gouvernemental/informations-au-public.html"
            )
        ]
    }
    
    // MARK: - FRANÇAIS
    private var frEntries: [ActPlanEntry] {
        [
            ActPlanEntry(
                title: "Rupture d'énergie (Black-out)",
                subtitle: "Plan gouvernemental d'intervention",
                icon: "bolt.slash.fill",
                color: .orange,
                whatItIs: "Panne majeure et prolongée du réseau électrique paralysant transports, télécoms et pompage de l'eau.",
                keyActions: [
                    "Débranchez les appareils sensibles pour éviter les surtensions au retour du courant.",
                    "Gardez réfrigérateurs et congélateurs fermés au maximum.",
                    "Écoutez la radio à piles (RTL 88.9/92.5 MHz) pour les instructions officielles.",
                    "Rendez-vous aux centres communaux d'accueil (RESILIENZBONUS) pour vous réchauffer."
                ],
                warning: "DANGER DE MORT : N'utilisez jamais de groupe électrogène ou brasero en intérieur (intoxication au monoxyde de carbone).",
                officialUrl: "https://infocrise.public.lu/fr/rupture-energie/comportements-a-adopter.html"
            ),
            ActPlanEntry(
                title: "Plan VIGILNAT (Terrorisme)",
                subtitle: "Protection des personnes et des sites",
                icon: "shield.checkered",
                color: .red,
                whatItIs: "Dispositif national de vigilance et de protection contre la menace terroriste au Luxembourg.",
                keyActions: [
                    "FUIR : Éloignez-vous de la zone de danger.",
                    "SE CACHER : Enfermez-vous dans un local sûr, bloquez les accès, silenciez votre téléphone.",
                    "ALERTER : Appelez le 113 dès que vous êtes en sécurité.",
                    "Suivez scrupuleusement les consignes des forces de l'ordre."
                ],
                warning: "Ne divulguez pas les positions des forces de police sur les réseaux sociaux.",
                officialUrl: "https://infocrise.public.lu/fr/vigilnat/comportements-adopter.html"
            ),
            ActPlanEntry(
                title: "Rupture de pétrole",
                subtitle: "Gestion des carburants en cas de crise",
                icon: "fuelpump.fill",
                color: .purple,
                whatItIs: "Perturbation majeure de l'approvisionnement en carburants et combustibles de chauffage.",
                keyActions: [
                    "Limitez les déplacements automobiles au strict nécessaire.",
                    "Respectez les restrictions de distribution décidées par le gouvernement.",
                    "Remplissage abusif de jerricans strictement prohibé."
                ],
                warning: "Le stockage non sécurisé d'hydrocarbures présente un risque majeur d'incendie et d'explosion.",
                officialUrl: "https://infocrise.public.lu/fr/rupture-petrole/informations-au-public.html"
            ),
            ActPlanEntry(
                title: "Eau potable & Contamination",
                subtitle: "Préservation du réseau sanitaire",
                icon: "drop.triangle.fill",
                color: .blue,
                whatItIs: "Pollution accidentelle ou arrêt de pompage sur les réseaux de distribution d'eau potable.",
                keyActions: [
                    "Ne buvez pas l'eau du robinet si une alerte de contamination est émise.",
                    "Faites bouillir l'eau à gros bouillons pendant 3 à 5 minutes si préconisé.",
                    "Utilisez votre réserve de 3L/jour/personne du Kit 72h.",
                    "Repérez les points de distribution d'urgence mis en place par la commune."
                ],
                warning: "Les carafes filtrantes ordinaires n'éliminent pas les agents pathogènes graves.",
                officialUrl: "https://infocrise.public.lu/fr/eau-potable/comportements-a-adopter.html"
            ),
            ActPlanEntry(
                title: "Accidents CBRN & Chimiques",
                subtitle: "Substances dangereuses et Seveso",
                icon: "exclamationmark.shield.fill",
                color: .yellow,
                whatItIs: "Rejet accidentel ou malveillant de substances chimiques, biologiques ou radiologiques dans l'air.",
                keyActions: [
                    "Confinement immédiat dans un bâtiment fermé, de préférence à l'étage.",
                    "Calfeutrez portes, fenêtres et bouches d'aération avec du ruban adhésif.",
                    "Arrêtez toute climatisation et ventilation mécanique.",
                    "Attendez le signal sonore de Fin d'Alarme pour quitter l'abri."
                ],
                warning: "N'allez pas chercher vos enfants à l'école : ils sont pris en charge en sécurité sur place.",
                officialUrl: "https://infocrise.public.lu/fr/cbrn/plan-gouvernemental/informations-au-public.html"
            )
        ]
    }
    
    // MARK: - ENGLISH
    private var enEntries: [ActPlanEntry] {
        [
            ActPlanEntry(
                title: "Power Cut Outage (Blackout)",
                subtitle: "Government Contingency Plan",
                icon: "bolt.slash.fill",
                color: .orange,
                whatItIs: "Massive electrical failure paralyzing communications, water pumping and heating.",
                keyActions: [
                    "Unplug sensitive electronic appliances to avoid power-surge damages upon grid restoration.",
                    "Keep refrigerators and freezers closed as much as possible.",
                    "Turn on battery radio (RTL 88.9/92.5 MHz) for verified crisis instructions.",
                    "Visit municipal shelters (RESILIENZBONUS) for heating and device charging."
                ],
                warning: "LETHAL DANGER: Never run fuel generators or charcoal grills indoors due to carbon monoxide poisoning.",
                officialUrl: "https://infocrise.public.lu/fr/rupture-energie/comportements-a-adopter.html"
            ),
            ActPlanEntry(
                title: "VIGILNAT Plan (Terrorism)",
                subtitle: "National surveillance and protection",
                icon: "shield.checkered",
                color: .red,
                whatItIs: "Permanent vigilance framework against terrorist threats and public safety incidents.",
                keyActions: [
                    "RUN: Escape the danger area if possible.",
                    "HIDE: Shelter inside a solid room, lock doors, silence mobile phone.",
                    "TELL: Dial 113 as soon as you are safe.",
                    "Follow security forces' orders without hesitation."
                ],
                warning: "Do not post police tactical positions on social networks.",
                officialUrl: "https://infocrise.public.lu/fr/vigilnat/comportements-adopter.html"
            )
        ]
    }
}

public struct ActPlanDetailView: View {
    let entry: ActPlanEntry
    @ObservedObject var loc = LocalizationManager.shared
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                // Header
                HStack(spacing: 12) {
                    Image(systemName: entry.icon)
                        .font(.system(size: 32))
                        .foregroundColor(entry.color)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.title)
                            .font(.title3.bold())
                        Text(entry.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 4)
                
                // Description
                Text(entry.whatItIs)
                    .font(.body)
                    .lineSpacing(5)
                
                // Warning
                if let w = entry.warning {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "exclamationmark.octagon.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                        Text(w)
                            .font(.subheadline.bold())
                            .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.red.opacity(0.12))
                    .cornerRadius(10)
                }
                
                // Actions
                VStack(alignment: .leading, spacing: 10) {
                    Text(loc.tr("act_plan_actions"))
                        .font(.headline)
                    
                    ForEach(entry.keyActions, id: \.self) { act in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(entry.color)
                                .font(.subheadline)
                                .padding(.top, 2)
                            Text(act)
                                .font(.subheadline)
                                .lineSpacing(3)
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                
                // Web link
                if let url = URL(string: entry.officialUrl) {
                    Link(destination: url) {
                        HStack {
                            Image(systemName: "safari.fill")
                            Text(loc.tr("open_infocrise_sheet"))
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
