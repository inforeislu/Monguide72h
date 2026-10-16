import SwiftUI

public struct KitCalculatorView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @StateObject var vm = KitCalculatorViewModel()
    @State private var showingShareSheet = false
    @State private var showingExpiryTracker = false
    @State private var pdfURLToShare: URL? = nil
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Household Composition Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text(loc.tr("calc_title"))
                            .font(.headline)
                            .foregroundColor(Color(red: 0/255, green: 43/255, blue: 73/255))
                        
                        counterRow(label: loc.tr("adults"), value: $vm.adults, minVal: 1)
                        counterRow(label: loc.tr("children"), value: $vm.children, minVal: 0)
                        counterRow(label: loc.tr("babies"), value: $vm.babies, minVal: 0)
                        counterRow(label: loc.tr("pets"), value: $vm.pets, minVal: 0)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Results Summary Strip
                    HStack(spacing: 12) {
                        // Water
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(vm.totalWaterLitres) L")
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.blue)
                            Text(loc.tr("water_vital"))
                                .font(.subheadline.bold())
                            Text("~ \(vm.totalWaterBottles) \(loc.tr("bottles_rec"))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                        
                        // Food
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(vm.totalMeals)")
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.orange)
                            Text(loc.tr("food_vital"))
                                .font(.subheadline.bold())
                            Text("Conserves / Repas")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Readiness Progress Bar
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Niveau de préparation du kit")
                                .font(.subheadline.bold())
                            Spacer()
                            Text("\(Int(vm.progressPercentage * 100))%")
                                .font(.subheadline.bold())
                                .foregroundColor(vm.progressPercentage >= 0.8 ? .green : .orange)
                        }
                        ProgressView(value: vm.progressPercentage)
                            .accentColor(vm.progressPercentage >= 0.8 ? .green : .orange)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // Quick Action Buttons (Validades & PDF)
                    HStack(spacing: 10) {
                        Button(action: { showingExpiryTracker = true }) {
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.subheadline)
                                Text("Validades")
                                    .font(.subheadline.bold())
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button(action: exportPDF) {
                            HStack {
                                Image(systemName: "printer.fill")
                                    .font(.subheadline)
                                Text("Imprimir PDF")
                                    .font(.subheadline.bold())
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(red: 0/255, green: 43/255, blue: 73/255))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    
                    // Checklist Items
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(loc.tr("checklist_title"))
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                        
                        ForEach(vm.items) { item in
                            Button(action: { vm.toggleItem(item.id) }) {
                                HStack(spacing: 12) {
                                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundColor(item.isChecked ? .green : .secondary)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(loc.tr("item_\(item.id)"))
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                            .strikethrough(item.isChecked, color: .secondary)
                                            .multilineTextAlignment(.leading)
                                        
                                        if let exp = item.expiryDate {
                                            Text("Validade: \(formattedDate(exp))")
                                                .font(.caption2)
                                                .foregroundColor(exp < Date() ? .red : .secondary)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 6)
                            }
                            Divider()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .padding()
                .padding(.bottom, 60)
            }
            .navigationTitle(loc.tr("tab_kit"))
            .sheet(isPresented: $showingShareSheet) {
                if let url = pdfURLToShare {
                    ShareSheet(activityItems: [url])
                }
            }
            .sheet(isPresented: $showingExpiryTracker) {
                ExpiryTrackerView(kitVM: vm)
            }
        }
    }
    
    private func counterRow(label: String, value: Binding<Int>, minVal: Int) -> some View {
        HStack {
            Text(label)
                .font(.body.weight(.medium))
            Spacer()
            HStack(spacing: 16) {
                Button(action: {
                    if value.wrappedValue > minVal {
                        value.wrappedValue -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title3)
                        .foregroundColor(value.wrappedValue > minVal ? Color(red: 0/255, green: 43/255, blue: 73/255) : .secondary)
                }
                .disabled(value.wrappedValue <= minVal)
                
                Text("\(value.wrappedValue)")
                    .font(.headline)
                    .frame(minWidth: 24)
                
                Button(action: {
                    value.wrappedValue += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color(red: 0/255, green: 43/255, blue: 73/255))
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: loc.currentLanguage.rawValue)
        return formatter.string(from: date)
    }
    
    private func exportPDF() {
        let planVM = EmergencyPlanViewModel()
        let bagKeys = Set(UserDefaults.standard.array(forKey: "mon_guide_72h_evacuation_bag_checked") as? [String] ?? [])
        if let url = PDFExportManager.shared.generateCompleteEmergencyDossier(
            plan: planVM.plan,
            kitVM: vm,
            bagCheckedKeys: bagKeys,
            language: loc.currentLanguage
        ) {
            self.pdfURLToShare = url
            self.showingShareSheet = true
        }
    }
}
