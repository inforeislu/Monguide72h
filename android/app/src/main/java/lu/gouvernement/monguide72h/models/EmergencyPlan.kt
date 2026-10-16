package lu.gouvernement.monguide72h.models

import java.util.Date

data class EmergencyPlan(
    var ownerName: String = "",
    var address: String = "",
    var city: String = "",
    var dateCompleted: Long = System.currentTimeMillis(),
    var dateUpdated: Long = System.currentTimeMillis(),

    var members: MutableList<HouseholdMember> = mutableListOf(HouseholdMember()),
    var medicalList: MutableList<MedicalEntry> = mutableListOf(),
    var pets: MutableList<PetEntry> = mutableListOf(),

    // Home installations
    var waterValveLocation: String = "",
    var gasValveLocation: String = "",
    var electricBreakerLocation: String = "",
    var extinguisherLocation: String = "",
    var garageManualInstructions: String = "",
    var escapeRoute: String = "",
    var homeNotes: String = "",

    // Meeting points
    var meetingPoint1: String = "",
    var meetingPoint2: String = "",
    var schoolPickupPerson: String = "",
    var outOfAreaContact: String = "",
    var emergencyShelterContact: String = "",
    var commuteAlternative: String = "",

    // Community
    var neighborsGivingHelp: MutableList<NeighborContact> = mutableListOf(),
    var neighborsNeedingHelp: MutableList<NeighborContact> = mutableListOf(),

    // Providers
    var telecomProvider: String = "",
    var electricityProvider: String = "",
    var gasProvider: String = "",
    var waterProvider: String = "",
    var insurancePolicy: String = "",
    var familyDoctor: String = "",
    var schoolPhone: String = "",
    var bankContact: String = ""
)

data class KitItem(
    val id: String,
    val titleKey: String,
    val defaultCategory: String,
    var isChecked: Boolean = false,
    var expiryDate: Long? = null
)
