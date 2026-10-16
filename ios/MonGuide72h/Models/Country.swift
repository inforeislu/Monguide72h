import Foundation

public struct CountryProfile: Identifiable, Hashable, Codable {
    public let id: String
    public let name: String
    public let flag: String
    public let universal112Label: String
    public let universal112Number: String
    public let secondaryLabel: String
    public let secondaryNumber: String
    public let infoPortalLabel: String
    public let infoPortalNumberOrURL: String
    public let radioStations: String
    public let alertSystem: String
    
    public static let allCountries: [CountryProfile] = [
        CountryProfile(
            id: "eu",
            name: "Union Européenne",
            flag: "🇪🇺",
            universal112Label: "112 UE SECOURS",
            universal112Number: "112",
            secondaryLabel: "116 000 ENFANTS",
            secondaryNumber: "116000",
            infoPortalLabel: "116 117 NON-URG",
            infoPortalNumberOrURL: "116117",
            radioStations: "Radios nationales publiques et réseau EBU / UER",
            alertSystem: "EU-Alert (Système européen d'alerte par diffusion cellulaire)"
        ),
        CountryProfile(
            id: "lu",
            name: "Luxembourg",
            flag: "🇱🇺",
            universal112Label: "112 CGDIS",
            universal112Number: "112",
            secondaryLabel: "113 POLICE",
            secondaryNumber: "113",
            infoPortalLabel: "INFO-CRISE",
            infoPortalNumberOrURL: "80027788",
            radioStations: "📻 RTL Radio (88.9 & 92.5 MHz) • 📻 Radio 100.7 (100.7 MHz)",
            alertSystem: "LU-Alert (Cell Broadcast, SMS & Sirènes nationales)"
        ),
        CountryProfile(
            id: "pt",
            name: "Portugal",
            flag: "🇵🇹",
            universal112Label: "112 EMERGÊNCIA",
            universal112Number: "112",
            secondaryLabel: "117 INCÊNDIOS",
            secondaryNumber: "117",
            infoPortalLabel: "SNS 24",
            infoPortalNumberOrURL: "808242424",
            radioStations: "📻 Antena 1 (RDP) • Frequências regionais de Proteção Civil",
            alertSystem: "Proteção Civil ANEPC (Avisos SMS & Sirenes municipais)"
        ),
        CountryProfile(
            id: "fr",
            name: "France",
            flag: "🇫🇷",
            universal112Label: "112 URGENCES",
            universal112Number: "112",
            secondaryLabel: "15 SAMU / 18 POMP",
            secondaryNumber: "15",
            infoPortalLabel: "17 POLICE",
            infoPortalNumberOrURL: "17",
            radioStations: "📻 France Bleu • 📻 France Info",
            alertSystem: "FR-Alert (Cell Broadcast & Sirènes SAIP le 1er mercredi du mois)"
        ),
        CountryProfile(
            id: "de",
            name: "Deutschland",
            flag: "🇩🇪",
            universal112Label: "112 NOTRUF",
            universal112Number: "112",
            secondaryLabel: "110 POLIZEI",
            secondaryNumber: "110",
            infoPortalLabel: "116 117 ARZT",
            infoPortalNumberOrURL: "116117",
            radioStations: "📻 Deutschlandfunk • Radios régionales ARD (WDR, SWR, BR)",
            alertSystem: "Cell Broadcast & BBK NINA / Sirenen (Warntag)"
        ),
        CountryProfile(
            id: "be",
            name: "Belgique / België",
            flag: "🇧🇪",
            universal112Label: "112 SECOURS",
            universal112Number: "112",
            secondaryLabel: "101 POLICE",
            secondaryNumber: "101",
            infoPortalLabel: "1733 MÉDECIN",
            infoPortalNumberOrURL: "1733",
            radioStations: "📻 RTBF La Première • 📻 VRT Radio 1",
            alertSystem: "BE-Alert (SMS, E-mail & Cell Broadcast)"
        ),
        CountryProfile(
            id: "es",
            name: "España",
            flag: "🇪🇸",
            universal112Label: "112 EMERGENCIAS",
            universal112Number: "112",
            secondaryLabel: "091 POLICÍA",
            secondaryNumber: "091",
            infoPortalLabel: "061 SALUD",
            infoPortalNumberOrURL: "061",
            radioStations: "📻 Radio Nacional de España (RNE 1 / Radio 5)",
            alertSystem: "ES-Alert (Sistema Nacional de Protección Civil)"
        ),
        CountryProfile(
            id: "it",
            name: "Italia",
            flag: "🇮🇹",
            universal112Label: "112 EMERGENZA",
            universal112Number: "112",
            secondaryLabel: "115 VIGILI FUOCO",
            secondaryNumber: "115",
            infoPortalLabel: "118 SANITARIA",
            infoPortalNumberOrURL: "118",
            radioStations: "📻 Rai Radio 1 (Informazione e Protezione Civile)",
            alertSystem: "IT-Alert (Dipartimento della Protezione Civile)"
        ),
        CountryProfile(
            id: "nl",
            name: "Nederland",
            flag: "🇳🇱",
            universal112Label: "112 ALARM",
            universal112Number: "112",
            secondaryLabel: "0900-8844 POL",
            secondaryNumber: "09008844",
            infoPortalLabel: "NL-ALERT",
            infoPortalNumberOrURL: "112",
            radioStations: "📻 NPO Radio 1 (Rampenzenders)",
            alertSystem: "NL-Alert & Sirenes (Eerste maandag van de maand)"
        ),
        CountryProfile(
            id: "pl",
            name: "Polska",
            flag: "🇵🇱",
            universal112Label: "112 RATUNKOWY",
            universal112Number: "112",
            secondaryLabel: "998 STRAŻ",
            secondaryNumber: "998",
            infoPortalLabel: "997 POLICJA",
            infoPortalNumberOrURL: "997",
            radioStations: "📻 Polskie Radio Program 1 (Jedynka)",
            alertSystem: "Alert RCB (Rządowe Centrum Bezpieczeństwa)"
        ),
        CountryProfile(
            id: "se",
            name: "Sverige",
            flag: "🇸🇪",
            universal112Label: "112 NÖDSITUATION",
            universal112Number: "112",
            secondaryLabel: "114 14 POLISEN",
            secondaryNumber: "11414",
            infoPortalLabel: "113 13 KRISINFO",
            infoPortalNumberOrURL: "11313",
            radioStations: "📻 Sveriges Radio P4 (Beredskapskanal)",
            alertSystem: "VMA - Viktigt meddelande till allmänheten & Hesa Fredrik"
        ),
        CountryProfile(
            id: "fi",
            name: "Suomi",
            flag: "🇫🇮",
            universal112Label: "112 HÄTÄNUMERO",
            universal112Number: "112",
            secondaryLabel: "116 117 PÄIVYSTYS",
            secondaryNumber: "116117",
            infoPortalLabel: "112 SUOMI",
            infoPortalNumberOrURL: "112",
            radioStations: "📻 Yle Radio Suomi (Virallinen hätätiedotuskanava)",
            alertSystem: "112 Suomi -mobiilisovellus & Vaaratiedotteet"
        ),
        CountryProfile(
            id: "at",
            name: "Österreich",
            flag: "🇦🇹",
            universal112Label: "112 EURO-NOTRUF",
            universal112Number: "112",
            secondaryLabel: "122 FEUERWEHR",
            secondaryNumber: "122",
            infoPortalLabel: "133 POLIZEI",
            infoPortalNumberOrURL: "133",
            radioStations: "📻 Ö1 / Hitradio Ö3 (ORF Notfallradio)",
            alertSystem: "AT-Alert & Bundesweite Zivilschutz-Sirenensignale"
        ),
        CountryProfile(
            id: "ie",
            name: "Ireland",
            flag: "🇮🇪",
            universal112Label: "112 / 999 SOS",
            universal112Number: "112",
            secondaryLabel: "GARDAÍ POLICE",
            secondaryNumber: "999",
            infoPortalLabel: "HSE HEALTH",
            infoPortalNumberOrURL: "112",
            radioStations: "📻 RTÉ Radio 1 (National Emergency Broadcast)",
            alertSystem: "Civil Defence Ireland & National Emergency Alerts"
        ),
        CountryProfile(
            id: "gr",
            name: "Ελλάδα",
            flag: "🇬🇷",
            universal112Label: "112 ΕΚΤΑΚΤΗ ΑΝΑΓΚΗ",
            universal112Number: "112",
            secondaryLabel: "199 ΠΥΡΟΣΒΕΣΤΙΚΗ",
            secondaryNumber: "199",
            infoPortalLabel: "100 ΑΣΤΥΝΟΜΙΑ",
            infoPortalNumberOrURL: "100",
            radioStations: "📻 ΕΡΑ 1 (Πρώτο Πρόγραμμα) • ΕΡΤ",
            alertSystem: "112 Greece (Ευρωπαϊκός Αριθμός Έκτακτης Ανάγκης - SMS/Cell Broadcast)"
        )
    ]
    
    public static var defaultCountry: CountryProfile {
        return allCountries.first(where: { $0.id == "eu" }) ?? allCountries[0]
    }
}

public class CountryManager: ObservableObject {
    public static let shared = CountryManager()
    
    @Published public var currentCountry: CountryProfile {
        didSet {
            UserDefaults.standard.set(currentCountry.id, forKey: "selected_country_id")
        }
    }
    
    private init() {
        let savedId = UserDefaults.standard.string(forKey: "selected_country_id") ?? "eu"
        self.currentCountry = CountryProfile.allCountries.first(where: { $0.id == savedId }) ?? CountryProfile.defaultCountry
    }
    
    public func selectCountry(_ country: CountryProfile) {
        self.currentCountry = country
    }
}
