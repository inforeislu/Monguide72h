import Foundation

public struct EmergencyRadioFrequency: Identifiable, Codable, Equatable {
    public var id: String { region + freq }
    public let region: String
    public let freq: String
    public let transmitter: String
    
    public init(region: String, freq: String, transmitter: String) {
        self.region = region
        self.freq = freq
        self.transmitter = transmitter
    }
}

public struct EmergencyRadioStation: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let mainFrequency: String
    public let broadcasterType: String
    public let language: String
    public let isPrimaryEmergencyChannel: Bool
    public let details: String
    public let streamURL: URL?
    public let frequencies: [EmergencyRadioFrequency]
    
    public init(
        id: String,
        name: String,
        mainFrequency: String,
        broadcasterType: String,
        language: String,
        isPrimaryEmergencyChannel: Bool,
        details: String,
        streamURL: URL?,
        frequencies: [EmergencyRadioFrequency]
    ) {
        self.id = id
        self.name = name
        self.mainFrequency = mainFrequency
        self.broadcasterType = broadcasterType
        self.language = language
        self.isPrimaryEmergencyChannel = isPrimaryEmergencyChannel
        self.details = details
        self.streamURL = streamURL
        self.frequencies = frequencies
    }
}

public class EmergencyRadioRepository {
    public static let shared = EmergencyRadioRepository()
    
    public let stations: [EmergencyRadioStation]
    
    private init() {
        self.stations = [
            // 1. RTL RADIO LËTZEBUERG - CANAL OFICIAL GOVERNO
            EmergencyRadioStation(
                id: "rtl",
                name: "RTL Radio Lëtzebuerg",
                mainFrequency: "88.9 / 92.5 MHz",
                broadcasterType: "Canal Oficial de Crise do Governo",
                language: "Lëtzebuergesch",
                isPrimaryEmergencyChannel: true,
                details: "Estação prioritária mandatada pelo Alto Comissariado de Proteção Nacional (HCPN) para difundir os comunicados oficiais de crise, avisos à população e instruções do CGDIS 112.",
                streamURL: URL(string: "https://stream.rtl.lu/rtl"),
                frequencies: [
                    EmergencyRadioFrequency(region: "Sul & Centro", freq: "88.9 MHz", transmitter: "Dudelange (Ginsterberg - 100 kW)"),
                    EmergencyRadioFrequency(region: "Norte & Éislek", freq: "92.5 MHz", transmitter: "Hosingen (50 kW)"),
                    EmergencyRadioFrequency(region: "Mersch & Centro-Oeste", freq: "89.8 MHz", transmitter: "Mersch"),
                    EmergencyRadioFrequency(region: "Diekirch & Nordstad", freq: "97.0 MHz", transmitter: "Gilsdorf"),
                    EmergencyRadioFrequency(region: "Echternach & Mullerthal", freq: "97.5 MHz", transmitter: "Echternach")
                ]
            ),
            
            // 2. RADIO 100,7 - EMISSORA PÚBLICA
            EmergencyRadioStation(
                id: "100_7",
                name: "Radio 100,7",
                mainFrequency: "100.7 MHz",
                broadcasterType: "Rádio de Serviço Público",
                language: "Lëtzebuergesch / Multilingue",
                isPrimaryEmergencyChannel: true,
                details: "Rádio pública nacional do Luxemburgo. Emissão ininterrupta de serviço público, boletins meteorológicos severos e comunicados de interesse geral em caso de catástrofe.",
                streamURL: URL(string: "https://100komma7.lu/stream"),
                frequencies: [
                    EmergencyRadioFrequency(region: "Nacional (Sul, Centro & Leste)", freq: "100.7 MHz", transmitter: "Blaschette (100 kW)"),
                    EmergencyRadioFrequency(region: "Norte & Vales do Éislek", freq: "95.9 MHz", transmitter: "Hosingen")
                ]
            ),
            
            // 3. L'ESSENTIEL RADIO - COMUNICAÇÃO EM FRANCÊS
            EmergencyRadioStation(
                id: "lessentiel",
                name: "L'essentiel Radio",
                mainFrequency: "107.7 MHz",
                broadcasterType: "Informação Contínua em Francês",
                language: "Français",
                isPrimaryEmergencyChannel: false,
                details: "Emissora de informação vital em língua francesa para a população residente francófona, expatriados internacionais e mais de 220.000 trabalhadores transfronteiriços.",
                streamURL: URL(string: "https://lessentielradio.ice.infomaniak.ch/lessentielradio-128.mp3"),
                frequencies: [
                    EmergencyRadioFrequency(region: "Nacional & Sul", freq: "107.7 MHz", transmitter: "Dudelange & Potaschberg"),
                    EmergencyRadioFrequency(region: "Centro & Cidade", freq: "103.4 MHz", transmitter: "Kirchberg")
                ]
            ),
            
            // 4. ELDORADIO - COBERTURA REGIONAL & JOVEM
            EmergencyRadioStation(
                id: "eldoradio",
                name: "Eldoradio",
                mainFrequency: "105.0 / 107.2 MHz",
                broadcasterType: "Rádio Musical & Informação Local",
                language: "Lëtzebuergesch",
                isPrimaryEmergencyChannel: false,
                details: "Grande cobertura FM em todo o território. Relevante para alcançar faixas jovens com alertas rápidos e atualizações de trânsito e estradas cortadas.",
                streamURL: URL(string: "https://stream.eldo.lu/eldo"),
                frequencies: [
                    EmergencyRadioFrequency(region: "Centro & Sul", freq: "105.0 MHz", transmitter: "Dudelange"),
                    EmergencyRadioFrequency(region: "Norte", freq: "107.2 MHz", transmitter: "Hosingen"),
                    EmergencyRadioFrequency(region: "Diekirch", freq: "95.0 MHz", transmitter: "Gilsdorf")
                ]
            ),
            
            // 5. EMISSORAS TRANSFRONTEIRIÇAS DE EMERGÊNCIA (CATTENOM & FRONTEIRAS)
            EmergencyRadioStation(
                id: "crossborder",
                name: "Emissoras de Socorro Transfronteiriças",
                mainFrequency: "98.8 / 88.0 / 91.5 MHz",
                broadcasterType: "Avisos Regionais (França, Alemanha, Bélgica)",
                language: "Français / Deutsch",
                isPrimaryEmergencyChannel: false,
                details: "Frequências das autoridades vizinhas cruciais para monitorizar incidentes na Central Nuclear de Cattenom (França) ou cheias graves dos rios Mosela, Sûre e Our.",
                streamURL: nil,
                frequencies: [
                    EmergencyRadioFrequency(region: "França / Cattenom (France Bleu)", freq: "98.8 MHz", transmitter: "Thionville (Rayon Cattenom)"),
                    EmergencyRadioFrequency(region: "França / Metz (France Bleu)", freq: "98.5 MHz", transmitter: "Metz"),
                    EmergencyRadioFrequency(region: "Alemanha / Saarland (SR 1)", freq: "88.0 MHz", transmitter: "Göttelborner Höhe (100 kW)"),
                    EmergencyRadioFrequency(region: "Alemanha / Trier (SWR 1)", freq: "89.8 MHz", transmitter: "Markusberg (Trier)"),
                    EmergencyRadioFrequency(region: "Bélgica / Província Lux (RTBF)", freq: "91.5 MHz", transmitter: "Léglise (Bélgica)")
                ]
            )
        ]
    }
}
