import SwiftUI

public struct EvacuationBagView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @State private var checkedItems: Set<String> = []
    @State private var showingShareSheet = false
    @State private var pdfURLToShare: URL? = nil
    
    private let storageKey = "mon_guide_72h_evacuation_bag_checked"
    
    private let bagItemKeys = [
        "bag_water",
        "bag_food",
        "bag_meds",
        "bag_phone",
        "bag_wallet",
        "bag_keys",
        "bag_powerbank",
        "bag_plan",
        "bag_firstaid",
        "bag_hygiene",
        "bag_clothes"
    ]
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            List {
                Section(header: Text(loc.tr("bag_recom"))) {
                    Text(loc.tr("bag_desc"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                }
                
                Section {
                    Button(action: exportPDF) {
                        HStack {
                            Image(systemName: "printer.fill")
                            Text(loc.tr("print_pdf"))
                                .bold()
                        }
                        .foregroundColor(Color(red: 0/255, green: 43/255, blue: 73/255))
                    }
                }
                
                Section(header: Text(loc.tr("bag_items"))) {
                    ForEach(bagItemKeys, id: \.self) { key in
                        Button(action: {
                            if checkedItems.contains(key) {
                                checkedItems.remove(key)
                            } else {
                                checkedItems.insert(key)
                            }
                            saveCheckedItems()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: checkedItems.contains(key) ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                                    .foregroundColor(checkedItems.contains(key) ? .green : .secondary)
                                
                                Text(loc.tr(key))
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .strikethrough(checkedItems.contains(key), color: .secondary)
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle(loc.tr("tab_bag"))
            .onAppear(perform: loadCheckedItems)
            .sheet(isPresented: $showingShareSheet) {
                if let url = pdfURLToShare {
                    ShareSheet(activityItems: [url])
                }
            }
        }
    }
    
    private func loadCheckedItems() {
        if let saved = UserDefaults.standard.array(forKey: storageKey) as? [String] {
            checkedItems = Set(saved)
        }
    }
    
    private func saveCheckedItems() {
        UserDefaults.standard.set(Array(checkedItems), forKey: storageKey)
        WidgetDataManager.shared.refreshSnapshot()
    }
    
    private func exportPDF() {
        let planVM = EmergencyPlanViewModel()
        let kitVM = KitCalculatorViewModel()
        if let url = PDFExportManager.shared.generateCompleteEmergencyDossier(
            plan: planVM.plan,
            kitVM: kitVM,
            bagCheckedKeys: checkedItems,
            language: loc.currentLanguage
        ) {
            self.pdfURLToShare = url
            self.showingShareSheet = true
        }
    }
}
