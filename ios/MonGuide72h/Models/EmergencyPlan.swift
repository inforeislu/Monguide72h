import Foundation

public struct EmergencyPlan: Codable, Equatable {
    public var ownerName: String = ""
    public var address: String = ""
    public var city: String = ""
    public var dateCompleted: Date = Date()
    public var dateUpdated: Date = Date()
    
    public var members: [HouseholdMember] = [HouseholdMember()]
    public var medicalList: [MedicalEntry] = []
    public var pets: [PetEntry] = []
    
    // Home installations
    public var waterValveLocation: String = ""
    public var gasValveLocation: String = ""
    public var electricBreakerLocation: String = ""
    public var extinguisherLocation: String = ""
    public var garageManualInstructions: String = ""
    public var escapeRoute: String = ""
    public var homeNotes: String = ""
    
    // Meeting Points
    public var meetingPoint1: String = ""
    public var meetingPoint2: String = ""
    public var schoolPickupPerson: String = ""
    public var outOfAreaContact: String = ""
    public var emergencyShelterContact: String = ""
    public var commuteAlternative: String = ""
    
    // Community
    public var neighborsGivingHelp: [NeighborContact] = []
    public var neighborsNeedingHelp: [NeighborContact] = []
    
    // Providers
    public var telecomProvider: String = ""
    public var electricityProvider: String = ""
    public var gasProvider: String = ""
    public var waterProvider: String = ""
    public var insurancePolicy: String = ""
    public var familyDoctor: String = ""
    public var schoolPhone: String = ""
    public var bankContact: String = ""
    
    public var allEmergencyPhoneNumbers: [(name: String, phone: String)] {
        var list: [(name: String, phone: String)] = []
        for m in members where !m.phone.trimmingCharacters(in: .whitespaces).isEmpty {
            list.append((m.fullName.isEmpty ? "Membro da Família" : m.fullName, m.phone))
        }
        for n in neighborsGivingHelp where !n.phone.trimmingCharacters(in: .whitespaces).isEmpty {
            list.append((n.name.isEmpty ? "Vizinho Solidário" : n.name, n.phone))
        }
        if !outOfAreaContact.trimmingCharacters(in: .whitespaces).isEmpty {
            list.append(("Contacto Fora da Área", outOfAreaContact))
        }
        return list
    }
    
    public init() {}
}

public struct KitItem: Identifiable, Codable, Equatable {
    public var id: String
    public var titleKey: String
    public var defaultCategory: String
    public var isChecked: Bool = false
    public var expiryDate: Date? = nil
    
    public init(id: String, titleKey: String, defaultCategory: String, isChecked: Bool = false, expiryDate: Date? = nil) {
        self.id = id
        self.titleKey = titleKey
        self.defaultCategory = defaultCategory
        self.isChecked = isChecked
        self.expiryDate = expiryDate
    }
}
