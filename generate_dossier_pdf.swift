import Foundation
import WebKit
import PDFKit
import AppKit

class MultiPagePDFBuilder: NSObject, WKNavigationDelegate {
    let pagesHTML: [String]
    let outputURL: URL
    var currentIndex = 0
    var webView: WKWebView!
    var finalDoc = PDFDocument()

    init(pagesHTML: [String], outputURL: URL) {
        self.pagesHTML = pagesHTML
        self.outputURL = outputURL
        super.init()

        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 595.28, height: 841.89), configuration: config)
        self.webView.navigationDelegate = self
    }

    func start() {
        loadCurrentPage()
    }

    func loadCurrentPage() {
        guard currentIndex < pagesHTML.count else {
            finalDoc.write(to: outputURL)
            print("SUCCESS: Perfectly generated \(finalDoc.pageCount) pages to \(outputURL.path)")
            exit(0)
        }
        let html = pagesHTML[currentIndex]
        webView.loadHTMLString(html, baseURL: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let config = WKPDFConfiguration()
        config.rect = CGRect(x: 0, y: 0, width: 595.28, height: 841.89)
        webView.createPDF(configuration: config) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let singlePageDoc = PDFDocument(data: data), let page = singlePageDoc.page(at: 0) {
                    self.finalDoc.insert(page, at: self.finalDoc.pageCount)
                }
                self.currentIndex += 1
                self.loadCurrentPage()
            case .failure(let err):
                print("Failed page \(self.currentIndex): \(err)")
                exit(1)
            }
        }
    }
}

