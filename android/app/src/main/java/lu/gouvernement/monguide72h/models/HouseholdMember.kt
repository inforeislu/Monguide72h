package lu.gouvernement.monguide72h.models

import java.util.UUID

data class HouseholdMember(
    val id: String = UUID.randomUUID().toString(),
    var fullName: String = "",
    var phone: String = "",
    var matricule: String = "",
    var bloodGroup: String = "A+",
    var languages: String = "",
    var physicalLimitations: String = "",
    var supportNeeds: String = ""
)

data class MedicalEntry(
    val id: String = UUID.randomUUID().toString(),
    var personName: String = "",
    var allergies: String = "",
    var medications: String = "",
    var dosage: String = ""
)

data class PetEntry(
    val id: String = UUID.randomUUID().toString(),
    var species: String = "",
    var name: String = "",
    var info: String = ""
)

data class NeighborContact(
    val id: String = UUID.randomUUID().toString(),
    var name: String = "",
    var helpType: String = "", // "give" or "receive"
    var phone: String = "",
    var address: String = ""
)
