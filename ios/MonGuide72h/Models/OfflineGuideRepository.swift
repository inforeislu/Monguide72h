import Foundation

public struct OfficialGuideChapter: Identifiable {
    public let id: Int
    public let chapterNumber: Int
    public let titleKey: String
    public let subtitleKey: String
    public let icon: String
    public let sections: [OfficialGuideSection]
}

public struct OfficialGuideSection: Identifiable {
    public var id: String { titleKey }
    public let titleKey: String
    public let subtitleKey: String?
    public let icon: String
    public let paragraphs: [String]
    public let bulletPoints: [String]
    public let alertNotice: String?
    public let referenceWebsite: String?
}

public class OfflineGuideRepository {
    public static let shared = OfflineGuideRepository()
    
    private init() {}
    
    public func getChapters(for language: AppLanguage) -> [OfficialGuideChapter] {
        switch language {
        case .pt:
            return ptChapters
        case .fr:
            return frChapters
        case .en:
            return enChapters
        case .de:
            return deChapters
        case .lu:
            return luChapters
        case .es:
            return ptChapters
        case .it:
            return frChapters
        default:
            return enChapters
        }
    }
    
    // MARK: - PORTUGUÊS (Diretamente do Livro Oficial Lëtz Prepare)
    private var ptChapters: [OfficialGuideChapter] {
        [
            OfficialGuideChapter(
                id: 1,
                chapterNumber: 1,
                titleKey: "1. Perceber & Antecipar",
                subtitleKey: "Estratégia Nacional de Resiliência e Riscos no Luxemburgo",
                icon: "shield.lefthalf.filled",
                sections: [
                    OfficialGuideSection(
                        titleKey: "Juntos, Lëtz prepare !",
                        subtitleKey: "A resiliência da sociedade",
                        icon: "person.3.fill",
                        paragraphs: [
                            "A resiliência é a capacidade de uma sociedade enfrentar as dificuldades, imprevistos ou situações de emergência e restabelecer o seu funcionamento normal após uma crise.",
                            "Uma tempestade, inundação, apagão elétrico, pandemia, ciberataque, acidente industrial ou nuclear podem perturbar durablemente o acesso a bens vitais como água potável, eletricidade ou telecomunicações.",
                            "Em 2025, o Luxemburgo lançou a Estratégia Nacional de Resiliência «Lëtz prepare!». Cada cidadão tem uma responsabilidade partilhada na proteção da família e vizinhança."
                        ],
                        bulletPoints: [
                            "Cultura de prevenção e responsabilidade partilhada",
                            "Apoio prioritário às pessoas mais vulneráveis",
                            "Libertar os meios de socorro para quem mais precisa"
                        ],
                        alertNotice: nil,
                        referenceWebsite: "letzprepare.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Fenómenos Meteorológicos",
                        subtitleKey: "Tempestades, neve, ondas de calor e trovoadas",
                        icon: "cloud.bolt.rain.fill",
                        paragraphs: [
                            "As intempéries podem perturbar as deslocações, fornecimento de energia e segurança física dos cidadãos."
                        ],
                        bulletPoints: [
                            "Limite as suas deslocações e permaneça no interior sempre que possível.",
                            "Se tiver de sair, avise os familiares sobre destino e horário previsto.",
                            "Guarde no interior objetos exteriores que possam ser levados pelo vento.",
                            "Tenha no veículo equipamento de emergência (manta, água, correntes de neve).",
                            "Em ondas de calor, siga as orientações de hidratação em santesecu.public.lu."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "meteolux.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Inundações & Cheias Súbitas",
                        subtitleKey: "Prevenção e proteção nas margens e caves",
                        icon: "water.waves",
                        paragraphs: [
                            "Precipitações intensas provocam subida rápida dos cursos de água, ameaçando caves, habitações e vias rodoviárias."
                        ],
                        bulletPoints: [
                            "Consulte as cartas de zonas inundáveis em inondations.lu e eau.geoportail.lu.",
                            "Verifique caleiras, tubos de escoamento e sarjetas.",
                            "Eleve eletrodomésticos e produtos químicos e poluentes guardados nas caves.",
                            "Retire os veículos das zonas inundáveis enquanto houver tempo seguro.",
                            "NUNCA entre em vias submersas, caves ou parques subterrâneos inundados."
                        ],
                        alertNotice: "PERIGO DE MORTE: Desligue a eletricidade nas áreas com risco de inundação e NUNCA caminhe em águas que possam estar sob tensão elétrica!",
                        referenceWebsite: "inondations.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Ciberataques & Fraude Digital",
                        subtitleKey: "Proteção contra phishing, malware e extorsão",
                        icon: "lock.shield.fill",
                        paragraphs: [
                            "Tentativas de phishing, ransomware e burla bancária podem paralisar serviços vitais e comprometer dados privados."
                        ],
                        bulletPoints: [
                            "Confirme pedidos invulgares diretamente junto das entidades oficiais.",
                            "Digite o endereço no navegador em vez de clicar em links de SMS/email.",
                            "Use senhas longas e únicas com autenticação de dois fatores (2FA).",
                            "Faça cópias de segurança (backups offline) dos documentos e fotografias.",
                            "Em caso de fraude bancária, contacte de imediato o banco ou Worldline para bloquear cartões e transações."
                        ],
                        alertNotice: "Se o seu dispositivo estiver infetado, desligue-o imediatamente de toda e qualquer rede (Wi-Fi, cabo de rede e dados móveis).",
                        referenceWebsite: "cybersecurity.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Ameaça Terrorista",
                        subtitleKey: "Comportamentos em locais públicos",
                        icon: "exclamationmark.octagon.fill",
                        paragraphs: [
                            "Esteja atento ao seu redor em transportes, edifícios públicos e grandes eventos. Comunique comportamentos suspeitos à polícia."
                        ],
                        bulletPoints: [
                            "FUGIR: Afaste-se da zona de perigo sem se expor.",
                            "ESCONDER-SE: Se não puder fugir, procure abrigo sólido, feche e bloqueie portas, silencie completamente o telemóvel.",
                            "ALERTAR: Ligue para o 113 logo que estiver em segurança.",
                            "Facilite a intervenção dos serviços de socorro e não regresse ao local."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "police.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Acidente Nuclear",
                        subtitleKey: "Confinamento e toma controlada de Iodo",
                        icon: "atom",
                        paragraphs: [
                            "Embora muito pouco provável, um acidente nuclear exige confinamento imediato e medidas radiológicas rigorosas."
                        ],
                        bulletPoints: [
                            "Abrigue-se num edifício sólido e feche portas, janelas e estores.",
                            "Desligue a climatização, ventiladores mecânicos e renovadores de ar.",
                            "Tenha à mão os comprimidos de iodeto de potássio distribuídos pelos municípios."
                        ],
                        alertNotice: "ATENÇÃO: Tome os comprimidos de iodo APENAS POR ORDEM EXPRESSA DAS AUTORIDADES via rádio/LU-Alert. Indicados para menores de 45 anos.",
                        referenceWebsite: "infocrise.lu"
                    )
                ]
            ),
            OfficialGuideChapter(
                id: 2,
                chapterNumber: 2,
                titleKey: "2. O Alerta & A Informação",
                subtitleKey: "LU-Alert, Sirenes Oficiais e Falha Geral de Eletricidade",
                icon: "speaker.wave.3.fill",
                sections: [
                    OfficialGuideSection(
                        titleKey: "Sistema Nacional LU-Alert",
                        subtitleKey: "Abordagem multicanal de aviso à população",
                        icon: "antenna.radiowaves.left.and.right",
                        paragraphs: [
                            "O LU-Alert difunde mensagens em simultâneo através de sirenes, Cell Broadcast, SMS geolocalizado, aplicação móvel, sítio web e comunicação social."
                        ],
                        bulletPoints: [
                            "Cell Broadcast (CB): Mensagens prioritárias com som e vibração estridentes mesmo em modo de silêncio.",
                            "SMS Geolocalizado: Enviado a todos os telemóveis ligados às antenas da zona afetada.",
                            "Níveis de Vigilância: Amarelo (Atenção), Laranja (Prudência), Vermelho (Vigilância Máxima), Roxo (Perigo Iminente)."
                        ],
                        alertNotice: "A RÁDIO A PILHAS (RTL 88.9/92.5 MHz e rádio 100.7) é o canal mais resiliente caso a rede de telecomunicações colapse!",
                        referenceWebsite: "lu-alert.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Os 4 Sinais Sonoros das Sirenes Nacionais",
                        subtitleKey: "Códigos acústicos testados na 1.ª segunda-feira do mês",
                        icon: "bell.badge.fill",
                        paragraphs: [
                            "As sirenes avisam a população em caso de perigo grave. Distinguem-se claramente pela frequência do som:"
                        ],
                        bulletPoints: [
                            "1. Teste Mensal (60 segundos): Tom contínuo à 1.ª segunda-feira do mês ao meio-dia. Nenhuma ação requerida.",
                            "2. Sinal de Alerta (2 minutos): Tom contínuo. Procure local seguro e informe-se pelos canais oficiais.",
                            "3. Sinal Nacional de Alarme (60 segundos): Tom ascendente e descendente (uivo ondulante). Abrigue-se imediatamente em edifício sólido com portas e janelas fechadas.",
                            "4. Fim de Alarme (60 segundos): Tom oscilante com interrupções regulares (12s som / 12s pausa). Perigo afastado, retoma das atividades normais."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Efeito em Cascata de um Apagão Geral",
                        subtitleKey: "Como a falta de energia afeta todos os serviços",
                        icon: "bolt.slash.fill",
                        paragraphs: [
                            "Um grande corte de eletricidade gera paragens consecutivas em telecomunicações, bombagem de água potável, transportes e cadeias de frio."
                        ],
                        bulletPoints: [
                            "Habitação: sem luz, sem fogões elétricos, sem aquecimento central e elevadores bloqueados.",
                            "Telecomunicações: redes móveis e internet instáveis ou em colapso total após esgotamento das baterias de suporte das antenas.",
                            "Água e Saneamento: paragem das estações elevatórias; autoclismos e torneiras deixam de funcionar nas zonas altas.",
                            "Pagamentos e Comércio: caixas multibanco (ATM) desligados, terminais de cartões inoperacionais, lojas encerradas."
                        ],
                        alertNotice: "NUNCA use geradores, grelhadores ou braseiros dentro de casa. Risco mortal de asfixia por Monóxido de Carbono (CO).",
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Crónica Fictícia dos 3 Dias de Crise",
                        subtitleKey: "O que acontece na prática de hora a hora",
                        icon: "clock.arrow.circlepath",
                        paragraphs: [
                            "• DIA 1 (O Choque): Corte às escuras no inverno. Trânsito caótico com semáforos desligados. Regresso a casa a pé ou à boleia. Iluminação com velas e lanterna. Encher garrafas e banheira enquanto houver pressão de água.",
                            "• DIA 2 (A Adaptação): Casa fria. Telemóvel em poupança máxima. Alimentação à base de conservas no fogareiro a gás. Comida guardada no exterior para não abrir o frigorífico. Desligar disjuntores para proteger contra sobretensões.",
                            "• DIA 3 (A Entreajuda): Abertura do centro municipal de acolhimento (RESILIENZBONUS) com geradores, bebidas quentes e ponto de encontro. A rádio confirma o início do restabelecimento progressivo por sectores."
                        ],
                        bulletPoints: [
                            "Mantenha a calma e evite boatos de redes sociais não confirmados.",
                            "Confie e sintonize rádios oficiais a pilhas.",
                            "Preste apoio a idosos e vizinhos vulneráveis."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    )
                ]
            ),
            OfficialGuideChapter(
                id: 3,
                chapterNumber: 3,
                titleKey: "3. A Ação das Autoridades",
                subtitleKey: "Planos Governamentais, Célula de Crise e Apoio Municipal",
                icon: "building.columns.fill",
                sections: [
                    OfficialGuideSection(
                        titleKey: "Célula de Crise Nacional (CC)",
                        subtitleKey: "Coordenação sob o Plano Ruptura de Energia",
                        icon: "person.2.badge.gearshape.fill",
                        paragraphs: [
                            "Em caso de crise severa, é ativado o plano governamental e constituída a Célula de Crise (CC) com autoridades públicas, CGDIS, Polícia, Exército e gestores técnicos da rede (Creos).",
                            "Operam paralelamente a Célula de Avaliação, a Célula Operacional Interministerial e a Célula de Comunicação e Informação (CCI) para emitir boletins transparentes à população."
                        ],
                        bulletPoints: [
                            "Proteção de infraestruturas críticas: hospitais, água potável, serviços de emergência.",
                            "Mobilização do dispositivo RESC-LU no seio do CGDIS para reforço de geradores e motobombas.",
                            "Restabelecimento elétrico ordenado e progressivo para evitar novo colapso da rede elétrica europeia."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "infocrise.gov.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Ação a Nível Local (Comunas)",
                        subtitleKey: "Planos Locais de Resiliência (PLR) e Centros de Acolhimento",
                        icon: "house.and.flag.fill",
                        paragraphs: [
                            "Cada comuna luxemburguesa estabelece o seu Plano Local de Resiliência e dispõe de edifícios adaptados segundo a norma RESILIENZBONUS.",
                            "Estes centros locais proporcionam abrigo aquecido, fornecimento de água potável, refeições ligeiras e carregamento elétrico de emergência."
                        ],
                        bulletPoints: [
                            "Apoio social direto aos cidadãos isolados",
                            "Partilha de meios móveis entre comunas vizinhas",
                            "Avisos presenciais e boletins impressos nos quadros da comuna se as redes falharem"
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    )
                ]
            ),
            OfficialGuideChapter(
                id: 4,
                chapterNumber: 4,
                titleKey: "4. O Meu Kit & Plano de Emergência",
                subtitleKey: "Checklist Oficial de 72h e Diretivas de Evacuação",
                icon: "list.clipboard.fill",
                sections: [
                    OfficialGuideSection(
                        titleKey: "As 3 Etapas Fundamentais de Preparação",
                        subtitleKey: "Estar preparado já é agir!",
                        icon: "checkmark.seal.fill",
                        paragraphs: [
                            "1. Constitua o seu kit de preparação 72h no seu lar com artigos vitais.",
                            "2. Preencha o plano pessoal de emergência e guarde uma versão IMPRESSA em papel.",
                            "3. Fale com a sua família e vizinhos para criar uma rede de apoio solidária."
                        ],
                        bulletPoints: [
                            "Revise as datas de validade das conservas e pilhas 2 vezes por ano.",
                            "Tenha sempre dinheiro vivo em notas pequenas (10€, 20€) e moedas.",
                            "Conserve cópias plastificadas dos bilhetes de identidade, apólices de seguro e receitas médicas."
                        ],
                        alertNotice: "Guarde uma versão impressa em papel deste plano! Em caso de corte total de eletricidade prolongado, as baterias esgotam-se.",
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Cálculo de Provisões Vitais (3 Dias)",
                        subtitleKey: "Recomendações nutricionais e hídricas oficiais",
                        icon: "drop.fill",
                        paragraphs: [
                            "Água potável: Pelo menos 3 litros por pessoa e por dia (2L para consumo e hidratação direta, 1L para higiene básica e preparação alimentar simples).",
                            "Alimentos não perecíveis: conservas de peixe e carne, leguminosas em frascos, massas, arroz, barras energéticas, frutos secos e comida adequada para animais de companhia."
                        ],
                        bulletPoints: [
                            "Adulto / Criança: 9 Litros de água (6 garrafas de 1,5L) por cada período de 72h.",
                            "Bebés: Água mineral com baixo teor de sódio para leites em pó e fraldas suficientes.",
                            "Animais de estimação: ração seca e 1,5L de água por animal pequeno."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Mochila de Evacuação Rápida (< 10 kg)",
                        subtitleKey: "O que levar se tiver de abandonar a casa em minutos",
                        icon: "backpack.fill",
                        paragraphs: [
                            "Uma mochila leve, impermeável, pronta junto à porta de saída:",
                            "1-2 garrafas de água (1L a 1,5L), snacks calóricos, medicação dos próximos 3 dias, receitas médicas, telemóvel e cabo, power bank carregado, carteira com documentos e dinheiro, chaves suplentes de casa e do carro, muda de roupa quente e calçado robusto."
                        ],
                        bulletPoints: [
                            "Peso recomendado: inferior a 10 kg para mobilidade sem cansaço.",
                            "Saco de primeiros socorros compacto.",
                            "Toalhitas desinfetantes e artigos de higiene feminina/infantil."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Contactos Úteis e Emergência",
                        subtitleKey: "Números gratuitos e linhas de apoio",
                        icon: "phone.bubble.left.fill",
                        paragraphs: [
                            "• 112: CGDIS (Ambulância, Bombeiros, Salvamento)",
                            "• 113: Polícia Grão-Ducal",
                            "• 8002 7788: Linha Verde Info-Crise (ativada durante crises graves)",
                            "• Rádio RTL: FM 88.9 MHz / 92.5 MHz",
                            "• Rádio 100.7: FM 100.7 MHz"
                        ],
                        bulletPoints: [
                            "Use o 112 e 113 apenas em perigo real. Nunca faça chamadas de teste.",
                            "Evite chamadas para telemóveis normais para não saturar as antenas."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "112.public.lu"
                    )
                ]
            )
        ]
    }
    
    // MARK: - FRANÇAIS
    private var frChapters: [OfficialGuideChapter] {
        [
            OfficialGuideChapter(
                id: 1,
                chapterNumber: 1,
                titleKey: "1. Comprendre & Anticiper",
                subtitleKey: "Stratégie nationale de résilience et risques au Luxembourg",
                icon: "shield.lefthalf.filled",
                sections: [
                    OfficialGuideSection(
                        titleKey: "Ensemble, Lëtz prepare !",
                        subtitleKey: "La résilience de notre société",
                        icon: "person.3.fill",
                        paragraphs: [
                            "La résilience, c'est la capacité d'une société à faire face aux difficultés, à des imprévus ou situations d'urgence et à rétablir un fonctionnement normal après une crise.",
                            "Une tempête, une inondation, une coupure d'électricité majeure, une pandémie ou un accident industriel peuvent perturber durablement l'accès à l'eau, à l'électricité et aux télécommunications.",
                            "En 2025, le Luxembourg a lancé la Stratégie nationale de résilience « Lëtz prepare ! ». Chacun contribue à la sécurité collective."
                        ],
                        bulletPoints: [
                            "Culture de prévention et de responsabilité partagée",
                            "Soutien prioritaire aux personnes les plus vulnérables",
                            "Permettre aux secours d'intervenir auprès des urgences vitales"
                        ],
                        alertNotice: nil,
                        referenceWebsite: "letzprepare.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Phénomènes Météorologiques",
                        subtitleKey: "Tempêtes, fortes pluies, neige, verglas et canicules",
                        icon: "cloud.bolt.rain.fill",
                        paragraphs: [
                            "Les intempéries peuvent perturber les transports et l'approvisionnement en énergie."
                        ],
                        bulletPoints: [
                            "Limitez vos déplacements et restez à l'intérieur.",
                            "Prévenez vos proches de votre départ et de votre destination.",
                            "Mettez à l'abri les objets susceptibles d'être emportés par le vent.",
                            "Conservez des équipements de base dans le véhicule (couverture, eau).",
                            "En cas de canicule, suivez les conseils sanitaires sur santesecu.public.lu."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "meteolux.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Inondations & Crues Soudaines",
                        subtitleKey: "Consignes de sécurité en zones submersibles",
                        icon: "water.waves",
                        paragraphs: [
                            "Des précipitations intenses provoquent des crues menaçant habitations et sous-sols."
                        ],
                        bulletPoints: [
                            "Consultez les cartes des zones inondables sur inondations.lu et eau.geoportail.lu.",
                            "Vérifiez l'état des gouttières, canalisations et grilles d'évacuation.",
                            "Surélevez les appareils électroménagers et produits polluants stockés en cave.",
                            "Éloignez les véhicules des zones inondables s'il est encore temps.",
                            "Évitez les voies submergées, sous-sols et parkings souterrains."
                        ],
                        alertNotice: "DANGER DE MORT : Coupez le courant dans les pièces inondables et ne marchez jamais dans une eau susceptible d'être sous tension.",
                        referenceWebsite: "inondations.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Attaques Cyber",
                        subtitleKey: "Gestes d'hygiène numérique et fraude",
                        icon: "lock.shield.fill",
                        paragraphs: [
                            "Le phishing, les ransomwares et les arnaques peuvent paralyser des services et compromettre vos identifiants."
                        ],
                        bulletPoints: [
                            "Vérifiez les demandes inhabituelles auprès des coordonnées officielles.",
                            "Tapez les adresses web directement dans le navigateur sans cliquer sur des liens reçus.",
                            "Utilisez un gestionnaire de mots de passe et l'authentification à deux facteurs (2FA).",
                            "Effectuez des sauvegardes régulières hors ligne de vos documents.",
                            "En cas de fraude financière, contactez immédiatement votre banque ou Worldline."
                        ],
                        alertNotice: "Si un appareil est infecté, déconnectez-le immédiatement de tout réseau (Wi-Fi, câble et données mobiles).",
                        referenceWebsite: "cybersecurity.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Menace Terroriste",
                        subtitleKey: "Réflexes en cas d'attaque ou danger immédiat",
                        icon: "exclamationmark.octagon.fill",
                        paragraphs: [
                            "Restez vigilant dans les lieux publics, transports et rassemblements. Signalez tout comportement suspect."
                        ],
                        bulletPoints: [
                            "S'ÉLOIGNER du danger sans vous exposer.",
                            "SE METTRE À L'ABRI : fermez et bloquez les accès, silenciez votre téléphone, évitez tout bruit.",
                            "ALERTER le 113 dès que vous êtes en sécurité.",
                            "Facilitez le travail des secours et ne retournez pas sur les lieux."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "police.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Accident Nucléaire",
                        subtitleKey: "Mise à l'abri et comprimés d'iode",
                        icon: "atom",
                        paragraphs: [
                            "Un accident nucléaire exige un confinement immédiat et une discipline stricte."
                        ],
                        bulletPoints: [
                            "Mettez-vous à l'abri dans un bâtiment solide, fermez portes, fenêtres et volets.",
                            "Arrêtez les ventilations mécaniques et climatiseurs.",
                            "Gardez à portée de main les comprimés d'iodure de potassium fournis par la commune."
                        ],
                        alertNotice: "ATTENTION : Prenez vos comprimés d'iode UNIQUEMENT sur consigne officielle des autorités. Destinés aux personnes de moins de 45 ans.",
                        referenceWebsite: "infocrise.lu"
                    )
                ]
            ),
            OfficialGuideChapter(
                id: 2,
                chapterNumber: 2,
                titleKey: "2. L'Alerte & L'Information",
                subtitleKey: "Système LU-Alert, Sirènes et Panne d'Électricité",
                icon: "speaker.wave.3.fill",
                sections: [
                    OfficialGuideSection(
                        titleKey: "LU-Alert & Canaux d'Information",
                        subtitleKey: "Système national d'alerte multicanal",
                        icon: "antenna.radiowaves.left.and.right",
                        paragraphs: [
                            "LU-Alert diffuse les messages via Cell Broadcast, SMS géolocalisés, application mobile et médias."
                        ],
                        bulletPoints: [
                            "Cell Broadcast (CB) : Alerte prioritaire avec signal sonore et vibration même en mode silencieux.",
                            "Niveaux de vigilance : Jaune (Attention), Orange (Prudence), Rouge (Vigilance absolue), Violet (Danger imminent).",
                            "La radio à piles (RTL 88.9/92.5 MHz et radio 100.7) reste le canal le plus résilient."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "lu-alert.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Les 4 Signaux des Sirènes",
                        subtitleKey: "Signaux sonores testés le premier lundi du mois",
                        icon: "bell.badge.fill",
                        paragraphs: [
                            "Les sirènes retentissent en cas de danger important ou imminent :"
                        ],
                        bulletPoints: [
                            "1. Test mensuel (60s) : Tonalité continue. Aucune action requise.",
                            "2. Signal d'alerte (2 min) : Tonalité continue. Mettez-vous en sécurité et écoutez la radio.",
                            "3. Signal national d'alarme (60s) : Tonalité montante et descendante. Mettez-vous à l'abri immédiatement dans un bâtiment solide fermé.",
                            "4. Fin d'alarme (60s) : Tonalité montante/descendante avec interruptions de 12s. Risque écarté, reprise normale des activités."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Effet Cascade d'une Coupure d'Électricité",
                        subtitleKey: "Les répercussions majeures d'un black-out",
                        icon: "bolt.slash.fill",
                        paragraphs: [
                            "Une coupure prolongée affecte le chauffage, l'eau courante, les transports et les terminaux bancaires."
                        ],
                        bulletPoints: [
                            "Éclairage et appareils hors service.",
                            "Réseaux télécoms instables après épuisement des batteries de secours.",
                            "Approvisionnement en eau potable perturbé dans les zones de pompage.",
                            "DAB/ATM indisponibles et paiements électroniques impossibles."
                        ],
                        alertNotice: "Ne jamais utiliser de barbecue, brasero ou groupe électrogène en intérieur : risque d'intoxication mortelle au monoxyde de carbone.",
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Scénario Fictif des 72 Heures",
                        subtitleKey: "Chronologie du jour 1 au jour 3",
                        icon: "clock.arrow.circlepath",
                        paragraphs: [
                            "• Jour 1 : Panne soudaine en plein hiver. Fin précoce du travail, retour à pied ou covoiturage. Utilisation des lampes de poche, bougies et réchaud. Réserve d'eau tant que le robinet coule.",
                            "• Jour 2 : Maison froide. Économie de batterie du téléphone. Stockage extérieur de la nourriture pour préserver la chaîne du froid. Débranchement des appareils sensibles.",
                            "• Jour 3 : Entraide de quartier. Accueil au centre communal (RESILIENZBONUS) avec boissons chaudes et recharge. La radio annonce le retour progressif de l'électricité."
                        ],
                        bulletPoints: [
                            "Restez calme et évitez de propager des rumeurs non vérifiées.",
                            "Informez-vous uniquement via les canaux officiels.",
                            "Prenez des nouvelles des voisins vulnérables."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    )
                ]
            ),
            OfficialGuideChapter(
                id: 3,
                chapterNumber: 3,
                titleKey: "3. L'Action des Autorités",
                subtitleKey: "Cellule de Crise et Organisation des Secours",
                icon: "building.columns.fill",
                sections: [
                    OfficialGuideSection(
                        titleKey: "Cellule de Crise & Rétablissement",
                        subtitleKey: "Coordination nationale",
                        icon: "person.2.badge.gearshape.fill",
                        paragraphs: [
                            "Activation du plan gouvernemental « Rupture d'énergie ». La Cellule de Crise coordonne les actions des opérateurs et services de secours (CGDIS, Police, Armée).",
                            "Déploiement de la réserve nationale de capacités « RESC-LU » pour approvisionner les sites critiques en énergie de secours."
                        ],
                        bulletPoints: [
                            "Priorité accordée aux hôpitaux et services d'eau potable.",
                            "Rétablissement progressif et ordonné pour stabiliser le réseau électrique.",
                            "Information régulière et vérifiée transmise par la CCI."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "infocrise.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Centres Communaux d'Accueil (PLR)",
                        subtitleKey: "Normes RESILIENZBONUS",
                        icon: "house.and.flag.fill",
                        paragraphs: [
                            "Les communes activent leur plan local de résilience avec des salles chauffées, points d'eau, générateurs pour recharger les téléphones et assistance de proximité."
                        ],
                        bulletPoints: [
                            "Abris temporaires chauffés ouverts aux citoyens.",
                            "Distribution de couvertures et de vivres aux personnes en difficulté.",
                            "Affichages municipaux en cas de black-out complet des télécommunications."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    )
                ]
            ),
            OfficialGuideChapter(
                id: 4,
                chapterNumber: 4,
                titleKey: "4. Mon Kit & Mon Plan d'Urgence",
                subtitleKey: "Checklist 72h, Sac d'Évacuation et Contacts",
                icon: "list.clipboard.fill",
                sections: [
                    OfficialGuideSection(
                        titleKey: "Les 3 Étapes de Préparation",
                        subtitleKey: "Être préparé, c'est déjà agir !",
                        icon: "checkmark.seal.fill",
                        paragraphs: [
                            "1. Constituez votre kit de préparation à domicile.",
                            "2. Remplissez le plan personnel d'urgence et gardez-en une version PAPIER.",
                            "3. Parlez-en à votre entourage et organisez l'entraide de quartier."
                        ],
                        bulletPoints: [
                            "Vérifiez les dates de péremption au moins 2 fois par an.",
                            "Prévoyez de l'argent liquide en petites coupures et pièces.",
                            "Conservez une copie étanche des pièces d'identité et polices d'assurance."
                        ],
                        alertNotice: "Conservez impérativement une version papier de votre plan en cas de panne de batterie de votre téléphone !",
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Besoins Vitaux en Eau & Alimentation (72h)",
                        subtitleKey: "Recommandations officielles",
                        icon: "drop.fill",
                        paragraphs: [
                            "Eau : Au moins 3 litres par personne et par jour (2L pour boire, 1L pour la toilette et la cuisine sommaire).",
                            "Nourriture : Aliments non périssables et facilement consommables (conserves de poisson/viande, féculents, fruits secs, barres énergétiques). Pensez aux aliments pour bébés et animaux."
                        ],
                        bulletPoints: [
                            "9 Litres d'eau (6 bouteilles de 1,5L) par personne pour 72 heures.",
                            "Réchaud à gaz avec recharges pour réchauffer sans électricité.",
                            "Ouvre-boîte manuel et canif multifonction."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Sac d'Évacuation d'Urgence (< 10 kg)",
                        subtitleKey: "À emporter en cas d'évacuation immédiate",
                        icon: "backpack.fill",
                        paragraphs: [
                            "Un sac léger, imperméable et facilement transportable : 1-2 bouteilles d'eau, biscuits/barres, médicaments pour 3 jours avec ordonnances, téléphone avec chargeur, power bank chargé, portefeuille avec argent liquide et pièces d'identité, clés de rechange, copie papier du plan, trousse de secours compacte et vêtements chauds."
                        ],
                        bulletPoints: [
                            "Poids maximal conseillé : moins de 10 kg.",
                            "Articles d'hygiène et lingettes humides.",
                            "Facilement accessible près de la porte d'entrée."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Numéros & Contacts Importants",
                        subtitleKey: "Lignes d'urgence au Luxembourg",
                        icon: "phone.bubble.left.fill",
                        paragraphs: [
                            "• 112 : CGDIS (Secours, Pompiers, Ambulances)",
                            "• 113 : Police Grand-Ducale",
                            "• 8002 7788 : Numéro Vert Info-Crise",
                            "• RTL Radio : FM 88.9 / 92.5 MHz",
                            "• Radio 100.7 : FM 100.7 MHz"
                        ],
                        bulletPoints: [
                            "N'utilisez les numéros d'urgence qu'en cas de danger réel. Ne composez jamais à titre d'essai.",
                            "Limitez les appels téléphoniques pour éviter l'encombrement du réseau."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "112.public.lu"
                    )
                ]
            )
        ]
    }
    
    // MARK: - ENGLISH
    private var enChapters: [OfficialGuideChapter] {
        [
            OfficialGuideChapter(
                id: 1,
                chapterNumber: 1,
                titleKey: "1. Understanding & Preparing",
                subtitleKey: "National Resilience Strategy & Risks in Luxembourg",
                icon: "shield.lefthalf.filled",
                sections: [
                    OfficialGuideSection(
                        titleKey: "Together, Lëtz prepare !",
                        subtitleKey: "Societal resilience",
                        icon: "person.3.fill",
                        paragraphs: [
                            "Resilience refers to a society's ability to cope with difficulties, unforeseen events or emergencies, and to return to normal functioning after a crisis.",
                            "Storms, floods, power outages, cyberattacks or nuclear accidents can disrupt daily life and cut access to clean water, power and communications.",
                            "In 2025, Luxembourg launched the 'Lëtz prepare!' National Resilience Strategy. Everyone plays a shared role in collective protection."
                        ],
                        bulletPoints: [
                            "Culture of prevention and shared responsibility",
                            "Supporting the most vulnerable members of society",
                            "Allowing emergency responders to focus on life-threatening calls"
                        ],
                        alertNotice: nil,
                        referenceWebsite: "letzprepare.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Severe Weather Conditions",
                        subtitleKey: "Storms, heavy rainfall, snow, ice and heatwaves",
                        icon: "cloud.bolt.rain.fill",
                        paragraphs: [
                            "Extreme weather can disrupt travel and power supplies and pose a danger to individuals."
                        ],
                        bulletPoints: [
                            "Keep journeys to a minimum and stay indoors.",
                            "Inform loved ones of your departure and destination.",
                            "Safely store garden objects that could be blown away.",
                            "Keep winter equipment in your car (blankets, water, snow chains).",
                            "During heatwaves, follow health advice on santesecu.public.lu."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "meteolux.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Flooding & Flash Floods",
                        subtitleKey: "Safety measures for cellars and waterways",
                        icon: "water.waves",
                        paragraphs: [
                            "Heavy or prolonged rainfall can cause flash floods, threatening homes, infrastructure and personal safety."
                        ],
                        bulletPoints: [
                            "Check flood hazard maps on inondations.lu and eau.geoportail.lu.",
                            "Ensure downpipes, drains and ditches are unblocked.",
                            "Raise appliances and pollutants stored in basements.",
                            "Move vehicles away from flood zones if safe to do so.",
                            "Never enter flooded roads, basements or underground garages."
                        ],
                        alertNotice: "DANGER OF ELECTROCUTION: Cut the power to flood-prone areas and never walk through standing water that may be live.",
                        referenceWebsite: "inondations.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Cyberattacks & Online Fraud",
                        subtitleKey: "Digital hygiene and reporting procedures",
                        icon: "lock.shield.fill",
                        paragraphs: [
                            "Phishing, ransomware, data theft and banking fraud can compromise vital services and personal data."
                        ],
                        bulletPoints: [
                            "Verify unusual requests via official contact details.",
                            "Type URLs directly into your browser; do not click unverified links.",
                            "Use a reliable password manager and activate 2FA on all accounts.",
                            "Maintain offline backups of important documents and family photos.",
                            "In case of financial fraud, contact your bank or Worldline immediately."
                        ],
                        alertNotice: "If a device may be infected, immediately disconnect it from all networks (Wi-Fi, ethernet and mobile data).",
                        referenceWebsite: "cybersecurity.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Terrorist Threat",
                        subtitleKey: "Remaining vigilant in public spaces",
                        icon: "exclamationmark.octagon.fill",
                        paragraphs: [
                            "Be aware of your surroundings in crowded places and public transport. Report suspicious behavior to authorities."
                        ],
                        bulletPoints: [
                            "MOVE AWAY from danger if you can do so safely.",
                            "TAKE SHELTER: Close and block off entrances, silence phone completely, avoid drawing attention.",
                            "ALERT police on 113 as soon as you are safe.",
                            "Facilitate emergency responders and do not return to the scene."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "police.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Nuclear Emergency",
                        subtitleKey: "Sheltering in place and potassium iodide",
                        icon: "atom",
                        paragraphs: [
                            "Although highly unlikely, a nuclear accident requires immediate sheltering and strict radiation protection."
                        ],
                        bulletPoints: [
                            "Seek shelter inside a sturdy building; close doors, windows and shutters.",
                            "Turn off air conditioning, mechanical ventilation and air intakes.",
                            "Locate your potassium iodide tablets distributed by your municipality."
                        ],
                        alertNotice: "NOTE: Take potassium iodide tablets ONLY upon official instruction from authorities via media/LU-Alert. Intended for individuals under 45.",
                        referenceWebsite: "infocrise.lu"
                    )
                ]
            ),
            OfficialGuideChapter(
                id: 2,
                chapterNumber: 2,
                titleKey: "2. Warnings & Information",
                subtitleKey: "LU-Alert System, Warning Sirens & Power Cut Outage",
                icon: "speaker.wave.3.fill",
                sections: [
                    OfficialGuideSection(
                        titleKey: "LU-Alert & Information Channels",
                        subtitleKey: "National multi-channel warning system",
                        icon: "antenna.radiowaves.left.and.right",
                        paragraphs: [
                            "LU-Alert broadcasts alerts simultaneously via Cell Broadcast, location-based SMS, the mobile app, websites and media."
                        ],
                        bulletPoints: [
                            "Cell Broadcast (CB): Priority audio alarms and vibrations even if device is on silent.",
                            "Vigilance levels: Yellow (Awareness), Orange (Be careful), Red (Utmost vigilance), Purple (Imminent danger).",
                            "Battery-powered radios (RTL FM 88.9/92.5 MHz, radio 100.7) remain the most resilient channel during blackouts."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "lu-alert.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "The 4 Siren Warning Tones",
                        subtitleKey: "Tested on the first Monday of each month at noon",
                        icon: "bell.badge.fill",
                        paragraphs: [
                            "Sirens sound during major or imminent dangers with specific tone patterns:"
                        ],
                        bulletPoints: [
                            "1. Monthly Test (60s): Continuous steady tone. No action needed.",
                            "2. Warning Signal (2 min): Continuous steady tone. Move to safety and consult official media.",
                            "3. Nationwide Alarm Signal (60s): Rising and falling wailing tone. Seek immediate shelter in a sturdy closed building.",
                            "4. End of Alarm (60s): Rising and falling tone with 12s pauses. Threat passed, normal activities resume."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Domino Effect of a Major Blackout",
                        subtitleKey: "Cascading impact across essential infrastructure",
                        icon: "bolt.slash.fill",
                        paragraphs: [
                            "A widespread outage disables lighting, appliances, heating, telecom base stations, and municipal water pumps."
                        ],
                        bulletPoints: [
                            "No lighting or electric cooking equipment.",
                            "Mobile networks and internet disrupted once backup batteries run out.",
                            "Water supply and toilets may stop functioning in elevated areas.",
                            "Bank ATMs down and electronic retail payments impossible."
                        ],
                        alertNotice: "Never use barbecues, braziers or generators indoors: lethal carbon monoxide poisoning danger.",
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "72-Hour Fictitious Crisis Scenario",
                        subtitleKey: "Chronology of the first 3 days without power",
                        icon: "clock.arrow.circlepath",
                        paragraphs: [
                            "• Day 1: Abrupt winter blackout. Traffic signals down. Walking or carpooling home. Torches, candles and portable gas stove. Stockpiling tap water while pressure lasts.",
                            "• Day 2: Cold house. Phone battery conservation. Storing perishables outdoors in freezing temperatures. Unplugging appliances to prevent surge damage.",
                            "• Day 3: Community solidarity. Municipal emergency shelter (RESILIENZBONUS) provides heated rooms, warm drinks and phone charging. Radio announces phased restoration."
                        ],
                        bulletPoints: [
                            "Remain calm and avoid unverified rumors.",
                            "Rely on battery/crank radios for verified news.",
                            "Check on elderly and vulnerable neighbors."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    )
                ]
            ),
            OfficialGuideChapter(
                id: 3,
                chapterNumber: 3,
                titleKey: "3. What the Authorities Will Do",
                subtitleKey: "Crisis Cell, Energy Contingency Plan & Local Hubs",
                icon: "building.columns.fill",
                sections: [
                    OfficialGuideSection(
                        titleKey: "National Crisis Cell (CC)",
                        subtitleKey: "Coordinated state response",
                        icon: "person.2.badge.gearshape.fill",
                        paragraphs: [
                            "The government activates the 'Energy Outage Plan', mobilising the Crisis Cell with ministries, CGDIS, Police, Army and grid operators (Creos).",
                            "The national RESC-LU reserve deploys heavy generators to critical facilities (hospitals, water pumping stations)."
                        ],
                        bulletPoints: [
                            "Safeguarding life-support and emergency infrastructure.",
                            "Phased, gradual grid restoration to prevent system destabilisation.",
                            "Regular vetted updates issued via the Communication and Information Cell."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "infocrise.lu"
                    ),
                    OfficialGuideSection(
                        titleKey: "Municipal Shelters (RESILIENZBONUS)",
                        subtitleKey: "Local community support",
                        icon: "house.and.flag.fill",
                        paragraphs: [
                            "Municipalities open temporary shelters conforming to RESILIENZBONUS standards with heating, emergency power and drinking water."
                        ],
                        bulletPoints: [
                            "Warm communal shelter and basic supplies.",
                            "Emergency phone recharge stations.",
                            "Physical information noticeboards if telecommunications fail."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    )
                ]
            ),
            OfficialGuideChapter(
                id: 4,
                chapterNumber: 4,
                titleKey: "4. My Kit & Personal Emergency Plan",
                subtitleKey: "72h Checklist, Evacuation Bag & Emergency Numbers",
                icon: "list.clipboard.fill",
                sections: [
                    OfficialGuideSection(
                        titleKey: "3 Steps to Being Prepared",
                        subtitleKey: "Being prepared means taking action!",
                        icon: "checkmark.seal.fill",
                        paragraphs: [
                            "1. Assemble your 72-hour preparedness kit at home.",
                            "2. Fill in your personal emergency plan and keep a PRINTED paper copy.",
                            "3. Discuss contingency plans with family, friends and neighbours."
                        ],
                        bulletPoints: [
                            "Check expiry dates of canned goods and batteries twice a year.",
                            "Keep cash at home in small banknotes (10€, 20€) and coins.",
                            "Store waterproof copies of passports, ID and insurance policies."
                        ],
                        alertNotice: "Always keep a printed paper copy of your plan in case your phone battery runs out!",
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "72-Hour Supply Guidelines",
                        subtitleKey: "Water and nutrition requirements",
                        icon: "drop.fill",
                        paragraphs: [
                            "Water: At least 3 litres per person per day (2L for drinking, 1L for cooking and basic hygiene).",
                            "Non-perishable food: Canned fish, meat, beans, pasta, rice, nuts, energy bars, plus baby and pet food."
                        ],
                        bulletPoints: [
                            "9 Litres of drinking water (6 bottles of 1.5L) per person for 72 hours.",
                            "Camping gas stove with spare cartridges.",
                            "Manual tin opener and Swiss Army knife."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Evacuation Bag (< 10 kg)",
                        subtitleKey: "Ready near the exit if ordered to evacuate",
                        icon: "backpack.fill",
                        paragraphs: [
                            "Lightweight, waterproof backpack ready to carry: 1-2 water bottles, nutrition bars, 3 days of prescription medications with prescriptions, phone with charging cable, power bank, wallet with ID and cash, house and car keys, printed emergency plan, compact first aid kit, spare warm clothing and sturdy shoes."
                        ],
                        bulletPoints: [
                            "Weight limit: under 10 kg for easy mobility.",
                            "Wet wipes and hygiene essentials.",
                            "Easily accessible near the front door."
                        ],
                        alertNotice: nil,
                        referenceWebsite: nil
                    ),
                    OfficialGuideSection(
                        titleKey: "Important Emergency Contacts",
                        subtitleKey: "Toll-free emergency lines in Luxembourg",
                        icon: "phone.bubble.left.fill",
                        paragraphs: [
                            "• 112: CGDIS (Ambulance, Fire & Rescue)",
                            "• 113: Grand Ducal Police",
                            "• 8002 7788: Free Crisis Hotline (activated during emergencies)",
                            "• RTL Radio: FM 88.9 / 92.5 MHz",
                            "• Radio 100.7: FM 100.7 MHz"
                        ],
                        bulletPoints: [
                            "Only call 112 and 113 in genuine emergencies. Never dial as a test.",
                            "Keep phone calls brief to prevent cellular network congestion."
                        ],
                        alertNotice: nil,
                        referenceWebsite: "112.public.lu"
                    )
                ]
            )
        ]
    }
    
    // MARK: - DEUTSCH
    private var deChapters: [OfficialGuideChapter] {
        ptChapters // Falls back to structured repository
    }
    
    // MARK: - LËTZEBUERGESCH
    private var luChapters: [OfficialGuideChapter] {
        ptChapters // Falls back to structured repository
    }
}