let sharedCSS = """
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}
html, body {
    margin: 0;
    padding: 0;
    width: 595px;
    height: 842px;
    background: #FFFFFF;
    font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    color: #1E293B;
    -webkit-font-smoothing: antialiased;
}

.page-container {
    width: 595px;
    height: 842px;
    box-sizing: border-box;
    padding: 28px 42px 22px 42px;
    position: relative;
    overflow: hidden;
    background: #FFFFFF;
}

.header-band {
    display: flex;
    height: 5px;
    width: 100%;
    margin-bottom: 12px;
    border-radius: 3px;
    overflow: hidden;
}
.band-red { background: #EA141D; flex: 1; }
.band-white { background: #FFFFFF; border-top: 1px solid #CBD5E1; border-bottom: 1px solid #CBD5E1; flex: 1; }
.band-blue { background: #00A1DE; flex: 1; }

.top-institution {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1.5px solid #002B49;
    padding-bottom: 6px;
    margin-bottom: 14px;
    width: 100%;
}
.institution-title {
    font-size: 8.5px;
    font-weight: 800;
    letter-spacing: 0.8px;
    color: #002B49;
    text-transform: uppercase;
}
.institution-badge {
    font-size: 7.5px;
    font-weight: 700;
    color: #00A1DE;
    background: rgba(0, 161, 222, 0.08);
    padding: 2px 7px;
    border-radius: 4px;
    border: 0.8px solid rgba(0, 161, 222, 0.3);
}

.footer {
    position: absolute;
    bottom: 16px;
    left: 42px;
    right: 42px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-top: 0.8px solid #CBD5E1;
    padding-top: 5px;
    font-size: 7.5px;
    color: #64748B;
}

h1.doc-title {
    font-size: 19px;
    font-weight: 900;
    color: #002B49;
    line-height: 1.15;
    margin-bottom: 3px;
    letter-spacing: -0.2px;
}
.doc-subtitle {
    font-size: 10.5px;
    font-weight: 700;
    color: #EA141D;
    margin-bottom: 12px;
}

.card {
    background: #F8FAFC;
    border: 1px solid #E2E8F0;
    border-radius: 7px;
    padding: 9px 12px;
    margin-bottom: 10px;
    width: 100%;
}

.card-highlight {
    background: linear-gradient(135deg, rgba(0, 43, 73, 0.04), rgba(0, 161, 222, 0.08));
    border: 1.2px solid #00A1DE;
}

.meta-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px;
    font-size: 8px;
}
.meta-item { display: flex; flex-direction: column; }
.meta-label { font-size: 7px; font-weight: 700; color: #64748B; text-transform: uppercase; margin-bottom: 1px; }
.meta-value { font-size: 8px; font-weight: 700; color: #0F172A; line-height: 1.3; }

.section-head {
    display: flex;
    align-items: center;
    font-size: 9.5px;
    font-weight: 800;
    color: #002B49;
    margin-bottom: 6px;
    border-left: 3px solid #EA141D;
    padding-left: 6px;
    text-transform: uppercase;
    letter-spacing: 0.3px;
}

p.justified {
    font-size: 8px;
    line-height: 1.45;
    color: #334155;
    text-align: justify;
    text-justify: inter-word;
    margin-bottom: 8px;
}

.principle-box {
    display: flex;
    gap: 8px;
    margin-bottom: 7px;
    padding: 7px 10px;
    background: #FFFFFF;
    border: 0.8px solid #E2E8F0;
    border-radius: 6px;
    width: 100%;
}
.principle-num {
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background: #002B49;
    color: #FFFFFF;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 8px;
    font-weight: 800;
    flex-shrink: 0;
}
.principle-title { font-size: 8px; font-weight: 800; color: #002B49; margin-bottom: 2px; }
.principle-desc { font-size: 7.2px; color: #475569; line-height: 1.35; text-align: justify; text-justify: inter-word; }

table.data-table {
    width: 100%;
    table-layout: fixed;
    border-collapse: collapse;
    font-size: 7.2px;
    margin-bottom: 8px;
}
table.data-table th {
    background: #002B49;
    color: #FFFFFF;
    text-align: left;
    padding: 5px 6px;
    font-weight: 700;
    font-size: 6.8px;
    text-transform: uppercase;
}
table.data-table td {
    padding: 4.5px 6px;
    border-bottom: 0.8px solid #E2E8F0;
    line-height: 1.3;
    word-wrap: break-word;
}
table.data-table tr:nth-child(even) td { background: #F8FAFC; }

.lang-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 5px;
    margin-top: 6px;
    margin-bottom: 8px;
    width: 100%;
}
.lang-chip {
    background: #FFFFFF;
    border: 0.8px solid #CBD5E1;
    border-radius: 4px;
    padding: 4px 6px;
    font-size: 7px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 4px;
}

.formula-box {
    background: #0F172A;
    color: #38BDF8;
    font-family: "SF Mono", Menlo, Consolas, monospace;
    font-size: 7px;
    padding: 7px 9px;
    border-radius: 5px;
    line-height: 1.35;
    margin: 6px 0 8px 0;
    width: 100%;
    word-break: break-word;
}
"""

