package lu.gouvernement.monguide72h.ui.screens

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import lu.gouvernement.monguide72h.localization.LocalizationManager
import lu.gouvernement.monguide72h.ui.theme.*

@Composable
fun GuidesHubScreen(
    onNavigateToOfflineReader: () -> Unit,
    onNavigateToRisks: () -> Unit,
    onNavigateToSirens: () -> Unit,
    onNavigateToTimeline: () -> Unit,
    onNavigateToRadios: () -> Unit,
    onNavigateToExpiry: () -> Unit,
    onNavigateToICE: () -> Unit
) {
    val context = LocalContext.current

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(DarkBackground)
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        contentPadding = PaddingValues(vertical = 16.dp)
    ) {
        // Section: Main Offline Guide Featured Card
        item {
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onNavigateToOfflineReader() },
                colors = CardDefaults.cardColors(containerColor = LuxBlue),
                shape = RoundedCornerShape(14.dp)
            ) {
                Column(modifier = Modifier.padding(18.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Surface(
                            color = LuxRed,
                            shape = RoundedCornerShape(6.dp)
                        ) {
                            Text(
                                text = LocalizationManager.tr("offline_tag"),
                                color = Color.White,
                                fontSize = 10.sp,
                                fontWeight = FontWeight.Bold,
                                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                            )
                        }
                        Icon(
                            imageVector = Icons.Default.ArrowForward,
                            contentDescription = "Open",
                            tint = LuxLightBlue
                        )
                    }

                    Spacer(modifier = Modifier.height(10.dp))

                    Text(
                        text = LocalizationManager.tr("offline_guide_title"),
                        color = Color.White,
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold
                    )

                    Spacer(modifier = Modifier.height(4.dp))

                    Text(
                        text = LocalizationManager.tr("offline_guide_sub"),
                        color = Color(0xFFCBD5E1),
                        fontSize = 13.sp,
                        lineHeight = 18.sp
                    )
                }
            }
        }

        // Section Title: Guides and Tools
        item {
            Text(
                text = LocalizationManager.tr("hub_guides_title"),
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )
        }

        // Item 1: Fichas de Riscos
        item {
            HubItemCard(
                icon = Icons.Default.Warning,
                iconColor = LuxRed,
                title = LocalizationManager.tr("tab_risks"),
                desc = LocalizationManager.tr("hub_risks_desc"),
                onClick = onNavigateToRisks
            )
        }

        // Item 2: Alertas & Sirenes
        item {
            HubItemCard(
                icon = Icons.Default.NotificationsActive,
                iconColor = LuxLightBlue,
                title = LocalizationManager.tr("tab_sirens"),
                desc = LocalizationManager.tr("hub_sirens_desc"),
                onClick = onNavigateToSirens
            )
        }

        // Item 3: Cenário 72h
        item {
            HubItemCard(
                icon = Icons.Default.Schedule,
                iconColor = OrangeWarning,
                title = LocalizationManager.tr("tab_timeline"),
                desc = LocalizationManager.tr("hub_timeline_desc"),
                onClick = onNavigateToTimeline
            )
        }

        // Item 4: Frequências Rádio de Emergência (FM / DAB+)
        item {
            HubItemCard(
                icon = Icons.Default.Radio,
                iconColor = LuxLightBlue,
                title = "Réseau Radio d'Urgence",
                desc = "Fréquences officielles RTL 88.9 / 92.5 MHz et radio publique en cas de blackout télécom.",
                onClick = onNavigateToRadios
            )
        }

        // Item 5: Rastreador de Validades
        item {
            HubItemCard(
                icon = Icons.Default.HourglassTop,
                iconColor = Color(0xFF22C55E),
                title = "Suivi des Péremptions du Kit",
                desc = "Rotation de l'eau, des conserves et des piles pour maintenir votre kit prêt à tout moment.",
                onClick = onNavigateToExpiry
            )
        }

        // Item 6: Ficha Médica ICE
        item {
            HubItemCard(
                icon = Icons.Default.MedicalServices,
                iconColor = LuxRed,
                title = "Fiche Médicale d'Urgence (ICE)",
                desc = "Groupe sanguin, matricule CNS, allergies et contacts prioritaires pour les secours (112).",
                onClick = onNavigateToICE
            )
        }

        // Section Title: Portais Governamentais
        item {
            Text(
                text = LocalizationManager.tr("hub_sources_title"),
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )
        }

        // Portals Grid / Row
        item {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                PortalLinkRow(name = "LU-Alert — Système d'Alerte National", url = "https://lu-alert.lu", context = context)
                PortalLinkRow(name = "MétéoLux — Alertes Météorologiques", url = "https://meteolux.lu", context = context)
                PortalLinkRow(name = "Inondations.lu — Cotes de Crues en direct", url = "https://inondations.lu", context = context)
                PortalLinkRow(name = "CGDIS — Secours d'Urgence 112", url = "https://112.public.lu", context = context)
                PortalLinkRow(name = "Info-Crise — Portail du Gouvernement", url = "https://infocrise.lu", context = context)
            }
        }
    }
}

@Composable
fun HubItemCard(
    icon: ImageVector,
    iconColor: Color,
    title: String,
    desc: String,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() },
        colors = CardDefaults.cardColors(containerColor = DarkSurface),
        shape = RoundedCornerShape(12.dp)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(42.dp)
                    .clip(RoundedCornerShape(10.dp))
                    .background(DarkCard),
                contentAlignment = Alignment.Center
            ) {
                Icon(imageVector = icon, contentDescription = null, tint = iconColor, modifier = Modifier.size(24.dp))
            }

            Spacer(modifier = Modifier.width(14.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(text = title, fontSize = 15.sp, fontWeight = FontWeight.Bold, color = Color.White)
                Spacer(modifier = Modifier.height(2.dp))
                Text(text = desc, fontSize = 12.sp, color = TextSecondary)
            }

            Icon(Icons.Default.ChevronRight, contentDescription = "Next", tint = Color.Gray)
        }
    }
}

@Composable
fun PortalLinkRow(name: String, url: String, context: android.content.Context) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                context.startActivity(intent)
            },
        colors = CardDefaults.cardColors(containerColor = DarkCard),
        shape = RoundedCornerShape(8.dp)
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(text = name, fontSize = 13.sp, color = LuxLightBlue, modifier = Modifier.weight(1f))
            Icon(Icons.Default.OpenInNew, contentDescription = "External link", tint = Color.Gray, modifier = Modifier.size(16.dp))
        }
    }
}
