package lu.gouvernement.monguide72h.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import lu.gouvernement.monguide72h.localization.LocalizationManager
import lu.gouvernement.monguide72h.ui.theme.*

@Composable
fun ScenarioTimelineScreen(onBack: () -> Unit) {
    val steps = listOf(
        TimelineStepData(
            period = "0h – 12h",
            title = "L'Alerte & La Sécurisation Immédiate",
            color = LuxRed,
            actions = listOf(
                "Restez calme et mettez immédiatement votre famille à l'abri à domicile.",
                "Allumez la radio à piles sur RTL (88.9/92.5 MHz) ou Radio 100.7 FM.",
                "Remplissez les éviers, baignoires et bouteilles vides d'eau tant que la pression persiste.",
                "Vérifiez que votre téléphone est chargé et activez le mode économie d'énergie extrême.",
                "Ne saturez pas les lignes 112/113 avec des appels de simple curiosité."
            )
        ),
        TimelineStepData(
            period = "12h – 24h",
            title = "L'Organisation du Foyer dans la Nuit",
            color = OrangeWarning,
            actions = listOf(
                "Regroupez-vous dans une seule pièce bien isolée pour conserver la chaleur corporelle.",
                "Utilisez vos lampes LED à faible intensité plutôt que des bougies sans surveillance.",
                "Consommez en priorité les aliments périssables du réfrigérateur.",
                "N'ouvrez pas inutilement le congélateur (conserve le froid pendant 24 à 48h fermé).",
                "Fermez rideaux et volets pour limiter les déperditions thermiques."
            )
        ),
        TimelineStepData(
            period = "24h – 48h",
            title = "La Gestion des Ressources & Solidarité",
            color = LuxLightBlue,
            actions = listOf(
                "Rationnez l'eau potable à raison de 3L par personne par jour.",
                "Préparez des repas simples à l'aide de votre réchaud de camping en zone aérée.",
                "Prenez des nouvelles de vos voisins vulnérables, personnes âgées ou isolées.",
                "Si la téléphonie est coupée, consultez le Point de Ralliement d'Urgence (PRU) communal."
            )
        ),
        TimelineStepData(
            period = "48h – 72h+",
            title = "La Résilience Consolidée & Préparation",
            color = GreenSuccess,
            actions = listOf(
                "Maintenez une écoute régulière des bulletins d'information officiels.",
                "Évitez de consommer l'eau du robinet sans autorisation officielle de potabilité.",
                "Préparez le redémarrage progressif sans créer de surtensions sur le réseau électrique.",
                "Réapprovisionnez dès que possible les éléments consommés de votre kit 72h."
            )
        )
    )

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(DarkBackground)
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        contentPadding = PaddingValues(vertical = 16.dp)
    ) {
        // Back Header
        item {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth()
            ) {
                IconButton(onClick = onBack) {
                    Icon(Icons.Default.ArrowBack, contentDescription = "Back", tint = Color.White)
                }
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = LocalizationManager.tr("tab_timeline"),
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.White
                )
            }
        }

        items(steps.size) { index ->
            val step = steps[index]
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
                        Surface(
                            color = step.color,
                            shape = RoundedCornerShape(6.dp)
                        ) {
                            Text(
                                text = step.period,
                                color = Color.White,
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Bold,
                                modifier = Modifier.padding(horizontal = 8.dp, vertical = 3.dp)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(10.dp))

                    Text(
                        text = step.title,
                        fontSize = 15.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )

                    Spacer(modifier = Modifier.height(10.dp))

                    step.actions.forEach { action ->
                        Row(modifier = Modifier.padding(vertical = 3.dp)) {
                            Text(text = "✓", color = step.color, fontWeight = FontWeight.Bold, modifier = Modifier.padding(end = 8.dp))
                            Text(text = action, color = TextPrimary, fontSize = 13.sp, lineHeight = 18.sp)
                        }
                    }
                }
            }
        }
    }
}

data class TimelineStepData(
    val period: String,
    val title: String,
    val color: Color,
    val actions: List<String>
)