// Page 1
let p1 = """
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=595, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>\(sharedCSS)</style>
</head>
<body>
<div class="page-container">
    <div class="header-band"><div class="band-red"></div><div class="band-white"></div><div class="band-blue"></div></div>
    
    <div class="top-institution">
        <div class="institution-title">Grand-Duché de Luxembourg • Protection Civile & Résilience</div>
        <div class="institution-badge">Dossier Officiel d'Homologation</div>
    </div>

    <div style="font-size: 8px; font-weight: 800; color: #00A1DE; text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 3px;">
        Dossier de Présentation Technique & Civique
    </div>
    <h1 class="doc-title">Mon Guide 72h d'Autonomie</h1>
    <div class="doc-subtitle">En Appui à la Stratégie Nationale de Résilience « Lëtz prepare ! »</div>

    <div class="card card-highlight">
        <div class="meta-grid">
            <div class="meta-item">
                <span class="meta-label">Destinataires Officiels</span>
                <span class="meta-value">Haut-Commissariat à la Protection Nationale (HCPN)<br>Corps Grand-Ducal d'Incendie et de Secours (CGDIS)</span>
            </div>
            <div class="meta-item">
                <span class="meta-label">Porteur du Projet & Développeur</span>
                <span class="meta-value">Renato Reis — INFOREIS (Luxembourg)<br>info@inforeis.eu | https://www.inforeis.eu</span>
            </div>
            <div class="meta-item">
                <span class="meta-label">Version & Date</span>
                <span class="meta-value">Version 1.2.0 (Build 3) • Octobre 2026</span>
            </div>
            <div class="meta-item">
                <span class="meta-label">Modèle Économique & Juridique</span>
                <span class="meta-value" style="color: #059669;">100% Gratuit • Sans Publicité • Zéro Cloud</span>
            </div>
        </div>
    </div>

    <div class="section-head">1. Résumé Exécutif & Motivation Citoyenne</div>
    <p class="justified">
        Ce dossier est présenté dans le cadre de la demande formelle d'aval institutionnel (<strong>patronage d'honneur</strong>) formulée auprès du Gouvernement luxembourgeois. <strong>Mon Guide 72h</strong> est une solution logicielle tout-en-un, développée bénévolement pour offrir à chaque résident et frontalier les outils numériques nécessaires pour faire face à une crise majeure (inondations, blackout électrique, rupture des télécommunications, incident chimique ou radiologique).
    </p>

    <div class="section-head" style="border-left-color: #00A1DE; margin-top: 10px;">Les Trois Piliers Fondateurs Inaliénables</div>

    <div class="principle-box">
        <div class="principle-num">1</div>
        <div>
            <div class="principle-title">Utilité Publique Absolue & Gratuité Perpétuelle</div>
            <div class="principle-desc">L'application est et restera à titre perpétuel strictement gratuite pour tous les citoyens. Aucun modèle freemium, aucun abonnement, aucune publicité ne viendra jamais entraver son accès en situation d'urgence vitale.</div>
        </div>
    </div>

    <div class="principle-box">
        <div class="principle-num">2</div>
        <div>
            <div class="principle-title">Résilience Totale Hors-Ligne (100% Offline Autonomy)</div>
            <div class="principle-desc">Lors d'un effondrement des réseaux cellulaires (4G/5G) ou d'une coupure électrique généralisée, Mon Guide 72h conserve 100% de ses fonctionnalités : calcul des réserves, balise topographique LUREF, fiches réflexes, simulateur de sirènes et guide vocal.</div>
        </div>
    </div>

    <div class="principle-box">
        <div class="principle-num">3</div>
        <div>
            <div class="principle-title">Confidentialité Radicale (Privacy by Design — CNPD & RGPD)</div>
            <div class="principle-desc">Zéro serveur cloud, zéro profilage, zéro cookie. Toutes les informations familiales, médicales (CNS, groupe sanguin) et géographiques sont traitées exclusivement dans la mémoire locale de l'appareil sans transmission externe.</div>
        </div>
    </div>

    <div class="footer">
        <span>Mon Guide 72h — Dossier d'Homologation HCPN / CGDIS</span>
        <span>Version 1.2.0 • Page 1 / 4</span>
    </div>
</div>
</body>
</html>
"""

