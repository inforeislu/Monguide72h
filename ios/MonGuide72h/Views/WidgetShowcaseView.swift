import SwiftUI

public struct WidgetShowcaseView: View {
    @ObservedObject var widgetData = WidgetDataManager.shared
    @ObservedObject var tactical = TacticalModeManager.shared
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    private var isFR: Bool {
        loc.currentLanguage == .fr || loc.currentLanguage == .lu || loc.currentLanguage == .de
    }
    
    @State private var selectedTab: Int = 0 // 0 = Home Screen, 1 = Lock Screen
    @State private var simulatedScore: Double = 85
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Card
                    headerCard
                    
                    // Segmented Selector
                    Picker("Tipo de Widget", selection: $selectedTab) {
                        Text(isFR ? "Écran d’Accueil" : "Ecrã Principal (Home)").tag(0)
                        Text(isFR ? "Écran Verrouillé" : "Ecrã Bloqueado (Lock)").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    if selectedTab == 0 {
                        homeScreenWidgetsSection
                    } else {
                        lockScreenWidgetsSection
                    }
                    
                    // Interactive Simulation Slider
                    simulationControlCard
                    
                    // Installation Instructions
                    installationGuideCard
                }
                .padding(.vertical)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle(isFR ? "Widgets iOS & Écran Verrouillé" : "Widgets iOS & Ecrã Bloqueado")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(isFR ? "Fermer" : "Fechar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    // MARK: - HEADER CARD
    
    private var headerCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "apps.iphone")
                .font(.system(size: 38))
                .foregroundColor(tactical.isTacticalActive ? .red : Color(red: 0/255, green: 43/255, blue: 73/255))
            
            VStack(alignment: .leading, spacing: 3) {
                Text(isFR ? "Widgets de Préparation 72h" : "Widgets de Prontidão 72h")
                    .font(.headline.bold())
                Text("Aceda ao estado das reservas de água, alimentos e números de emergência do Luxemburgo diretamente no ecrã do iPhone sem abrir a aplicação.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(14)
        .padding(.horizontal)
    }
    
    // MARK: - HOME SCREEN WIDGETS SECTION
    
    private var homeScreenWidgetsSection: some View {
        VStack(spacing: 20) {
            // Small Widget
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(isFR ? "Petit Widget (1x1)" : "Widget Pequeno (1x1)")
                        .font(.subheadline.bold())
                    Spacer()
                    Text(isFR ? "Niveau de Préparation" : "Monitor de Prontidão")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                HStack {
                    Spacer()
                    SmallReadinessWidgetView(snapshot: activeSnapshot)
                        .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 4)
                    Spacer()
                }
            }
            
            // Medium Widget
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(isFR ? "Widget Moyen (2x1)" : "Widget Médio (2x1)")
                        .font(.subheadline.bold())
                    Spacer()
                    Text(isFR ? "Préparation + Raccourcis 112 / SOS" : "Prontidão + Botões 112 / SOS")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                HStack {
                    Spacer()
                    MediumEmergencyWidgetView(snapshot: activeSnapshot)
                        .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 4)
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - LOCK SCREEN WIDGETS SECTION
    
    private var lockScreenWidgetsSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text(isFR ? "Simulation sur Écran Verrouillé iOS" : "Simulação no Ecrã Bloqueado do iOS")
                    .font(.subheadline.bold())
                    .padding(.horizontal)
                
                // Simulated Lock Screen Strip
                ZStack {
                    // Dark frosted background representing iPhone lock screen wallpaper
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(white: 0.15))
                        .frame(height: 140)
                    
                    VStack(spacing: 12) {
                        // Clock Representation
                        Text("23:45")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                        
                        // Widgets Row
                        HStack(spacing: 18) {
                            LockScreenCircularWidgetView(score: Int(simulatedScore))
                            
                            LockScreenRectangularWidgetView(snapshot: activeSnapshot)
                                .frame(width: 170)
                        }
                    }
                }
                .padding(.horizontal)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 3)
            }
        }
    }
    
    // MARK: - SIMULATION CONTROLS
    
    private var simulationControlCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(tactical.isTacticalActive ? .red : .blue)
                Text(isFR ? "TESTER LES NIVEAUX DE PRÉPARATION" : "TESTAR NÍVEIS DE PRONTIDÃO")
                    .font(.caption.bold())
                Spacer()
                Text("\(Int(simulatedScore))%")
                    .font(.subheadline.bold())
                    .foregroundColor(tactical.isTacticalActive ? .red : .blue)
            }
            
            Slider(value: $simulatedScore, in: 0...100, step: 5)
                .accentColor(tactical.isTacticalActive ? .red : Color(red: 0/255, green: 43/255, blue: 73/255))
            
            HStack {
                Text("🔴 0% Desprevenido")
                Spacer()
                Text("🟠 50% Razoável")
                Spacer()
                Text("🟢 100% Protegido")
            }
            .font(.system(size: 10))
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(14)
        .padding(.horizontal)
    }
    
    // MARK: - INSTALLATION GUIDE
    
    private var installationGuideCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.orange)
                Text(isFR ? "COMMENT AJOUTER SUR VOTRE IPHONE" : "COMO ADICIONAR NO SEU IPHONE")
                    .font(.caption.bold())
            }
            
            instructionRow(num: "1", title: "No Ecrã de Início:", text: "Mantenha o dedo pressionado numa área vazia até os ícones começarem a abanar. Toque no botão «+» no canto superior esquerdo e pesquise por «Mon Guide 72h».")
            
            instructionRow(num: "2", title: "No Ecrã Bloqueado:", text: "Mantenha pressionado o ecrã bloqueado, toque em «Personalizar», escolha o ecrã bloqueado e adicione os widgets circular ou retangular abaixo do relógio.")
            
            instructionRow(num: "3", title: "Acesso Imediato:", text: "Em situação de crise ou queda de rede, toque diretamente no widget para aceder ao guia offline e números de emergência.")
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(14)
        .padding(.horizontal)
    }
    
    private func instructionRow(num: String, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(num)
                .font(.system(size: 11, weight: .black))
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color(red: 0/255, green: 43/255, blue: 73/255))
                .clipShape(Circle())
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.bold())
                Text(text)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var activeSnapshot: WidgetEmergencySnapshot {
        var s = widgetData.currentSnapshot
        s.readinessScore = Int(simulatedScore)
        s.isTacticalActive = tactical.isTacticalActive
        return s
    }
}
