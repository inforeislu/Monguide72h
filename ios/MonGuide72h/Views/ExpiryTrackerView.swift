import SwiftUI

public struct ExpiryTrackerView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @ObservedObject var kitVM: KitCalculatorViewModel
    @ObservedObject var notifManager = ExpiryNotificationManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedItemForDate: KitItem? = nil
    @State private var tempDate = Date()
    @State private var showingDatePickerSheet = false
    
    public init(kitVM: KitCalculatorViewModel = KitCalculatorViewModel()) {
        self.kitVM = kitVM
    }
    
    public var body: some View {
        NavigationView {
            List {
                // Section: Notification status
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "bell.badge.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(loc.tr("expiry_alert_title"))
                                .font(.headline)
                            Text(loc.tr("expiry_alert_desc"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // Section: Items with Expiration Tracking
                Section(header: Text(loc.tr("expiry_section_items"))) {
                    let perishableItems = kitVM.items.filter { $0.defaultCategory == "Alimenter" || $0.id.contains("water") || $0.id.contains("battery") || $0.id.contains("meds") }
                    
                    if perishableItems.isEmpty {
                        Text(loc.tr("expiry_empty"))
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(perishableItems) { item in
                            Button(action: {
                                selectedItemForDate = item
                                tempDate = item.expiryDate ?? Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date()
                                showingDatePickerSheet = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(loc.tr(item.titleKey))
                                            .font(.subheadline.bold())
                                            .foregroundColor(.primary)
                                        
                                        if let exp = item.expiryDate {
                                            HStack(spacing: 4) {
                                                Image(systemName: "calendar")
                                                    .font(.caption2)
                                                Text(dateFormatter.string(from: exp))
                                                    .font(.caption)
                                                
                                                if exp < Date() {
                                                    Text(loc.tr("expiry_expired"))
                                                        .font(.system(size: 9, weight: .bold))
                                                        .padding(.horizontal, 4)
                                                        .padding(.vertical, 1)
                                                        .background(Color.red)
                                                        .foregroundColor(.white)
                                                        .cornerRadius(3)
                                                } else if exp < Calendar.current.date(byAdding: .day, value: 30, to: Date())! {
                                                    Text(loc.tr("expiry_soon"))
                                                        .font(.system(size: 9, weight: .bold))
                                                        .padding(.horizontal, 4)
                                                        .padding(.vertical, 1)
                                                        .background(Color.orange)
                                                        .foregroundColor(.white)
                                                        .cornerRadius(3)
                                                }
                                            }
                                            .foregroundColor(.secondary)
                                        } else {
                                            Text(loc.tr("expiry_not_set"))
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(loc.tr("tab_expiry"))
            .navigationBarItems(trailing: Button("Fechar") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingDatePickerSheet) {
                if let item = selectedItemForDate {
                    datePickerSheet(for: item)
                }
            }
        }
    }
    
    private func datePickerSheet(for item: KitItem) -> some View {
        NavigationView {
            Form {
                Section(header: Text(loc.tr("expiry_edit_title"))) {
                    Text(loc.tr(item.titleKey))
                        .font(.headline)
                    
                    DatePicker(
                        loc.tr("expiry_select_date"),
                        selection: $tempDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section {
                    Button(loc.tr("expiry_save")) {
                        saveDate(for: item, date: tempDate)
                        showingDatePickerSheet = false
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    
                    if item.expiryDate != nil {
                        Button(loc.tr("expiry_remove"), role: .destructive) {
                            saveDate(for: item, date: nil)
                            showingDatePickerSheet = false
                        }
                    }
                }
            }
            .navigationTitle(loc.tr("expiry_modal_title"))
            .navigationBarItems(trailing: Button(loc.tr("common_cancel")) {
                showingDatePickerSheet = false
            })
        }
    }
    
    private func saveDate(for item: KitItem, date: Date?) {
        if let idx = kitVM.items.firstIndex(where: { $0.id == item.id }) {
            kitVM.items[idx].expiryDate = date
            if let d = date {
                notifManager.scheduleExpiryAlert(for: item.id, itemName: loc.tr(item.titleKey), expiryDate: d)
            } else {
                notifManager.cancelNotification(for: item.id)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }
}
