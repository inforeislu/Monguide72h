import Foundation

public struct HouseholdMember: Identifiable, Codable, Equatable {
    public var id = UUID()
    public var fullName: String = ""
    public var phone: String = ""
    public var matricule: String = ""
    public var bloodGroup: String = "A+"
    public var languages: String = ""
    public var physicalLimitations: String = ""
    public var supportNeeds: String = "" // wheelchair, prosthetic, etc.
    
    public init(fullName: String = "", phone: String = "", matricule: String = "", bloodGroup: String = "A+", languages: String = "", physicalLimitations: String = "", supportNeeds: String = "") {
        self.fullName = fullName
        self.phone = phone
        self.matricule = matricule
        self.bloodGroup = bloodGroup
        self.languages = languages
        self.physicalLimitations = physicalLimitations
        self.supportNeeds = supportNeeds
    }
}

public struct MedicalEntry: Identifiable, Codable, Equatable {
    public var id = UUID()
    public var personName: String = ""
    public var allergies: String = ""
    public var medications: String = ""
    public var dosage: String = ""
    
    public init(personName: String = "", allergies: String = "", medications: String = "", dosage: String = "") {
        self.personName = personName
        self.allergies = allergies
        self.medications = medications
        self.dosage = dosage
    }
}

public struct PetEntry: Identifiable, Codable, Equatable {
    public var id = UUID()
    public var species: String = ""
    public var name: String = ""
    public var info: String = ""
    
    public init(species: String = "", name: String = "", info: String = "") {
        self.species = species
        self.name = name
        self.info = info
    }
}

public struct NeighborContact: Identifiable, Codable, Equatable {
    public var id = UUID()
    public var name: String = ""
    public var helpType: String = "" // "give" or "receive"
    public var phone: String = ""
    public var address: String = ""
    
    public init(name: String = "", helpType: String = "", phone: String = "", address: String = "") {
        self.name = name
        self.helpType = helpType
        self.phone = phone
        self.address = address
    }
}