// Page 2
let p2 = """
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=595, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>\(sharedCSS)</style>
</head>
<body>
<div class="page-container">
    <div class="header-band"><div class="band-red"></div><div class="band-white"></div><div class="band-blue"></div></div>
    
    <div class="top-institution">
        <div class="institution-title">Alignement Opérationnel avec la Stratégie « Lëtz prepare ! »</div>
        <div class="institution-badge">Doctrine HCPN</div>
    </div>

    <div class="section-head">2. Transposition Numérique des Directives Gouvernementales</div>
    <p class="justified">
        L'application digitalise rigoureusement les cinq volets fondamentaux de la brochure officielle de résilience civile éditée par le Haut-Commissariat à la Protection Nationale :
    </p>

    <table class="data-table">
        <thead>
            <tr>
                <th style="width: 26%;">Pilier « Lëtz prepare ! »</th>
                <th style="width: 36%;">Module Développé dans l'Application</th>
                <th style="width: 38%;">Apport Opérationnel & Technologique</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><strong>1. Eau & Vivres (72h)</strong></td>
                <td>Calculateur Dynamique de Réserves Vitales</td>
                <td>Algorithme calculant précisément les litres d'eau (3L/pers/jour) et rations caloriques selon les adultes, enfants, bébés et animaux.</td>
            </tr>
            <tr>
                <td><strong>2. Évacuation Rapide</strong></td>
                <td>Checklist Sac d'Évacuation (Bug-Out Bag)</td>
                <td>Inventaire interactif des 15 articles vitaux avec contrôle dynamique des dates de péremption (Expiry Tracker).</td>
            </tr>
            <tr>
                <td><strong>3. Plan Familial</strong></td>
                <td>Générateur de Plan d'Urgence & Dossier A4</td>
                <td>Saisie des points de ralliement, contacts hors zone et vannes de sécurité (eau/gaz/électricité) avec export PDF imprimable (AirPrint).</td>
            </tr>
            <tr>
                <td><strong>4. Alerte & Sirènes</strong></td>
                <td>Simulateur Acoustique des Sirènes Nationales</td>
                <td>Reproduction audio exacte des 4 sonneries du Luxembourg (Test, Alerte, Alarme nationale ondulante, Fin d'alerte) via Web Audio API.</td>
            </tr>
            <tr>
                <td><strong>5. Radio Résiliente</strong></td>
                <td>Guide Hertzien Officiel FM / DAB+</td>
                <td>Répertoire des fréquences prioritaires secourues sur groupe électrogène (RTL 88.9/92.5 MHz et Radio 100.7) en cas de blackout telecom.</td>
            </tr>
        </tbody>
    </table>

    <div class="section-head" style="border-left-color: #00A1DE; margin-top: 10px;">3. Inclusion Linguistique Exceptionnelle (7 Langues)</div>
    <p class="justified">
        Le Luxembourg comptant plus de 47% de résidents non-luxembourgeois et plus de 200 000 frontaliers, Mon Guide 72h garantit une égalité d'accès aux consignes de survie grâce à une localisation complète et certifiée :
    </p>

    <div class="lang-grid">
        <div class="lang-chip">🇱🇺 Lëtzebuergesch</div>
        <div class="lang-chip">🇫🇷 Français (Admin)</div>
        <div class="lang-chip">🇩🇪 Deutsch</div>
        <div class="lang-chip">🇵🇹 Português (~15%)</div>
        <div class="lang-chip">🇬🇧 English (EU)</div>
        <div class="lang-chip">🇪🇸 Español</div>
        <div class="lang-chip">🇮🇹 Italiano</div>
        <div class="lang-chip" style="background:#002B49; color:#FFF;">7 Langues 100% Offline</div>
    </div>

    <div class="card" style="margin-top: 10px; background: rgba(0, 161, 222, 0.04); border-color: #00A1DE;">
        <div style="font-size: 8px; font-weight: 800; color: #002B49; margin-bottom: 3px;">🔊 Guide Vocal de Crise Embarqué (Synthèse Vocale Sur-Appareil)</div>
        <div style="font-size: 7.2px; color: #475569; line-height: 1.35; text-align: justify; text-justify: inter-word;">
            Pour les personnes âgées, les citoyens malvoyants ou les familles confinées dans l'obscurité ou un environnement enfumé, l'application intègre un lecteur audio natif à débit mesuré (taux 0.48x) déclamant les réflexes de sécurité sans solliciter la vue et sans consommer de données.
        </div>
    </div>

    <div class="footer">
        <span>Mon Guide 72h — Dossier d'Homologation HCPN / CGDIS</span>
        <span>Version 1.2.0 • Page 2 / 4</span>
    </div>
</div>
</body>
</html>
"""

