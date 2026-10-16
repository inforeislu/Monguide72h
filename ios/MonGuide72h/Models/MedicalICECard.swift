import Foundation

public struct MedicalICECard: Codable, Equatable {
    public var fullName: String = ""
    public var cnsMatricule: String = ""
    public var birthDate: String = ""
    public var bloodGroup: String = "O+"
    public var allergies: String = ""
    public var medicalConditions: String = ""
    public var regularMedications: String = ""
    public var emergencyContactName: String = ""
    public var emergencyContactPhone: String = ""
    public var emergencyContactRelation: String = ""
    public var secondaryContactName: String = ""
    public var secondaryContactPhone: String = ""
    public var isOrganDonor: Bool = false
    public var notes: String = ""
    
    public init(
        fullName: String = "",
        cnsMatricule: String = "",
        birthDate: String = "",
        bloodGroup: String = "O+",
        allergies: String = "",
        medicalConditions: String = "",
        regularMedications: String = "",
        emergencyContactName: String = "",
        emergencyContactPhone: String = "",
        emergencyContactRelation: String = "",
        secondaryContactName: String = "",
        secondaryContactPhone: String = "",
        isOrganDonor: Bool = false,
        notes: String = ""
    ) {
        self.fullName = fullName
        self.cnsMatricule = cnsMatricule
        self.birthDate = birthDate
        self.bloodGroup = bloodGroup
        self.allergies = allergies
        self.medicalConditions = medicalConditions
        self.regularMedications = regularMedications
        self.emergencyContactName = emergencyContactName
        self.emergencyContactPhone = emergencyContactPhone
        self.emergencyContactRelation = emergencyContactRelation
        self.secondaryContactName = secondaryContactName
        self.secondaryContactPhone = secondaryContactPhone
        self.isOrganDonor = isOrganDonor
        self.notes = notes
    }
}
