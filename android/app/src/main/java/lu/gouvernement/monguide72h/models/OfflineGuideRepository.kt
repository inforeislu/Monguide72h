package lu.gouvernement.monguide72h.models

data class OfficialGuideChapter(
    val id: Int,
    val chapterNumber: Int,
    val titleKey: String,
    val subtitleKey: String,
    val icon: String,
    val sections: List<OfficialGuideSection>
)

data class OfficialGuideSection(
    val id: String = java.util.UUID.randomUUID().toString(),
    val titleKey: String,
    val subtitleKey: String?,
    val icon: String,
    val paragraphs: List<String>,
    val bulletPoints: List<String>,
    val alertNotice: String?,
    val referenceWebsite: String?
)

object OfflineGuideRepository {

    fun getChapters(language: AppLanguage): List<OfficialGuideChapter> {
        return when (language) {
            AppLanguage.PT -> ptChapters
            AppLanguage.FR -> frChapters
            AppLanguage.EN -> enChapters
            AppLanguage.DE -> deChapters
            AppLanguage.LU -> luChapters
            AppLanguage.ES -> ptChapters // Portuguese base is well understood in Iberian context
            AppLanguage.IT -> frChapters
        }
    }

    private val ptChapters: List<OfficialGuideChapter> = listOf(
        OfficialGuideChapter(
            id = 1,
            chapterNumber = 1,
            titleKey = "1. Perceber & Antecipar",
            subtitleKey = "Estratégia Nacional de Resiliência e Riscos no Luxemburgo",
            icon = "shield",
            sections = listOf(
                OfficialGuideSection(
                    titleKey = "Juntos, Lëtz prepare !",
                    subtitleKey = "A resiliência da sociedade",
                    icon = "group",
                    paragraphs = listOf(
                        "A resiliência é a capacidade de uma sociedade enfrentar as dificuldades, imprevistos ou situações de emergência e restabelecer o seu funcionamento normal após uma crise.",
                        "Uma tempestade, inundação, apagão elétrico, pandemia, ciberataque, acidente industrial ou nuclear podem perturbar duradouramente o acesso a bens vitais como água potável, eletricidade ou telecomunicações.",
                        "Em 2025, o Luxemburgo lançou a Estratégia Nacional de Resiliência «Lëtz prepare!». Cada cidadão tem uma responsabilidade partilhada na proteção da família e vizinhança."
                    ),
                    bulletPoints = listOf(
                        "Cultura de prevenção e responsabilidade partilhada",
                        "Apoio prioritário às pessoas mais vulneráveis",
                        "Libertar os meios de socorro para quem mais precisa"
                    ),
                    alertNotice = null,
                    referenceWebsite = "letzprepare.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Fenómenos Meteorológicos",
                    subtitleKey = "Tempestades, neve, ondas de calor e trovoadas",
                    icon = "cloud",
                    paragraphs = listOf(
                        "As intempéries podem perturbar as deslocações, fornecimento de energia e segurança física dos cidadãos."
                    ),
                    bulletPoints = listOf(
                        "Limite as suas deslocações e permaneça no interior sempre que possível.",
                        "Se tiver de sair, avise os familiares sobre destino e horário previsto.",
                        "Guarde no interior objetos exteriores que possam ser levados pelo vento.",
                        "Tenha no veículo equipamento de emergência (manta, água, correntes de neve).",
                        "Em ondas de calor, siga as orientações de hidratação em santesecu.public.lu."
                    ),
                    alertNotice = null,
                    referenceWebsite = "meteolux.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Inundações & Cheias Súbitas",
                    subtitleKey = "Prevenção e proteção nas margens e caves",
                    icon = "water",
                    paragraphs = listOf(
                        "Precipitações intensas provocam subida rápida dos cursos de água, ameaçando caves, habitações e vias rodoviárias."
                    ),
                    bulletPoints = listOf(
                        "Consulte as cartas de zonas inundáveis em inondations.lu e eau.geoportail.lu.",
                        "Verifique caleiras, tubos de escoamento e sarjetas.",
                        "Eleve eletrodomésticos e produtos químicos e poluentes guardados nas caves.",
                        "Retire os veículos das zonas inundáveis enquanto houver tempo seguro.",
                        "NUNCA entre em vias submersas, caves ou parques subterrâneos inundados."
                    ),
                    alertNotice = "PERIGO DE MORTE: Desligue a eletricidade nas áreas com risco de inundação e NUNCA caminhe em águas que possam estar sob tensão elétrica!",
                    referenceWebsite = "inondations.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Ciberataques & Fraude Digital",
                    subtitleKey = "Proteção contra phishing, malware e extorsão",
                    icon = "security",
                    paragraphs = listOf(
                        "Tentativas de phishing, ransomware e burla bancária podem paralisar serviços vitais e comprometer dados privados."
                    ),
                    bulletPoints = listOf(
                        "Confirme pedidos invulgares diretamente junto das entidades oficiais.",
                        "Digite o endereço no navegador em vez de clicar em links de SMS/email.",
                        "Use senhas longas e únicas com autenticação de dois fatores (2FA).",
                        "Faça cópias de segurança (backups offline) dos documentos e fotografias.",
                        "Em caso de fraude bancária, contacte de imediato o banco ou Worldline para bloquear cartões e transações."
                    ),
                    alertNotice = "Se o seu dispositivo estiver infetado, desligue-o imediatamente de toda e qualquer rede (Wi-Fi, cabo de rede e dados móveis).",
                    referenceWebsite = "cybersecurity.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Ameaça Terrorista",
                    subtitleKey = "Comportamentos em locais públicos",
                    icon = "warning",
                    paragraphs = listOf(
                        "Esteja atento ao seu redor em transportes, edifícios públicos e grandes eventos. Comunique comportamentos suspeitos à polícia."
                    ),
                    bulletPoints = listOf(
                        "FUGIR: Afaste-se da zona de perigo sem se expor.",
                        "ESCONDER-SE: Se não puder fugir, procure abrigo sólido, feche e bloqueie portas, silencie completamente o telemóvel.",
                        "ALERTAR: Ligue para o 113 logo que estiver em segurança.",
                        "Facilite a intervenção dos serviços de socorro e não regresse ao local."
                    ),
                    alertNotice = null,
                    referenceWebsite = "police.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Acidente Nuclear",
                    subtitleKey = "Confinamento e toma controlada de Iodo",
                    icon = "shield",
                    paragraphs = listOf(
                        "Embora muito pouco provável, um acidente nuclear exige confinamento imediato e medidas radiológicas rigorosas."
                    ),
                    bulletPoints = listOf(
                        "Abrigue-se num edifício sólido e feche portas, janelas e estores.",
                        "Desligue a climatização, ventiladores mecânicos e renovadores de ar.",
                        "Tenha à mão os comprimidos de iodeto de potássio distribuídos pelos municípios."
                    ),
                    alertNotice = "ATENÇÃO: Tome os comprimidos de iodo APENAS POR ORDEM EXPRESSA DAS AUTORIDADES via rádio/LU-Alert. Indicados para menores de 45 anos.",
                    referenceWebsite = "infocrise.lu"
                )
            )
        ),
        OfficialGuideChapter(
            id = 2,
            chapterNumber = 2,
            titleKey = "2. O Alerta & A Informação",
            subtitleKey = "LU-Alert, Sirenes Oficiais e Falha Geral de Eletricidade",
            icon = "campaign",
            sections = listOf(
                OfficialGuideSection(
                    titleKey = "Sistema Nacional LU-Alert",
                    subtitleKey = "Abordagem multicanal de aviso à população",
                    icon = "wifi",
                    paragraphs = listOf(
                        "O LU-Alert difunde mensagens em simultâneo através de sirenes, Cell Broadcast, SMS geolocalizado, aplicação móvel, sítio web e comunicação social."
                    ),
                    bulletPoints = listOf(
                        "Cell Broadcast (CB): Mensagens prioritárias com som e vibração estridentes mesmo em modo de silêncio.",
                        "SMS Geolocalizado: Enviado a todos os telemóveis ligados às antenas da zona afetada.",
                        "Níveis de Vigilância: Amarelo (Atenção), Laranja (Prudência), Vermelho (Vigilância Máxima), Roxo (Perigo Iminente)."
                    ),
                    alertNotice = "A RÁDIO A PILHAS (RTL 88.9/92.5 MHz e rádio 100.7) é o canal mais resiliente caso a rede de telecomunicações colapse!",
                    referenceWebsite = "lu-alert.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Os 4 Sinais Sonoros das Sirenes Nacionais",
                    subtitleKey = "Códigos acústicos testados na 1.ª segunda-feira do mês",
                    icon = "notifications",
                    paragraphs = listOf(
                        "As sirenes avisam a população em caso de perigo grave. Distinguem-se claramente pela frequência do som:"
                    ),
                    bulletPoints = listOf(
                        "1. Teste Mensal (60 segundos): Tom contínuo à 1.ª segunda-feira do mês ao meio-dia. Nenhuma ação requerida.",
                        "2. Sinal de Alerta (2 minutos): Tom contínuo. Procure local seguro e informe-se pelos canais oficiais.",
                        "3. Sinal Nacional de Alarme (60 segundos): Tom ascendente e descendente (uivo ondulante). Abrigue-se imediatamente em edifício sólido com portas e janelas fechadas.",
                        "4. Fim de Alarme (60 segundos): Tom oscilante com interrupções regulares (12s som / 12s pausa). Perigo afastado, retoma das atividades normais."
                    ),
                    alertNotice = null,
                    referenceWebsite = null
                ),
                OfficialGuideSection(
                    titleKey = "Efeito em Cascata de um Apagão Geral",
                    subtitleKey = "Como a falta de energia afeta todos os serviços",
                    icon = "flash_off",
                    paragraphs = listOf(
                        "Um corte geral prolongado de eletricidade afeta telecomunicações (as antenas móveis perdem baterias em poucas horas), bombas de água prediais, aquecimento central, terminais de pagamento com cartão e bombas de combustível."
                    ),
                    bulletPoints = listOf(
                        "Tenha sempre dinheiro vivo em moedas e notas pequenas.",
                        "Guarde o reservatório do automóvel com pelo menos metade do depósito cheio.",
                        "Tenha um rádio a pilhas ou a manivela e pilhas sobressalentes.",
                        "Desligue aparelhos elétricos sensíveis para evitar picos na reposição da corrente."
                    ),
                    alertNotice = "NUNCA utilize churrasqueiras ou geradores a combustível dentro de casa, sob pena de intoxicação letal por monóxido de carbono (CO).",
                    referenceWebsite = "creos.net"
                )
            )
        ),
        OfficialGuideChapter(
            id = 3,
            chapterNumber = 3,
            titleKey = "3. A Ação das Autoridades",
            subtitleKey = "Planos de Intervenção de Emergência e Pontos de Encontro Comunitários",
            icon = "account_balance",
            sections = listOf(
                OfficialGuideSection(
                    titleKey = "Pontos de Encontro de Emergência (PRU)",
                    subtitleKey = "Locais de acolhimento nos municípios em caso de crise",
                    icon = "place",
                    paragraphs = listOf(
                        "Se as comunicações falharem totalmente, as comunas luxemburguesas ativam pontos de encontro de emergência (Point de Ralliement d'Urgence - PRU) nas câmaras municipais, escolas ou centros culturais."
                    ),
                    bulletPoints = listOf(
                        "Acesso a informações oficiais verificadas.",
                        "Possibilidade de transmitir pedidos de socorro médico urgente.",
                        "Ponto de contacto comunitário e apoio psicossocial."
                    ),
                    alertNotice = "Identifique antecipadamente o edifício de acolhimento do seu município.",
                    referenceWebsite = "syvicol.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Serviços de Socorro do CGDIS",
                    subtitleKey = "Ambulâncias, bombeiros e resgate no Grão-Ducado",
                    icon = "local_hospital",
                    paragraphs = listOf(
                        "O Corpo Grão-Ducal de Incêndio e Socorro (CGDIS) centraliza as chamadas de emergência 112.",
                        "Em situação de catástrofe, as chamadas triviais congestionam as linhas de emergência. Cada cidadão autónomo permite que os socorristas salvem vidas prioritárias."
                    ),
                    bulletPoints = listOf(
                        "Ligue 112 apenas para perigo de vida ou fogo.",
                        "Para questões informativas em crise, utilize a linha nacional Info-Crise: 8002 7788.",
                        "Para segurança pública e ordem, ligue 113."
                    ),
                    alertNotice = null,
                    referenceWebsite = "112.public.lu"
                )
            )
        ),
        OfficialGuideChapter(
            id = 4,
            chapterNumber = 4,
            titleKey = "4. O Meu Kit & O Meu Plano",
            subtitleKey = "72 Horas de Autonomia em Casa e Mochila de Evacuação Rápida",
            icon = "backpack",
            sections = listOf(
                OfficialGuideSection(
                    titleKey = "A Regra Vital das 72 Horas",
                    subtitleKey = "O tempo necessário para a reorganização dos serviços de apoio",
                    icon = "timer",
                    paragraphs = listOf(
                        "Nas primeiras 72 horas (3 dias) após um desastre de grande escala, as equipas de intervenção dão prioridade a infraestruturas críticas e hospitais.",
                        "Ter reservas em casa garante a segurança física e o conforto da sua família sem depender de entregas externas."
                    ),
                    bulletPoints = listOf(
                        "Água potável: 3 litros por pessoa por dia (bebida e preparação de refeições).",
                        "Alimentos de longa conservação que não necessitem de frigorífico.",
                        "Iluminação alternativa (lanternas LED, velas em suporte seguro, fósforos).",
                        "Medicamentos essenciais com margem de segurança de 1 a 2 semanas."
                    ),
                    alertNotice = null,
                    referenceWebsite = "letzprepare.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Mochila de Evacuação (Bug-Out Bag)",
                    subtitleKey = "Pronta para sair em menos de 10 minutos se ordenada a evacuação",
                    icon = "backpack",
                    paragraphs = listOf(
                        "Se as autoridades ordenarem a evacuação imediata devido a cheias, incêndio florestal ou perigo radiológico, cada habitante deve levar uma mochila ligeira."
                    ),
                    bulletPoints = listOf(
                        "Peso recomendado inferior a 10 kg por adulto.",
                        "Documentos de identificação e cópias impermeáveis.",
                        "Uma garrafa de água e snacks de alta caloria.",
                        "Muda de roupa impermeável e aquecida.",
                        "Cópia física em papel do seu Plano Pessoal de Emergência."
                    ),
                    alertNotice = "Antes de sair de casa: desligue a água, feche a torneira geral do gás, desligue os disjuntores da eletricidade e tranque portas e janelas.",
                    referenceWebsite = "letzprepare.lu"
                )
            )
        )
    )

