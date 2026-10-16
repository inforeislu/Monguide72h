# Mon Guide 72h d'Autonomie — Version 1.2.0 🇱🇺
### *« Lëtz prepare ! » — Stratégie Nationale de Résilience Civile*

Bienvenue dans la version **1.2.0** de **MonGuide72h**, l'application multiplateforme (Web PWA, iOS, Android) conçue pour assurer la résilience et l'autonomie des citoyens résidant ou travaillant au Grand-Duché de Luxembourg pendant au moins 72 heures en cas de crise majeure (blackout électrique, inondations, effondrement des télécommunications).

---

## 📦 Fichiers Disponibles au Téléchargement

| Fichier | Plateforme | Description |
| :--- | :---: | :--- |
| **`app-debug.apk`** | **Android** | Installation directe sur tout smartphone ou tablette Android (sans compte Google Play requis). |
| **`app-release.aab`** | **Android Store** | Android App Bundle officiel optimisé avec minification R8 pour la Google Play Console. |
| **PWA Web Hors-Ligne** | **Tous OS** | Accessible et installable via le navigateur sur [inforeislu.github.io/Monguide72h](https://inforeislu.github.io/Monguide72h/). |
| **Application iOS Native** | **iPhone / iPad** | Code source SwiftUI prêt pour déploiement TestFlight et App Store Connect (`ios/MonGuide72h.xcodeproj`). |

---

## 🌟 Nouveautés Majeures de la v1.2.0

### 1. 📱 Fiche Médicale ICE & Générateur de Fond d'Écran (Lock Screen)
- Générateur d'image haute définition (`1080×2340 px`) directement dans votre navigateur ou smartphone via HTML5 Canvas.
- Affiche le groupe sanguin, le matricule national (CNS - 13 chiffres), les allergies vitales et deux contacts d'urgence consultables par le **112 / SAMU** sans déverrouiller votre téléphone.

### 2. 📲 Partage de Plan Familial P2P Hors-Ligne (QR Code)
- Partagez et synchronisez instantanément votre plan familial entre smartphones **sans connexion internet ni serveur distant**.
- Générateur de QR Code haute densité avec protocole unifié `MG72H:`.
- Scanner intégré par caméra en direct (BarcodeDetector API) et importateur d'images/captures d'écran.
- Partage natif via **AirDrop**, **Bluetooth**, SMS ou messageries chiffrées via la Web Share API.

### 3. 🔴 Mode Vision Nocturne Tactique & Balise SOS Morse
- Filtre monochromatique rouge (`#ff1a1a` sur noir absolu) qui préserve la rodopsine oculaire dans l'obscurité et les abris de crise.
- Balise lumineuse clignotante émettant le signal international de détresse `... --- ...` pour guider les secours aériens.

### 4. 📻 Réseau Radio Résilient d'Urgence (FM / DAB+)
- Fréquences de secours officielles au Luxembourg (RTL 88.9 & 92.5 MHz, Radio 100.7, Eldoradio) et transfrontalières (France Info 105.5 MHz, SWR3 98.5 MHz, RTBF 96.4 MHz).

### 5. 📅 Suivi des Péremptions du Kit 72h (*Expiry Tracker*)
- Gestionnaire de rotation des réserves vitales (eau minérale, conserves, piles alcalines, trousse de secours) avec alertes visuelles.

### 6. 🌐 Support Multilingue Complet (7 Langues)
- 🇫🇷 Français (langue principale)
- 🇱🇺 Lëtzebuergesch (langue nationale)
- 🇩🇪 Deutsch
- 🇵🇹 Português (~20% de la population résidente)
- 🇬🇧 English
- 🇪🇸 Español
- 🇮🇹 Italiano

---

## 🔒 Confidentialité & Résilience 100% Hors-Ligne
- **Zéro Pistage / Zéro Télémétrie** : Vos données personnelles, vos contacts d'urgence et vos adresses de ralliement restent à 100% sur votre appareil.
- **Fonctionnement Sans Réseau** : Tous les calculs, générateurs de QR codes, synthétiseurs audio de sirènes nationales et fiches d'action fonctionnent sans internet.

© 2026 **InfoReis** • Renato Reis ([inforeis.eu](https://www.inforeis.eu))  
Inspiré de la stratégie officielle *« Lëtz prepare ! »* du Haut-Commissariat à la Protection nationale (HCPN / CGDIS) du Luxembourg.