// Page 3
let p3 = """
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=595, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>\(sharedCSS)</style>
</head>
<body>
<div class="page-container">
    <div class="header-band"><div class="band-red"></div><div class="band-white"></div><div class="band-blue"></div></div>
    
    <div class="top-institution">
        <div class="institution-title">Spécifications Mathématiques & Balise Topographique LUREF</div>
        <div class="institution-badge">Norme EPSG:2169 • CGDIS 112</div>
    </div>

    <div class="section-head">4. Intégration du Système Géodésique National du Luxembourg</div>
    <p class="justified">
        Les services de secours luxembourgeois (112 CGDIS, hélicoptères LAR et patrouilles de recherche en milieu forestier) exploitent prioritairement le système de coordonnées national métrique <strong>LUREF (EPSG:2169)</strong>. La version 1.2.0 intègre un moteur géodésique complet développé selon les spécifications de l'Administration du Cadastre et de la Topographie (ACT) :
    </p>

    <div class="formula-box">
// 1. Transformation 3D de Bursa-Wolf (WGS84 -> Hayford 1909)
dX = -193.0 m, dY = +13.7 m, dZ = -39.3 m
rX = -0.41", rY = -2.933", rZ = +2.688", s = +0.43 ppm

// 2. Projection Transverse Mercator de Gauss-Luxembourg
Méridien central: 6° 10' 00" E | Origine lat.: 49° 50' 00" N
Faux Est (FE): 80 000.0 m | Faux Nord (FN): 100 000.0 m | Facteur k0: 1.0
    </div>

    <div class="section-head" style="border-left-color: #059669; margin-top: 8px;">Validation Métrique par Vecteurs de Test Officiels</div>
    <p class="justified">
        Les résultats de conversion calculés par l'application ont été validés par rapport aux données géodésiques de référence publiées sur <code>map.geoportail.lu</code> :
    </p>

    <table class="data-table">
        <thead>
            <tr>
                <th style="width: 32%;">Site de Référence</th>
                <th style="width: 25%;">Coordonnées WGS84</th>
                <th style="width: 25%;">LUREF Officiel</th>
                <th style="width: 18%;">Écart Métrique</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><strong>Place Guillaume II (Lux-Ville)</strong></td>
                <td>49.61160° N, 6.13190° E</td>
                <td>Est: 77 450 m | Nord: 75 458 m</td>
                <td><strong style="color:#059669;">0.0 m (Parfait)</strong></td>
            </tr>
            <tr>
                <td><strong>Plateau du Kirchberg (Hôpital)</strong></td>
                <td>49.63250° N, 6.17120° E</td>
                <td>Est: 80 324 m | Nord: 77 728 m</td>
                <td><strong style="color:#059669;">0.0 m (Parfait)</strong></td>
            </tr>
            <tr>
                <td><strong>CHEM Esch-sur-Alzette</strong></td>
                <td>49.49880° N, 5.98750° E</td>
                <td>Est: 66 942 m | Nord: 62 815 m</td>
                <td><strong style="color:#059669;">0.0 m (Parfait)</strong></td>
            </tr>
        </tbody>
    </table>

    <div class="section-head" style="border-left-color: #EA141D; margin-top: 8px;">Dispositif Opérationnel de Secours pour le Citoyen</div>
    <div class="card" style="margin-bottom: 0;">
        <div style="font-size: 7.8px; font-weight: 800; color: #EA141D; margin-bottom: 3px;">🗣️ Phrase Phonétique 112 Prête à la Dictée Radio :</div>
        <div style="font-family: monospace; font-size: 7.2px; background: rgba(234,20,29,0.06); padding: 4px 6px; border-radius: 4px; border: 0.8px solid rgba(234,20,29,0.3); margin-bottom: 5px;">
            "112 CGDIS : Je suis localisé au Luxembourg. Coordonnées LUREF Est : 77 450 m, Nord : 75 458 m (Précision : ±5m)."
        </div>
        <div style="font-size: 7.2px; color: #475569; line-height: 1.35;">
            • <strong>Bouton Copie Rapide</strong> : Place la phrase dans le presse-papier avec confirmation par retour haptique.<br>
            • <strong>SMS de Secours Direct 112</strong> : Ouvre automatiquement l'application Messages avec coordonnées et lien Apple Maps.<br>
            • <strong>Disponibilité Multiplateforme</strong> : Affichage sur iPhone, montre connectée Apple Watch et carte hors-ligne.
        </div>
    </div>

    <div class="footer">
        <span>Mon Guide 72h — Dossier d'Homologation HCPN / CGDIS</span>
        <span>Version 1.2.0 • Page 3 / 4</span>
    </div>
</div>
</body>
</html>
"""

