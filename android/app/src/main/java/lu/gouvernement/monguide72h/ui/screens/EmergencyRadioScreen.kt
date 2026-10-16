package lu.gouvernement.monguide72h.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Radio
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import lu.gouvernement.monguide72h.ui.theme.*

data class RadioStation(
    val name: String,
    val frequency: String,
    val coverage: String,
    val flag: String
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun EmergencyRadioScreen(onBack: () -> Unit) {
    val stations = listOf(
        RadioStation("RTL Radio Lëtzebuerg", "88.9 MHz", "Dudelange (Sud / Centre) • Émetteur National", "🇱🇺"),
        RadioStation("RTL Radio Lëtzebuerg", "92.5 MHz", "Hosingen (Nord / Éislek / Ardennes)", "🇱🇺"),
        RadioStation("Radio 100.7", "100.7 MHz", "Radio Publique • Bulletins Officiels Gouvernement", "🇱🇺"),
        RadioStation("Eldoradio", "105.0 MHz", "Luxembourg Ville & Région Centre", "🇱🇺"),
        RadioStation("France Info", "105.5 MHz", "Frontière Sud (Lorraine / Thionville)", "🇫🇷"),
        RadioStation("SWR3", "98.5 MHz", "Frontière Est (Trèves / Rhénanie)", "🇩🇪"),
        RadioStation("RTBF La Première", "96.4 MHz", "Frontière Ouest (Arlon / Wallonie)", "🇧🇪")
    )

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "Réseau Radio d'Urgence",
                        fontWeight = FontWeight.Bold,
                        fontSize = 18.sp,
                        color = Color.White
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Retour",
                            tint = Color.White
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = LuxBlue)
            )
        }
    ) { innerPadding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .background(DarkBackground)
                .padding(innerPadding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = LuxBlue),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Row(
                        modifier = Modifier.padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.Radio,
                            contentDescription = null,
                            tint = LuxLightBlue,
                            modifier = Modifier.size(36.dp)
                        )
                        Spacer(modifier = Modifier.width(14.dp))
                        Column {
                            Text(
                                text = "Canal d'Information Prioritaire",
                                color = Color.White,
                                fontWeight = FontWeight.Bold,
                                fontSize = 15.sp
                            )
                            Spacer(modifier = Modifier.height(2.dp))
                            Text(
                                text = "En cas de panne d'électricité ou saturation 4G/5G, les émetteurs FM restent opérationnels sur groupes électrogènes de secours.",
                                color = Color(0xFFCBD5E1),
                                fontSize = 12.sp,
                                lineHeight = 16.sp
                            )
                        }
                    }
                }
            }

            items(stations) { station ->
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = DarkSurface),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = "${station.flag} ${station.name}",
                                color = Color.White,
                                fontWeight = FontWeight.Bold,
                                fontSize = 15.sp
                            )
                            Spacer(modifier = Modifier.height(2.dp))
                            Text(
                                text = station.coverage,
                                color = Color.Gray,
                                fontSize = 12.sp
                            )
                        }

                        Surface(
                            color = LuxBlue,
                            shape = RoundedCornerShape(20.dp)
                        ) {
                            Text(
                                text = station.frequency,
                                color = LuxLightBlue,
                                fontWeight = FontWeight.ExtraBold,
                                fontSize = 13.sp,
                                modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp)
                            )
                        }
                    }
                }
            }

            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = Color(0xFF1E293B)),
                    shape = RoundedCornerShape(10.dp)
                ) {
                    Text(
                        text = "💡 Règle de crise : Les bulletins officiels du gouvernement luxembourgeois sont diffusés à chaque heure pile et à la demi-heure. Éteignez votre radio entre deux bulletins pour économiser les piles alcalines.",
                        color = Color(0xFF94A3B8),
                        fontSize = 12.sp,
                        lineHeight = 16.sp,
                        modifier = Modifier.padding(14.dp)
                    )
                }
            }
        }
    }
}
