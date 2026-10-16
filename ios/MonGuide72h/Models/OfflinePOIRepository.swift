import Foundation
import CoreLocation

public class OfflinePOIRepository {
    public static let shared = OfflinePOIRepository()
    
    public let allPoints: [EmergencyPOI]
    
    private init() {
        self.allPoints = [
            // MARK: - 1. HOSPITAIS E CENTROS DE URGÊNCIA (URGENCES 24/24)
            EmergencyPOI(
                name: "CHL - Centre Hospitalier de Luxembourg",
                category: .hospital,
                address: "4 Rue Ernest Barblé",
                commune: "Luxembourg-Ville",
                postalCode: "L-1210",
                latitude: 49.6186,
                longitude: 6.1017,
                phone: "+352 4411 11",
                openingHours: "24h/24 - Urgences Adultes & Traumatologie",
                emergencyServices: ["Service d'Urgences 24h", "Héliport SAMU", "Soins Intensifs", "Polyclinique"],
                notes: "Hôpital de référence national. Équipe SAMU Luxembourg 1."
            ),
            EmergencyPOI(
                name: "CHL KannerKlinik (Urgences Pédiatriques)",
                category: .hospital,
                address: "4 Rue Ernest Barblé",
                commune: "Luxembourg-Ville",
                postalCode: "L-1210",
                latitude: 49.6190,
                longitude: 6.1022,
                phone: "+352 4411 61",
                openingHours: "24h/24 - Urgences Enfants et Bébés",
                emergencyServices: ["Urgences Pédiatriques 24h", "Réanimation Pédiatrique", "Maternité Grande-Duchesse Charlotte"],
                notes: "Centre pédiatrique unique du Luxembourg avec urgences enfants."
            ),
            EmergencyPOI(
                name: "HRS - Hôpital Kirchberg",
                category: .hospital,
                address: "9 Rue Edward Steichen",
                commune: "Luxembourg-Kirchberg",
                postalCode: "L-2540",
                latitude: 49.6334,
                longitude: 6.1772,
                phone: "+352 2468 1",
                openingHours: "24h/24 - Urgences Médico-Chirurgicales",
                emergencyServices: ["Service d'Urgences 24h", "Imagerie d'urgence / Scanner", "Cardiologie Interventionnelle"],
                notes: "Hôpitaux Robert Schuman. Plateau médico-technique moderne."
            ),
            EmergencyPOI(
                name: "HRS - ZithaKlinik",
                category: .hospital,
                address: "20-40 Rue Sainte-Zithe",
                commune: "Luxembourg-Gare",
                postalCode: "L-2763",
                latitude: 49.6019,
                longitude: 6.1287,
                phone: "+352 2888 1",
                openingHours: "8h00 - 20h00 (Urgences & Clinique du Jour)",
                emergencyServices: ["Clinique Médicale", "Oncologie", "Chirurgie"],
                notes: "Groupe HRS. Proximité immédiate de la Gare Centrale de Luxembourg."
            ),
            EmergencyPOI(
                name: "CHEM - Centre Hospitalier Emile Mayrisch",
                category: .hospital,
                address: "Rue Emile Mayrisch",
                commune: "Esch-sur-Alzette",
                postalCode: "L-4240",
                latitude: 49.4977,
                longitude: 5.9798,
                phone: "+352 5711 1",
                openingHours: "24h/24 - Pôle Urgences Sud",
                emergencyServices: ["Service d'Urgences Sud 24h", "Base SAMU Sud", "Réanimation", "Centre Brûlés"],
                notes: "Principal hôpital du sud du pays. Base d'intervention SAMU."
            ),
            EmergencyPOI(
                name: "CHDN - Centre Hospitalier du Nord (Ettelbruck)",
                category: .hospital,
                address: "120 Avenue Lucien Salentiny",
                commune: "Ettelbruck",
                postalCode: "L-9080",
                latitude: 49.8519,
                longitude: 6.0967,
                phone: "+352 8166 1",
                openingHours: "24h/24 - Urgences Nord",
                emergencyServices: ["Service d'Urgences Nord 24h", "Base SAMU Nord", "Chirurgie d'Urgence"],
                notes: "Hôpital central pour tout le nord du Luxembourg."
            ),
            EmergencyPOI(
                name: "CHDN - Clinique Saint-Louis (Wiltz)",
                category: .hospital,
                address: "10 Rue Grande-Duchesse Charlotte",
                commune: "Wiltz",
                postalCode: "L-9515",
                latitude: 49.9678,
                longitude: 5.9325,
                phone: "+352 8166 1",
                openingHours: "8h00 - 18h00 (Soins Médicaux Sans Rendez-vous)",
                emergencyServices: ["Consultations d'urgence diurnes", "Centre de Réhabilitation"],
                notes: "Antenne Nord-Ouest du CHDN."
            ),
            
            // MARK: - 2. CENTROS DE SOCORRO E BOMBEIROS CGDIS (CIS)
            EmergencyPOI(
                name: "CNIS - Centre National d'Incendie et de Secours",
                category: .cgdis,
                address: "3 Boulevard de Kockelscheuer",
                commune: "Luxembourg-Gasperich",
                postalCode: "L-1821",
                latitude: 49.5847,
                longitude: 6.1158,
                phone: "+352 49771 1",
                openingHours: "24h/24 - Quartier Général CGDIS & CSU 112",
                emergencyServices: ["Centrale des Secours 112", "Base Spécialisée NRBC", "Groupe de Reconnaissance", "GSP Psychologique"],
                notes: "Quartier général opérationnel national des services de secours du Luxembourg."
            ),
            EmergencyPOI(
                name: "CIS Esch-sur-Alzette (CGDIS)",
                category: .cgdis,
                address: "Boulevard Aloyse Meyer",
                commune: "Esch-sur-Alzette",
                postalCode: "L-4023",
                latitude: 49.5058,
                longitude: 5.9789,
                phone: "+352 49771 4000",
                openingHours: "24h/24 - Centre d'Incendie et de Secours",
                emergencyServices: ["Ambulances SAMU", "Véhicules Incendie et Désincarcération", "Sauvetage Technique"],
                notes: "Centre principal d'intervention de la zone Sud."
            ),
            EmergencyPOI(
                name: "CIS Dudelange (CGDIS)",
                category: .cgdis,
                address: "Route de Luxembourg",
                commune: "Dudelange",
                postalCode: "L-3515",
                latitude: 49.4891,
                longitude: 6.0822,
                phone: "+352 49771 4100",
                openingHours: "24h/24 - Intervention Rapide",
                emergencyServices: ["Secours à personne", "Lutte contre l'incendie", "Appui Transfrontalier"],
                notes: "Couverture sud-est et frontière française."
            ),
            EmergencyPOI(
                name: "CIS Differdange (CGDIS)",
                category: .cgdis,
                address: "Rue Emile Mark",
                commune: "Differdange",
                postalCode: "L-4620",
                latitude: 49.5244,
                longitude: 5.8941,
                phone: "+352 49771 4200",
                openingHours: "24h/24 - Pompiers & Ambulanciers",
                emergencyServices: ["Ambulance d'urgence", "Incendie Industriel et Urbain"],
                notes: "Centre du bassin minier occidental."
            ),
            EmergencyPOI(
                name: "CIS Diekirch - Ettelbruck (Nordstad CGDIS)",
                category: .cgdis,
                address: "Zone Industrielle Fridhaff",
                commune: "Diekirch",
                postalCode: "L-9379",
                latitude: 49.8821,
                longitude: 6.1388,
                phone: "+352 49771 5000",
                openingHours: "24h/24 - Centre Régional Nord",
                emergencyServices: ["Ambulances Nordstad", "Sauvetage Aquatique Sûre", "Incendie & Désincarcération"],
                notes: "Centre névralgique de secours pour la vallée de la Sûre et Nordstad."
            ),
            EmergencyPOI(
                name: "CIS Remich (CGDIS)",
                category: .cgdis,
                address: "Route de Stadtbredimus",
                commune: "Remich",
                postalCode: "L-5570",
                latitude: 49.5489,
                longitude: 6.3683,
                phone: "+352 49771 6000",
                openingHours: "24h/24 - Secours Moselle",
                emergencyServices: ["Ambulances", "Embarcations Fluviales Moselle", "Sauvetage Crues"],
                notes: "Zone frontalière Cattenom (rayon 15 km) et secours fluviaux."
            ),
            EmergencyPOI(
                name: "CIS Grevenmacher (CGDIS)",
                category: .cgdis,
                address: "Route du Vin",
                commune: "Grevenmacher",
                postalCode: "L-6794",
                latitude: 49.6806,
                longitude: 6.4422,
                phone: "+352 49771 6100",
                openingHours: "24h/24 - Secours Région Est",
                emergencyServices: ["Ambulances", "Sauvetage Nautique", "Lutte contre les inondations"],
                notes: "Poste d'intervention stratégique de la Moselle luxembourgeoise."
            ),
            EmergencyPOI(
                name: "CIS Mersch (CGDIS)",
                category: .cgdis,
                address: "Rue Grande-Duchesse Charlotte",
                commune: "Mersch",
                postalCode: "L-7520",
                latitude: 49.7511,
                longitude: 6.1039,
                phone: "+352 49771 7000",
                openingHours: "24h/24 - Centre Géographique",
                emergencyServices: ["Ambulances", "Appui Autoroute A7", "Désincarcération Lourde"],
                notes: "Couverture du centre du pays et de l'axe autoroutier A7."
            ),
            EmergencyPOI(
                name: "CIS Wiltz (CGDIS)",
                category: .cgdis,
                address: "Zone Industrielle Rullingen",
                commune: "Wiltz",
                postalCode: "L-9539",
                latitude: 49.9611,
                longitude: 5.9234,
                phone: "+352 49771 8000",
                openingHours: "24h/24 - Secours Ardennes",
                emergencyServices: ["Ambulances Tout-Terrain", "Sauvetage Forêt et Neige", "Incendie Rural"],
                notes: "Intervention en milieu accidenté et conditions hivernales de l'Éislek."
            ),
            EmergencyPOI(
                name: "CIS Clervaux (CGDIS)",
                category: .cgdis,
                address: "Mecherwee",
                commune: "Clervaux",
                postalCode: "L-9749",
                latitude: 50.0544,
                longitude: 6.0289,
                phone: "+352 49771 8100",
                openingHours: "24h/24 - Extrême Nord",
                emergencyServices: ["Ambulances Éislek", "Incendie"],
                notes: "Couverture du canton de Clervaux et communes frontalières."
            ),
            EmergencyPOI(
                name: "CIS Echternach (CGDIS)",
                category: .cgdis,
                address: "Route de Wasserbillig",
                commune: "Echternach",
                postalCode: "L-6490",
                latitude: 49.8089,
                longitude: 6.4256,
                phone: "+352 49771 9000",
                openingHours: "24h/24 - Mullerthal & Sûre",
                emergencyServices: ["Ambulances", "Sauvetage Roches et Cavités (GRIMP)", "Crues Sûre"],
                notes: "Zone touristique Petite Suisse luxembourgeoise et Mullerthal."
            ),
            EmergencyPOI(
                name: "CIS Steinfort (CGDIS)",
                category: .cgdis,
                address: "Rue de Kleinbettingen",
                commune: "Steinfort",
                postalCode: "L-8436",
                latitude: 49.6583,
                longitude: 5.9189,
                phone: "+352 49771 3000",
                openingHours: "24h/24 - Ouest Frontalier",
                emergencyServices: ["Ambulances", "Appui Autoroute A6", "Incendie"],
                notes: "Sécurisation axe Bruxelles-Luxembourg A6."
            ),
            
            // MARK: - 3. DISTRIBUIÇÃO DE COMPRIMIDOS DE IODO (PLANO NUCLEAR CATTENOM)
            EmergencyPOI(
                name: "Pharmacie de la Gare (Point Iode)",
                category: .iodinePoint,
                address: "84 Avenue de la Gare",
                commune: "Luxembourg-Ville",
                postalCode: "L-1610",
                latitude: 49.6022,
                longitude: 6.1328,
                phone: "+352 48 01 22",
                openingHours: "8h00 - 18h30 (Service de garde variable)",
                emergencyServices: ["Distribution Gratuite Comprimés Iodure de Potassium", "Conseils Radioprotection"],
                notes: "Sur présentation de bon communal ou carte CNS. Priorité femmes enceintes, bébés et jeunes <18 ans."
            ),
            EmergencyPOI(
                name: "Pharmacie de l'Éléphant (Point Iode Sud)",
                category: .iodinePoint,
                address: "1 Rue de l'Alzette",
                commune: "Esch-sur-Alzette",
                postalCode: "L-4010",
                latitude: 49.4950,
                longitude: 5.9819,
                phone: "+352 54 00 24",
                openingHours: "8h30 - 18h30",
                emergencyServices: ["Stock d'urgence comprimés d'iode K-Iodure", "Délivrance de crise"],
                notes: "Zone 1 de vigilance radiologique relative au CNPE de Cattenom."
            ),
            EmergencyPOI(
                name: "Maison Communale de Dudelange (Distribution Iode)",
                category: .iodinePoint,
                address: "Place de l'Hôtel de Ville",
                commune: "Dudelange",
                postalCode: "L-3590",
                latitude: 49.4803,
                longitude: 6.0844,
                phone: "+352 5161 21 1",
                openingHours: "Lundi-Vendredi 8h00 - 17h00 (Permanence 24h en crise)",
                emergencyServices: ["Point officiel de retrait communal des boîtes d'iode", "Centre d'information citoyen"],
                notes: "Canton d'Esch / Zone de proximité immédiate Cattenom."
            ),
            EmergencyPOI(
                name: "Administration Communale de Remich (Point Iode Moselle)",
                category: .iodinePoint,
                address: "Place du Marché",
                commune: "Remich",
                postalCode: "L-5555",
                latitude: 49.5442,
                longitude: 6.3672,
                phone: "+352 23 69 21",
                openingHours: "8h00 - 17h00 (Mobilisation d'urgence)",
                emergencyServices: ["Distribution Iode aux résidents et frontaliers", "Poste communal de crise"],
                notes: "Commune frontalière située dans le rayon direct de planification d'urgence Cattenom."
            ),
            EmergencyPOI(
                name: "Administration Communale de Mondorf-les-Bains",
                category: .iodinePoint,
                address: "1 Place des Villes Jumelées",
                commune: "Mondorf-les-Bains",
                postalCode: "L-5627",
                latitude: 49.5064,
                longitude: 6.2817,
                phone: "+352 23 66 84 08",
                openingHours: "8h00 - 16h30",
                emergencyServices: ["Comprimés d'iodure de potassium", "Registre communal d'évacuation"],
                notes: "Secteur frontalier Sud-Est."
            ),
            EmergencyPOI(
                name: "Pharmacie Centrale (Point Iode Nord)",
                category: .iodinePoint,
                address: "38 Rue Grande-Duchesse Charlotte",
                commune: "Ettelbruck",
                postalCode: "L-9080",
                latitude: 49.8475,
                longitude: 6.1022,
                phone: "+352 81 21 68",
                openingHours: "8h30 - 18h30",
                emergencyServices: ["Distribution Comprimés Iode Nordstad", "Délivrance de secours"],
                notes: "Point de référence pour le nord du pays."
            ),
            
            // MARK: - 4. CENTROS DE RALLIEMENT E ABRIGOS DE EMERGÊNCIA (ACCUEIL CIVIL)
            EmergencyPOI(
                name: "Centre National Sportif et Culturel d'Coque",
                category: .shelter,
                address: "2 Rue Léon Hengen",
                commune: "Luxembourg-Kirchberg",
                postalCode: "L-1745",
                latitude: 49.6231,
                longitude: 6.1542,
                phone: "+352 43 60 60 1",
                openingHours: "Activation sur ordre du Haut-Commissariat à la Protection Nationale",
                emergencyServices: ["Grande capacité d'hébergement d'urgence (3000+ personnes)", "Distribution de repas chauds", "Point de regroupement familial"],
                notes: "Plus grand complexe couvert du pays, désigné comme centre d'accueil de masse en cas de crise majeure."
            ),
            EmergencyPOI(
                name: "Hall Omnisports de Lallange",
                category: .shelter,
                address: "Boulevard Hubert Clément",
                commune: "Esch-sur-Alzette",
                postalCode: "L-4064",
                latitude: 49.5086,
                longitude: 5.9867,
                phone: "+352 54 54 45 1",
                openingHours: "Activation selon déclenchement du Plan Communal d'Urgence",
                emergencyServices: ["Hébergement d'urgence Sud", "Sanitaires & Ravitaillement", "Prise en charge familles"],
                notes: "Centre de repli et d'accueil en cas d'inondation majeure de l'Alzette ou accident industriel."
            ),
            EmergencyPOI(
                name: "Däichhal Ettelbruck (Centre d'Accueil Nord)",
                category: .shelter,
                address: "Rue du Déich",
                commune: "Ettelbruck",
                postalCode: "L-9012",
                latitude: 49.8442,
                longitude: 6.1075,
                phone: "+352 81 91 81 1",
                openingHours: "Activation sur décision des Autorités Communales / CGDIS",
                emergencyServices: ["Refuge d'urgence Crues de l'Alzette et de la Sûre", "Centre logistique humanitaire"],
                notes: "Hall d'accueil civique pour les évacuations du bassin de la Sûre et de la Wark."
            )
        ]
    }
    
    /// Retorna os pontos filtrados por categoria, pesquisa de texto e ordenados por distância à localização atual
    public func filterPoints(
        category: POICategory?,
        searchQuery: String,
        userLocation: CLLocation?
    ) -> [EmergencyPOI] {
        var results = allPoints
        
        // 1. Filtrar por categoria
        if let cat = category {
            results = results.filter { $0.category == cat }
        }
        
        // 2. Filtrar por texto de pesquisa (nome, comuna, serviços ou morada)
        let trimmed = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !trimmed.isEmpty {
            results = results.filter { poi in
                poi.name.lowercased().contains(trimmed) ||
                poi.commune.lowercased().contains(trimmed) ||
                poi.address.lowercased().contains(trimmed) ||
                poi.emergencyServices.contains(where: { $0.lowercased().contains(trimmed) })
            }
        }
        
        // 3. Ordenar por distância se tiver localização GPS, senão por nome
        if let userLoc = userLocation {
            results.sort {
                $0.location.distance(from: userLoc) < $1.location.distance(from: userLoc)
            }
        } else {
            results.sort { $0.name < $1.name }
        }
        
        return results
    }
}
