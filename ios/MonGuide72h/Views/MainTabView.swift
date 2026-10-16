import SwiftUI

public struct MainTabView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @ObservedObject var countryManager = CountryManager.shared
    @StateObject private var torch = TorchManager.shared
    @ObservedObject var tactical = TacticalModeManager.shared
    @State private var selectedTab: Int = UserDefaults.standard.integer(forKey: "selectedTab")
    @State private var showingSOSSheet = UserDefaults.standard.bool(forKey: "showSOS")
    @State private var showingSirensSheet = UserDefaults.standard.bool(forKey: "showSirens")
    @State private var showingBlackoutSheet = false
    @State private var showingLanguagePicker = false
    @State private var showingCountryPicker = false
    
    public init() {
        // Ensure TabBar has a solid background to prevent awkward translucent text overlapping
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Persistent Emergency Top Strip & Quick Tools
            topEmergencyHeader
            
            TabView(selection: $selectedTab) {
                KitCalculatorView()
                    .tabItem {
                        Label(loc.tr("tab_kit"), systemImage: "archivebox.fill")
                    }
                    .tag(0)
                
                EvacuationBagView()
                    .tabItem {
                        Label(loc.tr("tab_bag"), systemImage: "backpack.fill")
                    }
                    .tag(1)
                
                EmergencyPlanView()
                    .tabItem {
                        Label(loc.tr("tab_plan"), systemImage: "list.clipboard.fill")
                    }
                    .tag(2)
                
                GuidesHubView()
                    .tabItem {
                        Label(loc.tr("tab_hub"), systemImage: "shield.lefthalf.filled")
                    }
                    .tag(3)
            }
            .accentColor(tactical.isTacticalActive ? Color.red : Color(red: 0/255, green: 43/255, blue: 73/255))
        }
        .preferredColorScheme(tactical.isTacticalActive ? .dark : nil)
        .sheet(isPresented: $showingSOSSheet) {
            EmergencySOSAlarmView()
        }
        .sheet(isPresented: $showingSirensSheet) {
            SirensView()
        }
        .fullScreenCover(isPresented: $showingBlackoutSheet) {
            TacticalNightVisionView()
        }
        .sheet(isPresented: $showingLanguagePicker) {
            languageSelectionSheet
        }
        .sheet(isPresented: $showingCountryPicker) {
            countrySelectionSheet
        }
    }
    
    // MARK: - TOP EMERGENCY HEADER
    
    private var topEmergencyHeader: some View {
        VStack(spacing: 8) {
            // Row 1: Logo, App Title & Global Preferences
            HStack(spacing: 8) {
                // Brand Logo & Badge
                HStack(spacing: 8) {
                    Text("🇪🇺")
                        .font(.system(size: 28))
                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        HStack(spacing: 4) {
                            Text("GUIDE 72H EUROPE")
                                .font(.system(size: 13, weight: .black, design: .rounded))
                                .foregroundColor(tactical.isTacticalActive ? .red : .white)
                            
                            if tactical.isTacticalActive {
                                Text("TÁTICO")
                                    .font(.system(size: 8, weight: .black))
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 1)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(3)
                            }
                        }
                        
                        Text("RÉSILIENCE CIVILE EU")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(tactical.isTacticalActive ? .gray : Color.yellow)
                    }
                }
                
                Spacer()
                
                // Country Switcher
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    showingCountryPicker = true
                }) {
                    HStack(spacing: 4) {
                        Text(countryManager.currentCountry.flag)
                            .font(.system(size: 14))
                        Text(countryManager.currentCountry.id.uppercased())
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 32)
                    .background(Color.white.opacity(tactical.isTacticalActive ? 0.08 : 0.18))
                    .cornerRadius(8)
                }
                .fixedSize(horizontal: true, vertical: false)
                
                // Language Switcher
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    showingLanguagePicker = true
                }) {
                    HStack(spacing: 4) {
                        Text(loc.currentLanguage.flag)
                            .font(.system(size: 14))
                        Text(loc.currentLanguage.rawValue.uppercased())
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 32)
                    .background(Color.white.opacity(tactical.isTacticalActive ? 0.08 : 0.18))
                    .cornerRadius(8)
                }
                .fixedSize(horizontal: true, vertical: false)
                
                // Tactical Night Vision & Red Lantern
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    showingBlackoutSheet = true
                }) {
                    Image(systemName: tactical.isTacticalActive ? "eye.trianglebadge.exclamationmark.fill" : "moon.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(tactical.isTacticalActive ? .red : .yellow)
                        .frame(width: 32, height: 32)
                        .background(tactical.isTacticalActive ? Color.red.opacity(0.25) : Color.white.opacity(0.18))
                        .clipShape(Circle())
                }
                .fixedSize(horizontal: true, vertical: true)
            }
            .padding(.horizontal, 12)
            .padding(.top, 4)
            
            // Row 2: HERO EMERGENCY ACTION ROW (SOS E LANTERNA GRANDES E DE FÁCIL ALCANCE)
            HStack(spacing: 8) {
                // 1. BOTÃO SOS HERO (GRANDE - ALARME DE CRISE & 112)
                Button(action: {
                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                    showingSOSSheet = true
                }) {
                    HStack(spacing: 6) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.25))
                                .frame(width: 24, height: 24)
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("SOS 112")
                                .font(.system(size: 13, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                            Text("Secours")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white.opacity(0.85))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color(red: 220/255, green: 38/255, blue: 38/255))
                    .cornerRadius(10)
                    .shadow(color: Color.red.opacity(0.4), radius: 3, x: 0, y: 2)
                }
                
                // 2. BOTÃO LANTERNA HERO (GRANDE - LIGA/DESLIGA IMEDIATO COM INDICAÇÃO VISUAL)
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    torch.toggleTorch()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: torch.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(torch.isTorchOn ? .black : (tactical.isTacticalActive ? .red : .yellow))
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(torch.isTorchOn ? "LUZ ATIVA" : "LANTERNA")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(torch.isTorchOn ? .black : .white)
                            Text(torch.isTorchOn ? "Toque p/ Desligar" : "LED Tocha")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(torch.isTorchOn ? .black.opacity(0.7) : .white.opacity(0.75))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(torch.isTorchOn ? Color.yellow : Color.white.opacity(tactical.isTacticalActive ? 0.12 : 0.2))
                    .cornerRadius(10)
                    .shadow(color: torch.isTorchOn ? Color.yellow.opacity(0.5) : Color.clear, radius: 4, x: 0, y: 1)
                }
                
                // 3. NÚMERO SECUNDÁRIO DO PAÍS
                Button(action: {
                    if let url = URL(string: "tel://\(countryManager.currentCountry.secondaryNumber)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    VStack(spacing: 1) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 11, weight: .bold))
                        Text(countryManager.currentCountry.secondaryNumber)
                            .font(.system(size: 11, weight: .black))
                    }
                    .frame(width: 58)
                    .frame(height: 42)
                    .background(Color(red: 30/255, green: 58/255, blue: 138/255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 2, x: 0, y: 1)
                }
                
                // 4. INFO CRISE / LINHA DE APOIO DO PAÍS
                Button(action: {
                    let num = countryManager.currentCountry.infoPortalNumberOrURL
                    if let url = URL(string: "tel://\(num)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    VStack(spacing: 1) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 11, weight: .bold))
                        Text(countryManager.currentCountry.infoPortalLabel)
                            .font(.system(size: 8, weight: .black))
                            .lineLimit(1)
                    }
                    .frame(width: 54)
                    .frame(height: 42)
                    .background(Color(red: 217/255, green: 119/255, blue: 6/255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.orange.opacity(0.3), radius: 2, x: 0, y: 1)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 6)
        }
        .background(
            (tactical.isTacticalActive ? Color.black : Color(red: 0/255, green: 43/255, blue: 73/255))
                .ignoresSafeArea(edges: .top)
        )
        .overlay(
            Rectangle()
                .fill(tactical.isTacticalActive ? Color.red.opacity(0.3) : Color.clear)
                .frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - COUNTRY SELECTION SHEET
    
    private var countrySelectionSheet: some View {
        NavigationView {
            List(CountryProfile.allCountries) { country in
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    countryManager.selectCountry(country)
                    showingCountryPicker = false
                }) {
                    HStack(spacing: 12) {
                        Text(country.flag)
                            .font(.system(size: 32))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(country.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("112 • \(country.secondaryLabel) (\(country.secondaryNumber))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(country.alertSystem)
                                .font(.system(size: 10))
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        if countryManager.currentCountry.id == country.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Pays / Country 🇪🇺")
            .navigationBarItems(trailing: Button(loc.tr("btn_close")) {
                showingCountryPicker = false
            })
        }
    }
    
    // MARK: - LANGUAGE SELECTION SHEET
    
    private var languageSelectionSheet: some View {
        NavigationView {
            List {
                Section(header: Text("Sélectionnez votre langue / Sprooch / Language")) {
                    ForEach(AppLanguage.allCases, id: \.self) { lang in
                        Button(action: {
                            loc.currentLanguage = lang
                            showingLanguagePicker = false
                        }) {
                            HStack {
                                Text(lang.flag)
                                    .font(.title2)
                                    .padding(.trailing, 8)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(lang.displayName)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(lang.rawValue.uppercased())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if loc.currentLanguage == lang {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.title3)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
            .navigationTitle("Langue")
            .navigationBarItems(trailing: Button(loc.tr("btn_close")) {
                showingLanguagePicker = false
            })
        }
    }
}
