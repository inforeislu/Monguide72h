package lu.gouvernement.monguide72h.viewmodels

import android.content.Context
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.graphics.pdf.PdfDocument
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import lu.gouvernement.monguide72h.models.EmergencyPlan
import lu.gouvernement.monguide72h.models.HouseholdMember
import lu.gouvernement.monguide72h.models.MedicalEntry
import lu.gouvernement.monguide72h.models.NeighborContact
import lu.gouvernement.monguide72h.models.PetEntry
import java.io.File
import java.io.FileOutputStream

class EmergencyPlanViewModel(private val context: Context? = null) : ViewModel() {
    val plan = mutableStateOf(EmergencyPlan())

    val members = mutableStateListOf<HouseholdMember>()
    val medicalList = mutableStateListOf<MedicalEntry>()
    val pets = mutableStateListOf<PetEntry>()
    val neighborsGiving = mutableStateListOf<NeighborContact>()
    val neighborsNeeding = mutableStateListOf<NeighborContact>()

    init {
        members.add(HouseholdMember())
    }

    fun addMember() {
        members.add(HouseholdMember())
    }

    fun removeMember(index: Int) {
        if (index in members.indices) {
            members.removeAt(index)
        }
    }

    fun addMedicalEntry() {
        medicalList.add(MedicalEntry())
    }

    fun removeMedicalEntry(index: Int) {
        if (index in medicalList.indices) {
            medicalList.removeAt(index)
        }
    }

    fun addPet() {
        pets.add(PetEntry())
    }

    fun removePet(index: Int) {
        if (index in pets.indices) {
            pets.removeAt(index)
        }
    }

    fun addNeighbor(type: String) {
        if (type == "give") {
            neighborsGiving.add(NeighborContact(helpType = "give"))
        } else {
            neighborsNeeding.add(NeighborContact(helpType = "receive"))
        }
    }

    fun removeNeighbor(type: String, index: Int) {
        if (type == "give") {
            if (index in neighborsGiving.indices) neighborsGiving.removeAt(index)
        } else {
            if (index in neighborsNeeding.indices) neighborsNeeding.removeAt(index)
        }
    }

    /**
     * Generates a clean A4 PDF of the emergency plan and saves it locally.
     */
    fun exportPDF(): File? {
        val ctx = context ?: return null
        val pdfDocument = PdfDocument()
        val pageInfo = PdfDocument.PageInfo.Builder(595, 842, 1).create() // A4 at 72dpi
        val page = pdfDocument.startPage(pageInfo)
        val canvas = page.canvas

        val titlePaint = Paint().apply {
            color = Color.rgb(0, 43, 73) // Lux Blue
            textSize = 15f
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
        }

        val sectionPaint = Paint().apply {
            color = Color.rgb(234, 21, 44) // Lux Red
            textSize = 12f
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
        }

        val textPaint = Paint().apply {
            color = Color.rgb(30, 41, 59)
            textSize = 10f
            typeface = Typeface.DEFAULT
        }

        val boldPaint = Paint().apply {
            color = Color.BLACK
            textSize = 10f
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
        }

        var y = 40f
        canvas.drawText("LËTZ PREPARE ! — PLAN PERSONNEL D'URGENCE", 40f, y, titlePaint)
        y += 20f

        val currentPlan = plan.value
        val owner = if (currentPlan.ownerName.isNotBlank()) currentPlan.ownerName else "Famille"
        canvas.drawText("Responsable : $owner  |  ${currentPlan.address}, ${currentPlan.city}", 40f, y, textPaint)
        y += 25f

        // 1. Members
        canvas.drawText("1. HABITANTS DU FOYER", 40f, y, sectionPaint)
        y += 15f
        for ((idx, m) in members.withIndex()) {
            val name = if (m.fullName.isNotBlank()) m.fullName else "Membre ${idx + 1}"
            canvas.drawText("• $name | Tél: ${m.phone} | Matricule: ${m.matricule} | Groupe: ${m.bloodGroup}", 50f, y, textPaint)
            y += 14f
        }
        y += 10f

        // Medical
        if (medicalList.isNotEmpty()) {
            canvas.drawText("SANTÉ & ALLERGIES", 40f, y, sectionPaint)
            y += 15f
            for (med in medicalList) {
                canvas.drawText("• ${med.personName}: ${med.allergies} | Médicaments: ${med.medications} (${med.dosage})", 50f, y, textPaint)
                y += 14f
            }
            y += 10f
        }

        // 2. Installations
        canvas.drawText("2. INSTALLATIONS DU DOMICILE", 40f, y, sectionPaint)
        y += 15f
        canvas.drawText("• Robinet général d'eau : ${currentPlan.waterValveLocation.ifEmpty { "—" }}", 50f, y, textPaint)
        y += 14f
        canvas.drawText("• Vanne générale de gaz : ${currentPlan.gasValveLocation.ifEmpty { "—" }}", 50f, y, textPaint)
        y += 14f
        canvas.drawText("• Disjoncteur électrique : ${currentPlan.electricBreakerLocation.ifEmpty { "—" }}", 50f, y, textPaint)
        y += 14f
        canvas.drawText("• Extincteur : ${currentPlan.extinguisherLocation.ifEmpty { "—" }}", 50f, y, textPaint)
        y += 20f

        // 3. Meeting points
        canvas.drawText("3. POINTS DE RENCONTRE & ÉVACUATION", 40f, y, sectionPaint)
        y += 15f
        canvas.drawText("• Point 1 (Quartier) : ${currentPlan.meetingPoint1.ifEmpty { "—" }}", 50f, y, textPaint)
        y += 14f
        canvas.drawText("• Point 2 (Hors région) : ${currentPlan.meetingPoint2.ifEmpty { "—" }}", 50f, y, textPaint)
        y += 14f
        canvas.drawText("• Récupération enfants école : ${currentPlan.schoolPickupPerson.ifEmpty { "—" }}", 50f, y, textPaint)
        y += 20f

        // 4. Emergency Numbers
        canvas.drawText("4. NUMÉROS D'URGENCE (LUXEMBOURG)", 40f, y, sectionPaint)
        y += 15f
        canvas.drawText("• 112 : CGDIS (Secours & Pompiers)", 50f, y, boldPaint)
        y += 14f
        canvas.drawText("• 113 : Police Grand-Ducale", 50f, y, boldPaint)
        y += 14f
        canvas.drawText("• 8002 7788 : Info-Crise Gouvernemental", 50f, y, boldPaint)
        y += 14f
        canvas.drawText("• Radios d'urgence : RTL Radio (88.9 / 92.5 MHz) | Radio 100.7 FM", 50f, y, textPaint)

        pdfDocument.finishPage(page)

        val outputFile = File(ctx.cacheDir, "Plan_Urgence_72h.pdf")
        try {
            FileOutputStream(outputFile).use { out ->
                pdfDocument.writeTo(out)
            }
        } catch (_: Exception) {
            return null
        } finally {
            pdfDocument.close()
        }

        return outputFile
    }
}
