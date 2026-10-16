# DOSSIER TECHNIQUE & DE HOMOLOGATION INSTITUTIONNELLE
## Mon Guide 72h d'Autonomie — Version 1.2.0
### Présenté au Haut-Commissariat à la Protection Nationale (HCPN) & au Corps Grand-Ducal d'Incendie et de Secours (CGDIS)

---

**Grand-Duché de Luxembourg**  
**Date :** Octobre 2026  
**Auteur du projet :** Renato Reis — INFOREIS (`info@inforeis.eu` / `https://www.inforeis.eu`)  
**Nature de l'initiative :** Contribution bénévole d'intérêt public & civique  
**Statut juridique & économique :** 100% Gratuit, Sans Publicité, Sans Cloud, Code Ouvert  
**Plateformes supportées :** iOS Nativo (SwiftUI / Apple Watch / Widgets), Android Nativo (Jetpack Compose), Web PWA Hors-Ligne

---

## 1. Résumé Exécutif & Motivation Citoyenne

La présente demande s'inscrit dans la continuité directe de la démarche officielle engagée auprès des autorités luxembourgeoises pour solliciter l'aval institutionnel (*patronage d'honneur*) du Gouvernement du Grand-Duché de Luxembourg.

**Mon Guide 72h** est une initiative technologique et citoyenne indépendante conçue pour soutenir, vulgariser et rendre universellement accessible la **Stratégie Nationale de Résilience « Lëtz prepare ! »** publiée par le Haut-Commissariat à la Protection Nationale (HCPN).

### Principes Fondateurs Inaliénables :
1. **Utilité Publique Absolue** : L'application est et restera **strictement gratuite pour tous les citoyens**. Aucun modèle économique, aucun abonnement, aucune publicité ne viendra jamais entraver son accès.
2. **Autonomie Totale Hors-Ligne (100% Offline)** : Lors d'un blackout électrique sévère, d'une rupture des câbles sous-marins ou d'une saturation des réseaux cellulaires 4G/5G, **Mon Guide 72h continue de fonctionner à 100% de ses capacités**.
3. **Respect Rigoureux de la Vie Privée (CNPD & RGPD)** : Aucune donnée personnelle, médicale ou de localisation n'est transmise à des serveurs tiers. Tout reste exclusivement confiné dans la mémoire locale de l'appareil du citoyen (*Zero-Telemetry Architecture*).

---

## 2. Alignement Opérationnel avec la Stratégie « Lëtz prepare ! »

L'application transpose fidèlement les recommandations gouvernementales en outils interactifs de haute précision :

| Recommandation Gouvernementale | Module Développé dans Mon Guide 72h | Spécificité Technique |
| :--- | :--- | :--- |
| **Eau & Vivres (3 jours)** | **Calculateur Dynamique de Réserves 72h** | Algorithme calculant les volumes exacts d'eau potable (3L/jour/personne), rations caloriques, alimentation pour nourrissons et animaux domestiques selon la composition réelle du foyer. |
| **Évacuation Rapide** | **Checklist Interactive du Sac d'Évacuation (Bug-Out Bag)** | Vérification pas-à-pas des 15 articles vitaux avec gestion des dates de péremption (*Expiry Tracker*). |
| **Plan d'Urgence Familial** | **Générateur de Plan de Crise & Export PDF A4** | Saisie des coordonnées des proches, points de ralliement (dans et hors quartier), et vannes de sécurité (eau, gaz, électricité) avec génération d'un dossier papier imprimable via AirPrint. |
| **Alerte & Sirènes** | **Simulateur Acoustique des Sirènes Nationales** | Synthèse audio exacte des 4 signaux d'alarme du Luxembourg (Test mensuel, Alerte, Alarme nationale ondulante, Fin d'alerte) avec les consignes comportementales associées. |
| **Réseau Radio Résilient** | **Guide Hertzien FM/DAB+ Officiel** | Répertoire des fréquences prioritaires mandatées par l'État (RTL 88.9 / 92.5 MHz et Radio 100.7) secourues par groupes électrogènes autonomes. |

---

## 3. Innovation Technologique Majeure : La Balise LUREF (EPSG:2169)

