# Changelog — Mon Guide 72h d'Autonomie

Toutes les modifications notables apportées à ce projet sont documentées dans ce fichier.

---

## [1.2.0] — 2026-10-16

### 🚀 Nouveautés & Módulos Táticos
* **📱 Fiche Médicale ICE & Générateur de Fond d'Écran** :
  * Génération haute définition (`1080×2340 px`) directement dans l'appareil avec `<canvas>` HTML5 et Compose.
  * Badge de groupe sanguin haute visibilité, numéro CNS, allergies critiques et deux contacts ICE avec appel direct.
* **🔴 Mode Vision Nocturne (Rouge)** :
  * Filtre monochromatique protecteur de la rodopsine pour préserver la vision dans l'obscurité et les abris de crise.
* **🚨 Balise SOS en Code Morse** :
  * Signal optique d'urgence à pulsations calibrées (`... --- ...`) pour guidage des hélicoptères de secours (SAMU / CGDIS).
* **📅 Suivi des Dates de Péremption du Kit (*Expiry Tracker*)** :
  * Rotation dynamique des réserves d'eau, conserves, piles et matériel médical avec alertes de remplacement.
* **📻 Réseau Radio Résilient d'Urgence** :
  * Guide complet des fréquences FM/DAB+ au Luxembourg (RTL 88.9 & 92.5 MHz, Radio 100.7, Eldoradio) et zones frontalières (FR, DE, BE).

### 🤖 Android Nativo (Jetpack Compose)
* Création des écrans natifs : `EmergencyRadioScreen.kt`, `ExpiryTrackerScreen.kt` et `MedicalICEScreen.kt`.
* Harmonisation de l'`applicationId` pour `com.inforeis.monguide72h` et version `1.2.0`.
* Correction du SDK path dans `local.properties` et validation de la compilation (`assembleDebug`).

### 🌐 Web PWA
* Service Worker v2 avec mise en cache locale intégrale des logos et icônes.
* Sélecteur de pays d'urgence dynamique avec support de 15 pays européens.
* Harmonisation multilingue sur 7 langues officielles et régionales (FR, LU, DE, PT, EN, ES, IT).

---

## [1.1.0] — 2026-09-20
* Intégration du compagnon Apple Watch (`MonGuide72hWatch`) et des widgets iOS (`MonGuide72hWidget`).
* Partage familial hors-ligne par QR Code.
* Carte locale hors-ligne des centres de secours et points d'accueil d'urgence (CGDIS).

---

## [1.0.0] — 2026-08-15
* Lancement initial inspiré de la stratégie *« Lëtz prepare ! »*.
* Calculateur de réserves vitales 72h (eau, nourriture, bébés, animaux).
* Checklist interactive du sac d'évacuation rapide (*Bug-Out Bag*).
* Plan familial de crise avec export papier formaté A4.
* Synthétiseur acoustique de sirènes nationales via Web Audio API.