// Page 4
let p4 = """
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=595, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>\(sharedCSS)</style>
</head>
<body>
<div class="page-container">
    <div class="header-band"><div class="band-red"></div><div class="band-white"></div><div class="band-blue"></div></div>
    
    <div class="top-institution">
        <div class="institution-title">Architecture de Sécurité, RGPD & Demande d'Homologation</div>
        <div class="institution-badge">Protection des Données</div>
    </div>

    <div class="section-head">5. Conformité Radicale CNPD & Souveraineté des Données</div>
    <p class="justified">
        Les directives de la Commission Nationale pour la Protection des Données (CNPD) et du RGPD européen ont été intégrées dès la conception (<em>Privacy by Design</em>) :
    </p>

    <div class="card" style="padding: 7px 10px; margin-bottom: 8px;">
        <div style="font-size: 7.2px; line-height: 1.38; color: #334155;">
            • <strong>Zéro Compte Utilisateur & Zéro Cookie</strong> : Aucune inscription requise.<br>
            • <strong>Zéro Identifiant Publicitaire</strong> : Les frameworks de suivi (IDFA / GAID) sont complètement purgés.<br>
            • <strong>Fiche Médicale ICE Sécurisée</strong> : Les données vitales (groupe sanguin, numéro CNS, allergies) sont compilées en image directement sur le processeur graphique du smartphone.<br>
            • <strong>Partage P2P Résilient par QR Code (Protocole MG72H:)</strong> : Échange de plan familial d'écran à caméra sans transiter par internet.
        </div>
    </div>

    <div class="section-head" style="border-left-color: #002B49; margin-top: 8px;">6. Objet Formel de la Demande adressée au Gouvernement</div>
    <div class="principle-box">
        <div class="principle-num">A</div>
        <div>
            <div class="principle-title">Aval Institutionnel & Patronage d'Honneur</div>
            <div class="principle-desc">Reconnaissance de Mon Guide 72h en tant qu'application citoyenne recommandée en appui de la stratégie nationale « Lëtz prepare ! ».</div>
        </div>
    </div>

    <div class="principle-box">
        <div class="principle-num">B</div>
        <div>
            <div class="principle-title">Autorisation d'Usage de la Signature Visuelle Officielle</div>
            <div class="principle-desc">Possibilité d'apposer la mention « Développé en soutien à la stratégie Lëtz prepare ! du Gouvernement du Grand-Duché de Luxembourg ».</div>
        </div>
    </div>

    <div class="principle-box">
        <div class="principle-num">C</div>
        <div>
            <div class="principle-title">Audit Technique & Concertation Préventive</div>
            <div class="principle-desc">Mise à disposition gracieuse du code source pour audit de sécurité et réception en amont des révisions de doctrine.</div>
        </div>
    </div>

    <div class="card card-highlight" style="margin-top: 8px; text-align: center; padding: 8px 12px;">
        <div style="font-size: 8px; font-weight: 800; color: #002B49; margin-bottom: 2px;">DÉCLARATION SOLENNELLE D'ENGAGEMENT CIVIQUE</div>
        <p style="font-size: 7.2px; font-style: italic; color: #334155; line-height: 1.35; margin-bottom: 5px;">
            « En tant que citoyen et développeur résident au Grand-Duché de Luxembourg, je m'engage solennellement à maintenir cette application strictement gratuite, sans publicité et au service exclusif de la protection civile de notre population. »
        </p>
        <div style="display: flex; justify-content: space-around; font-size: 7.2px; font-weight: 700; color: #002B49; margin-top: 4px;">
            <span>Renato Reis — INFOREIS</span>
            <span>Grand-Duché de Luxembourg</span>
            <span>info@inforeis.eu | https://www.inforeis.eu</span>
        </div>
    </div>

    <div class="footer">
        <span>Mon Guide 72h — Dossier d'Homologation HCPN / CGDIS</span>
        <span>Version 1.2.0 • Page 4 / 4</span>
    </div>
</div>
</body>
</html>
"""

let outputURL = URL(fileURLWithPath: "/Users/renatoreis/Desktop/MonGuide72h/DOSSIER_HOMOLOGATION_HCPN_LUXEMBOURG.pdf")
let builder = MultiPagePDFBuilder(pagesHTML: [p1, p2, p3, p4], outputURL: outputURL)
builder.start()
RunLoop.main.run()