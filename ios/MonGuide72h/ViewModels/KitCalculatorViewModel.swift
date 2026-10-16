import Foundation
import SwiftUI
import Combine

public class KitCalculatorViewModel: ObservableObject {
    @AppStorage("calc_adults") public var adults: Int = 2
    @AppStorage("calc_children") public var children: Int = 1
    @AppStorage("calc_babies") public var babies: Int = 0
    @AppStorage("calc_pets") public var pets: Int = 1
    public let days: Int = 3
    
    @Published public var items: [KitItem] = []
    
    private let storageKey = "mon_guide_72h_kit_items"
    
    public init() {
        loadItems()
    }
    
    public var totalPersons: Int {
        adults + children + babies
    }
    
    public var totalWaterLitres: Int {
        (totalPersons * 3 * days) + (pets * 1 * days)
    }
    
    public var totalWaterBottles: Int {
        Int(ceil(Double(totalWaterLitres) / 1.5))
    }
    
    public var totalMeals: Int {
        totalPersons * 3 * days
    }
    
    public var progressPercentage: Double {
        guard !items.isEmpty else { return 0 }
        let completed = items.filter { $0.isChecked }.count
        return Double(completed) / Double(items.count)
    }
    
    public func toggleItem(_ id: String) {
        if let idx = items.firstIndex(where: { $0.id == id }) {
            items[idx].isChecked.toggle()
            saveItems()
        }
    }
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([KitItem].self, from: data) {
            self.items = saved
        } else {
            self.items = defaultItems
            saveItems()
        }
    }
    
    public func saveItems() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
        WidgetDataManager.shared.refreshSnapshot()
    }
    
    private var defaultItems: [KitItem] {
        [
            // Alimentation & cuisine
            KitItem(id: "water", titleKey: "itemWater", defaultCategory: "Alimenter"),
            KitItem(id: "food", titleKey: "itemFood", defaultCategory: "Alimenter"),
            KitItem(id: "stove", titleKey: "itemStove", defaultCategory: "Alimenter"),
            KitItem(id: "utensils", titleKey: "itemUtensils", defaultCategory: "Alimenter"),
            
            // Chaleur & Éclairage
            KitItem(id: "warmth", titleKey: "itemWarmth", defaultCategory: "Chaleur"),
            KitItem(id: "torch", titleKey: "itemTorch", defaultCategory: "Lumière"),
            KitItem(id: "candles", titleKey: "itemCandles", defaultCategory: "Lumière"),
            
            // Santé & Hygiène
            KitItem(id: "firstaid", titleKey: "itemFirstAid", defaultCategory: "Santé"),
            KitItem(id: "meds", titleKey: "itemMeds", defaultCategory: "Santé"),
            KitItem(id: "iodine", titleKey: "itemIodine", defaultCategory: "Santé"),
            KitItem(id: "hygiene", titleKey: "itemHygiene", defaultCategory: "Santé"),
            
            // Communication & Documents
            KitItem(id: "radio", titleKey: "itemRadio", defaultCategory: "Info"),
            KitItem(id: "powerbank", titleKey: "itemPowerbank", defaultCategory: "Info"),
            KitItem(id: "cash", titleKey: "itemCash", defaultCategory: "Docs"),
            KitItem(id: "docs", titleKey: "itemDocs", defaultCategory: "Docs"),
            KitItem(id: "planpaper", titleKey: "itemPlanPaper", defaultCategory: "Docs")
        ]
    }
}