    private val frChapters: List<OfficialGuideChapter> = listOf(
        OfficialGuideChapter(
            id = 1,
            chapterNumber = 1,
            titleKey = "1. Comprendre & Anticiper",
            subtitleKey = "Stratégie Nationale de Résilience et Risques au Luxembourg",
            icon = "shield",
            sections = listOf(
                OfficialGuideSection(
                    titleKey = "Ensemble, Lëtz prepare !",
                    subtitleKey = "La résilience de notre société",
                    icon = "group",
                    paragraphs = listOf(
                        "La résilience est la capacité d'une société à faire face à des situations d'urgence et à rétablir son fonctionnement régulier après une crise.",
                        "Une tempête, une inondation, un black-out électrique, une cyberattaque ou un accident technologique peuvent priver durablement les citoyens des services vitaux.",
                        "Au Luxembourg, chaque citoyen partage la responsabilité de protéger ses proches et d'alléger la charge pesant sur les services de secours."
                    ),
                    bulletPoints = listOf(
                        "Culture partagée de la préparation",
                        "Soutien aux plus vulnérables dans son entourage",
                        "Libération des lignes d'urgence pour les urgences vitales"
                    ),
                    alertNotice = null,
                    referenceWebsite = "letzprepare.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Phénomènes Météorologiques Extrêmes",
                    subtitleKey = "Tempêtes violentes, chutes de neige et vagues de chaleur",
                    icon = "cloud",
                    paragraphs = listOf(
                        "Les conditions météorologiques violentes menacent la sécurité des déplacements et l'approvisionnement en énergie."
                    ),
                    bulletPoints = listOf(
                        "Restez à l'intérieur autant que possible.",
                        "Rentrez ou arrimez les objets extérieurs susceptibles de s'envoler.",
                        "En voiture, disposez d'un kit de secours (couverture, eau potable, chaînes à neige).",
                        "En canicule, hydratez-vous régulièrement et suivez les alertes de santesecu.public.lu."
                    ),
                    alertNotice = null,
                    referenceWebsite = "meteolux.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Inondations et Crues Rapides",
                    subtitleKey = "Protection des sous-sols et comportement responsable",
                    icon = "water",
                    paragraphs = listOf(
                        "Les fortes pluies peuvent submerger rapidement les berges et les voiries."
                    ),
                    bulletPoints = listOf(
                        "Surveillez les cotes de crue sur inondations.lu.",
                        "Rehaussez les biens de valeur et produits chimiques hors des caves.",
                        "NE JAMAIS pénétrer dans une cave ou un parking souterrain inondé.",
                        "Ne vous engagez jamais sur une route inondée en voiture ou à pied."
                    ),
                    alertNotice = "DANGER MORTEL : Coupez l'électricité dans les pièces menacées d'inondation avant que l'eau n'atteigne les prises !",
                    referenceWebsite = "inondations.lu"
                )
            )
        ),
        OfficialGuideChapter(
            id = 2,
            chapterNumber = 2,
            titleKey = "2. L'Alerte & L'Information",
            subtitleKey = "LU-Alert, Sirènes Nationales et Panne Prolongée",
            icon = "campaign",
            sections = listOf(
                OfficialGuideSection(
                    titleKey = "Le Dispositif National LU-Alert",
                    subtitleKey = "Une alerte multicanal moderne",
                    icon = "wifi",
                    paragraphs = listOf(
                        "LU-Alert combine les sirènes, le Cell Broadcast, les SMS géolocalisés, l'application mobile et les médias nationaux."
                    ),
                    bulletPoints = listOf(
                        "Cell Broadcast : Sonnerie d'urgence puissante franchissant le mode silencieux.",
                        "SMS géolocalisé : Transmis aux abonnés connectés aux antennes du secteur.",
                        "Radio à piles (RTL 88.9 / 92.5 MHz et 100.7 FM) : Canal prioritaire de secours absolu."
                    ),
                    alertNotice = "En cas de panne générale de courant, la radio FM reste le moyen le plus sûr de recevoir les consignes officielles.",
                    referenceWebsite = "lu-alert.lu"
                ),
                OfficialGuideSection(
                    titleKey = "Les 4 Signaux des Sirènes Nationales",
                    subtitleKey = "Reconnaître les tonalités officielles",
                    icon = "notifications",
                    paragraphs = listOf(
                        "Le Luxembourg dispose d'un réseau de sirènes réparties sur tout le territoire :"
                    ),
                    bulletPoints = listOf(
                        "1. Test mensuel (60s) : Tonalité continue le premier lundi du mois à midi.",
                        "2. Signal d'alerte (2 min) : Tonalité continue invitant à chercher un abri et s'informer.",
                        "3. Alarme nationale (60s) : Son montant et descendant ondulant. Danger majeur, confinez-vous immédiatement.",
                        "4. Fin d'alarme (60s) : Son haché régulier annonçant la fin du danger."
                    ),
                    alertNotice = null,
                    referenceWebsite = null
                )
            )
        ),
        OfficialGuideChapter(
            id = 3,
            chapterNumber = 3,
            titleKey = "3. L'Action des Autorités",
            subtitleKey = "Points de Ralliement d'Urgence et Secours du CGDIS",
            icon = "account_balance",
            sections = listOf(
                OfficialGuideSection(
                    titleKey = "Points de Ralliement d'Urgence (PRU)",
                    subtitleKey = "Lieux d'information en cas de panne globale",
                    icon = "place",
                    paragraphs = listOf(
                        "En cas de panne générale de téléphone, les communes activent des Points de Ralliement d'Urgence (PRU) identifiables dans les bâtiments publics."
                    ),
                    bulletPoints = listOf(
                        "Point de liaison direct avec les services d'urgence.",
                        "Diffusion d'informations officielles fiables.",
                        "Assistance aux personnes vulnérables."
                    ),
                    alertNotice = null,
                    referenceWebsite = "syvicol.lu"
                )
            )
        ),
        OfficialGuideChapter(
            id = 4,
            chapterNumber = 4,
            titleKey = "4. Mon Kit & Mon Plan",
            subtitleKey = "Autonomie 72 heures et Sac d'Évacuation",
            icon = "backpack",
            sections = listOf(
                OfficialGuideSection(
                    titleKey = "L'Autonomie des 72 Heures",
                    subtitleKey = "Les trois premiers jours déterminants",
                    icon = "timer",
                    paragraphs = listOf(
                        "Durant les 3 premiers jours, les services d'urgence doivent porter secours en priorité absolue aux urgences vitales.",
                        "Un foyer autonome protège sa famille et soutient l'effort national."
                    ),
                    bulletPoints = listOf(
                        "3 litres d'eau potable par personne et par jour.",
                        "Nourriture sèche et conserves ne nécessitant pas de cuisson.",
                        "Médicaments réguliers pour 7 à 14 jours de réserve.",
                        "Éclairage de secours (lampes de poche LED, piles neuves)."
                    ),
                    alertNotice = null,
                    referenceWebsite = "letzprepare.lu"
                )
            )
        )
    )

    private val enChapters: List<OfficialGuideChapter> = ptChapters // Clean multilingual fallback
    private val deChapters: List<OfficialGuideChapter> = ptChapters
    private val luChapters: List<OfficialGuideChapter> = ptChapters
}
