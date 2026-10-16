package lu.gouvernement.monguide72h.ui.screens

import android.content.Intent
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.PictureAsPdf
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.content.FileProvider
import lu.gouvernement.monguide72h.localization.LocalizationManager
import lu.gouvernement.monguide72h.models.HouseholdMember
import lu.gouvernement.monguide72h.models.MedicalEntry
import lu.gouvernement.monguide72h.ui.theme.*
import lu.gouvernement.monguide72h.viewmodels.EmergencyPlanViewModel

@Composable
fun EmergencyPlanScreen(viewModel: EmergencyPlanViewModel) {
    val context = LocalContext.current
    val plan by viewModel.plan

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(DarkBackground)
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        contentPadding = PaddingValues(vertical = 16.dp)
    ) {
        // Title & Export Button
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = LocalizationManager.tr("tab_plan"),
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.White
                )

                Button(
                    onClick = {
                        val file = viewModel.exportPDF()
                        if (file != null && file.exists()) {
                            try {
                                val uri = FileProvider.getUriForFile(
                                    context,
                                    "${context.packageName}.fileprovider",
                                    file
                                )
                                val intent = Intent(Intent.ACTION_VIEW).apply {
                                    setDataAndType(uri, "application/pdf")
                                    flags = Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK
                                }
                                context.startActivity(intent)
                            } catch (e: Exception) {
                                Toast.makeText(context, "PDF généré: ${file.name}", Toast.LENGTH_SHORT).show()
                            }
                        }
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = LuxRed),
                    shape = RoundedCornerShape(8.dp)
                ) {
                    Icon(Icons.Default.PictureAsPdf, contentDescription = "PDF", modifier = Modifier.size(16.dp))
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(text = "PDF A4", fontSize = 12.sp, fontWeight = FontWeight.Bold)
                }
            }
        }

        // Section 1: Household Details
        item {
            PlanCard(title = LocalizationManager.tr("plan_identity")) {
                OutlinedTextField(
                    value = plan.ownerName,
                    onValueChange = { plan.ownerName = it },
                    label = { Text("Nom du responsable") },
                    modifier = Modifier.fillMaxWidth(),
                    colors = planTextFieldColors()
                )
                Spacer(modifier = Modifier.height(8.dp))
                OutlinedTextField(
                    value = plan.address,
                    onValueChange = { plan.address = it },
                    label = { Text("Adresse") },
                    modifier = Modifier.fillMaxWidth(),
                    colors = planTextFieldColors()
                )
                Spacer(modifier = Modifier.height(8.dp))
                OutlinedTextField(
                    value = plan.city,
                    onValueChange = { plan.city = it },
                    label = { Text("Commune / Ville") },
                    modifier = Modifier.fillMaxWidth(),
                    colors = planTextFieldColors()
                )
            }
        }

        // Section 2: Members
        item {
            PlanCard(
                title = LocalizationManager.tr("plan_members"),
                trailingAction = {
                    IconButton(onClick = { viewModel.addMember() }) {
                        Icon(Icons.Default.Add, contentDescription = "Add", tint = LuxLightBlue)
                    }
                }
            ) {
                viewModel.members.forEachIndexed { index, member ->
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(8.dp))
                            .background(DarkBackground)
                            .padding(12.dp)
                    ) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text(text = "Membre ${index + 1}", color = LuxLightBlue, fontWeight = FontWeight.Bold, fontSize = 13.sp)
                            if (viewModel.members.size > 1) {
                                IconButton(
                                    onClick = { viewModel.removeMember(index) },
                                    modifier = Modifier.size(24.dp)
                                ) {
                                    Icon(Icons.Default.Delete, contentDescription = "Delete", tint = Color.Gray, modifier = Modifier.size(16.dp))
                                }
                            }
                        }
                        Spacer(modifier = Modifier.height(6.dp))
                        OutlinedTextField(
                            value = member.fullName,
                            onValueChange = { member.fullName = it },
                            label = { Text("Nom complet") },
                            modifier = Modifier.fillMaxWidth(),
                            colors = planTextFieldColors()
                        )
                        Spacer(modifier = Modifier.height(6.dp))
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            OutlinedTextField(
                                value = member.phone,
                                onValueChange = { member.phone = it },
                                label = { Text("Téléphone") },
                                modifier = Modifier.weight(1f),
                                colors = planTextFieldColors()
                            )
                            OutlinedTextField(
                                value = member.bloodGroup,
                                onValueChange = { member.bloodGroup = it },
                                label = { Text("Groupe") },
                                modifier = Modifier.weight(0.6f),
                                colors = planTextFieldColors()
                            )
                        }
                    }
                    if (index < viewModel.members.lastIndex) {
                        Spacer(modifier = Modifier.height(10.dp))
                    }
                }
            }
        }

        // Section 3: Health & Allergies
        item {
            PlanCard(
                title = LocalizationManager.tr("plan_medical"),
                trailingAction = {
                    IconButton(onClick = { viewModel.addMedicalEntry() }) {
                        Icon(Icons.Default.Add, contentDescription = "Add", tint = LuxLightBlue)
                    }
                }
            ) {
                if (viewModel.medicalList.isEmpty()) {
                    Text(text = "Aucun traitement spécifique ajouté.", color = TextMuted, fontSize = 13.sp)
                } else {
                    viewModel.medicalList.forEachIndexed { index, med ->
                        Column(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(8.dp))
                                .background(DarkBackground)
                                .padding(12.dp)
                        ) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(text = "Entrée ${index + 1}", color = OrangeWarning, fontWeight = FontWeight.Bold, fontSize = 13.sp)
                                IconButton(
                                    onClick = { viewModel.removeMedicalEntry(index) },
                                    modifier = Modifier.size(24.dp)
                                ) {
                                    Icon(Icons.Default.Delete, contentDescription = "Delete", tint = Color.Gray, modifier = Modifier.size(16.dp))
                                }
                            }
                            Spacer(modifier = Modifier.height(6.dp))
                            OutlinedTextField(
                                value = med.personName,
                                onValueChange = { med.personName = it },
                                label = { Text("Nom de la personne") },
                                modifier = Modifier.fillMaxWidth(),
                                colors = planTextFieldColors()
                            )
                            Spacer(modifier = Modifier.height(6.dp))
                            OutlinedTextField(
                                value = med.allergies,
                                onValueChange = { med.allergies = it },
                                label = { Text("Allergies") },
                                modifier = Modifier.fillMaxWidth(),
                                colors = planTextFieldColors()
                            )
                            Spacer(modifier = Modifier.height(6.dp))
                            OutlinedTextField(
                                value = med.medications,
                                onValueChange = { med.medications = it },
                                label = { Text("Médicaments & Dosage") },
                                modifier = Modifier.fillMaxWidth(),
                                colors = planTextFieldColors()
                            )
                        }
                        if (index < viewModel.medicalList.lastIndex) {
                            Spacer(modifier = Modifier.height(10.dp))
                        }
                    }
                }
            }
        }

        // Section 4: Home Installations
        item {
            PlanCard(title = LocalizationManager.tr("plan_house")) {
                OutlinedTextField(
                    value = plan.waterValveLocation,
                    onValueChange = { plan.waterValveLocation = it },
                    label = { Text("Robinet d'arrêt d'eau général") },
                    modifier = Modifier.fillMaxWidth(),
                    colors = planTextFieldColors()
                )
                Spacer(modifier = Modifier.height(8.dp))
                OutlinedTextField(
                    value = plan.gasValveLocation,
                    onValueChange = { plan.gasValveLocation = it },
                    label = { Text("Vanne générale de gaz") },
                    modifier = Modifier.fillMaxWidth(),
                    colors = planTextFieldColors()
                )
                Spacer(modifier = Modifier.height(8.dp))
                OutlinedTextField(
                    value = plan.electricBreakerLocation,
                    onValueChange = { plan.electricBreakerLocation = it },
                    label = { Text("Disjoncteur électrique / Tableau") },
                    modifier = Modifier.fillMaxWidth(),
                    colors = planTextFieldColors()
                )
                Spacer(modifier = Modifier.height(8.dp))
                OutlinedTextField(
                    value = plan.extinguisherLocation,
                    onValueChange = { plan.extinguisherLocation = it },
                    label = { Text("Extincteur / Couverture anti-feu") },
                    modifier = Modifier.fillMaxWidth(),
                    colors = planTextFieldColors()
                )
            }
        }

        // Section 5: Meeting Points
        item {
            PlanCard(title = LocalizationManager.tr("plan_meet")) {
                OutlinedTextField(
                    value = plan.meetingPoint1,
                    onValueChange = { plan.meetingPoint1 = it },
                    label = { Text("Point de ralliement 1 (Quartier)") },
                    modifier = Modifier.fillMaxWidth(),
                    colors = planTextFieldColors()
                )
                Spacer(modifier = Modifier.height(8.dp))
                OutlinedTextField(
                    value = plan.meetingPoint2,
                    onValueChange = { plan.meetingPoint2 = it },
                    label = { Text("Point de ralliement 2 (Hors région)") },
                    modifier = Modifier.fillMaxWidth(),
                    colors = planTextFieldColors()
                )
                Spacer(modifier = Modifier.height(8.dp))
                OutlinedTextField(
                    value = plan.schoolPickupPerson,
                    onValueChange = { plan.schoolPickupPerson = it },
                    label = { Text("Personne autorisée à récupérer les enfants") },
                    modifier = Modifier.fillMaxWidth(),
                    colors = planTextFieldColors()
                )
            }
        }
    }
}

@Composable
fun PlanCard(
    title: String,
    trailingAction: @Composable (() -> Unit)? = null,
    content: @Composable ColumnScope.() -> Unit
) {
    Card(
        colors = CardDefaults.cardColors(containerColor = DarkSurface),
        shape = RoundedCornerShape(12.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(text = title, color = Color.White, fontSize = 15.sp, fontWeight = FontWeight.Bold)
                trailingAction?.invoke()
            }
            Spacer(modifier = Modifier.height(12.dp))
            content()
        }
    }
}

@Composable
fun planTextFieldColors() = OutlinedTextFieldDefaults.colors(
    focusedTextColor = Color.White,
    unfocusedTextColor = Color.White,
    focusedBorderColor = LuxLightBlue,
    unfocusedBorderColor = DarkCardBorder,
    focusedLabelColor = LuxLightBlue,
    unfocusedLabelColor = TextMuted,
    cursorColor = LuxLightBlue
)