En situation de crise (accident en forêt du Müllerthal, inondation de l'Alzette ou de la Sûre, sauvetage héliporté par LAR), les coordonnées satellites brutes WGS84 (degrés décimaux) peuvent être source de confusion ou de mauvaise retranscription radio.

La version **1.2.0** intègre en exclusivité un **moteur géodésique complet de projection LUREF (EPSG:2169)**, le système officiel utilisé par l'Administration du Cadastre et de la Topographie (ACT) et le **112 CGDIS** :

### Rigueur Mathématique du Moteur Implémenté :
1. **Passage WGS84 $\rightarrow$ Hayford 1909** : Transformation géocentrique tridimensionnelle de Bursa-Wolf avec les paramètres officiels luxembourgeois :
   $$\begin{aligned}
   dX &= -193.0\,\text{m}, \quad dY = +13.7\,\text{m}, \quad dZ = -39.3\,\text{m} \\
   rX &= -0.41'', \quad rY = -2.933'', \quad rZ = +2.688'' \\
   \text{Facteur d'échelle } s &= +0.43 \times 10^{-6}
   \end{aligned}$$
2. **Projection Transverse Mercator (Gauss-Luxembourg)** :
   $$\text{Méridien central } \lambda_0 = 6^\circ 10' 00''\,\text{E}, \quad \text{Origine de latitude } \phi_0 = 49^\circ 50' 00''\,\text{N}$$
   $$\text{Faux Est (FE)} = 80\,000.0\,\text{m}, \quad \text{Faux Nord (FN)} = 100\,000.0\,\text{m}, \quad k_0 = 1.0$$
3. **Validation par Vecteurs de Test Officiels** :
   * *Place Guillaume II (Luxembourg-Ville)* : $49.6116^\circ\,\text{N}, 6.1319^\circ\,\text{E} \longrightarrow \mathbf{Est = 77\,450\,\text{m}}, \quad \mathbf{Nord = 75\,458\,\text{m}}$ (Conformité absolue avec `map.geoportail.lu`).

### Dispositif Opérationnel pour le Citoyen :
* **Phrase Phonétique 112 Standardisée** prête à lire à haute voix sans hésitation :
  > *« 112 CGDIS : Je suis localisé au Luxembourg. Coordonnées LUREF Est : 77 450 m, Nord : 75 458 m (Précision : ±5m). »*
* **Bouton Copie Rapide** & **SMS de Secours Prérempli** adressé directement au 112.
* **Convertisseur Manuel Bidirectionnel** accessible aux secouristes et citoyens sans réseau.

---

## 4. Accessibilité Universelle & Inclusion Multilingue

Le Grand-Duché de Luxembourg se caractérise par une démographie internationale où plus de 47% de la population résidente est de nationalité étrangère. 

Pour garantir une protection civile véritablement inclusive, l'application est **intégralement traduite et contextualisée en 7 langues** :
1. 🇱🇺 **Lëtzebuergesch** : Langue nationale et ciment civique du Grand-Duché.
2. 🇫🇷 **Français** : Langue administrative officielle et langue d'intervention du CGDIS.
3. 🇩🇪 **Deutsch** : Langue officielle et de référence de la presse écrite.
4. 🇵🇹 **Português** : Première communauté linguistique résidente du pays (~15% de la population).
5. 🇬🇧 **English** : Langue d'usage de la communauté financière et des institutions européennes.
6. 🇪🇸 **Español** & 🇮🇹 **Italiano** : Communautés significatives du pays et des travailleurs frontaliers.

### Synthèse Vocale Apaisante Embarquée (*Voice Guide*) :
Pour les personnes malvoyantes, âgées ou prises au piège dans un environnement enfumé, un module de lecture audio hors-ligne déclame les consignes de sécurité à un rythme mesuré (taux de 0.48x), favorisant le calme et la prise de décision lucide.

---

## 5. Architecture de Sécurité & Respect Absolu du RGPD

L'application a été conçue selon le paradigme du **Privacy by Design** le plus strict :

* **Aucune Collecte de Données** : Pas de compte utilisateur, pas de formulaire en ligne, pas de cookies, pas d'ID publicitaire (`IDFA` / `GAID` désactivés).
* **Zéro Télémétrie Cloud** : L'application n'envoie aucune requête à des serveurs distants pour son fonctionnement ordinaire.
* **Fiche Médicale ICE Locale** : Les données vitales (groupe sanguin, numéro de matricule CNS à 13 chiffres, allergies graves) sont converties en image de fond d'écran directement dans le processeur graphique du smartphone, sans jamais quitter l'appareil.
* **Partage Familial P2P via QR Code** : L'échange de données entre les membres d'une même famille utilise le protocole local `MG72H:` sans transit par internet.

---

## 6. Objet de la Demande adressée au Gouvernement & au HCPN

Dans le cadre de l'évaluation en cours par les services de l'État luxembourgeois, le porteur de projet sollicite humblement :

1. **L'Aval Institutionnel & Patronage d'Honneur** : Reconnaissance officielle de *Mon Guide 72h* en tant qu'application citoyenne recommandée en appui de la stratégie *« Lëtz prepare ! »*.
2. **L'Autorisation d'Usage du Label Officiel** : Possibilité d'afficher le blason ou la signature visuelle officielle du Grand-Duché de Luxembourg attestant de l'alignement des protocoles avec les normes du HCPN et du CGDIS.
3. **Canal de Concertation Technique** : Possibilité de recevoir en amont les éventuelles mises à jour de doctrines ou de brochures afin d'actualiser immédiatement les algorithmes de l'application.

---

### Déclaration d'Engagement Civique
*« En tant que citoyen et développeur résident au Grand-Duché de Luxembourg, je m'engage solennellement à maintenir cette application gratuite, sans publicité et au service exclusif de la protection des résidents et de la résilience nationale. »*

**Renato Reis**  
Fondateur INFOREIS  
Grand-Duché de Luxembourg  
Contact officiel : `info@inforeis.eu` | [https://www.inforeis.eu](https://www.inforeis.eu)
