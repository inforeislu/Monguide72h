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
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import lu.gouvernement.monguide72h.localization.LocalizationManager
import lu.gouvernement.monguide72h.ui.theme.*

@Composable
fun RisksGuideScreen(onBack: () -> Unit) {
    val risks = listOf(
        RiskCardData(
            emoji = "🌊",
            title = "Inondations & Crues Rapides",
            bullets = listOf(
                "Consultez les cotes de crue en temps réel sur inondations.lu.",
                "Déplacez les véhicules hors des zones inondables pendant qu'il est encore temps.",
                "Coupez l'électricité dans les sous-sols menacés avant la montée des eaux.",
                "Ne descendez JAMAIS dans une cave ou un garage souterrain inondé.",
                "Ne traversez jamais une route inondée, même en 4x4 (risque d'emportement)."
            ),
            alert = "DANGER : L'eau en contact avec des installations électriques provoque des électrocutions mortelles."
        ),
        RiskCardData(
            emoji = "🌪️",
            title = "Tempêtes & Vents Violents",
            bullets = listOf(
                "Mettez à l'abri ou arrimez le mobilier de jardin, trampolines et poubelles.",
                "Fermez portes, fenêtres et volets extérieurs.",
                "Évitez impérativement les zones boisées et les parcs (chutes de branches).",
                "Ne touchez jamais à des câbles électriques tombés au sol."
            ),
            alert = null
        ),
        RiskCardData(
            emoji = "💻",
            title = "Cyberattaques & Escroqueries",
            bullets = listOf(
                "Vérifiez l'expéditeur de chaque SMS et e-mail demandant des actions urgentes.",
                "Activez l'authentification à deux facteurs (2FA) sur tous vos comptes bancaires et e-mails.",
                "Conservez une sauvegarde hors ligne (disque dur déconnecté) de vos fichiers cruciaux.",
                "En cas d'escroquerie, bloquez vos cartes immédiatement via votre banque ou Worldline."
            ),
            alert = null
        ),
        RiskCardData(
            emoji = "☢️",
            title = "Accident Nucléaire & Iode",
            bullets = listOf(
                "Entrez dans le bâtiment en dur le plus proche et fermez hermétiquement portes et fenêtres.",
                "Coupez impérativement toute ventilation mécanique et climatisation.",
                "Écoutez la radio (RTL 88.9/92.5 ou 100.7) pour les consignes gouvernementales.",
                "Les comprimés d'iode de potassium ne doivent être pris QUE sur ordre formel des autorités (<45 ans)."
            ),
            alert = "ATTENTION : Ne prenez jamais de comprimés d'iode par anticipation ou sans ordre officiel !"
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
                    text = LocalizationManager.tr("tab_risks"),
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.White
                )
            }
        }

        items(risks.size) { index ->
            val risk = risks[index]
            Card(
                colors = CardDefaults.cardColors(containerColor = DarkSurface),
                shape = RoundedCornerShape(12.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(text = risk.emoji, fontSize = 24.sp)
                        Spacer(modifier = Modifier.width(10.dp))
                        Text(
                            text = risk.title,
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color.White
                        )
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    risk.bullets.forEach { point ->
                        Row(modifier = Modifier.padding(vertical = 3.dp)) {
                            Text(text = "•", color = LuxLightBlue, fontWeight = FontWeight.Bold, modifier = Modifier.padding(end = 8.dp))
                            Text(text = point, color = TextPrimary, fontSize = 13.sp, lineHeight = 18.sp)
                        }
                    }

                    if (risk.alert != null) {
                        Spacer(modifier = Modifier.height(10.dp))
                        Surface(
                            color = Color(0xFF451A1A),
                            shape = RoundedCornerShape(8.dp)
                        ) {
                            Text(
                                text = risk.alert,
                                color = Color(0xFFFCA5A5),
                                fontSize = 12.sp,
                                fontWeight = FontWeight.SemiBold,
                                modifier = Modifier.padding(10.dp)
                            )
                        }
                    }
                }
            }
        }
    }
}

data class RiskCardData(
    val emoji: String,
    val title: String,
    val bullets: List<String>,
    val alert: String?
)
