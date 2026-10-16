package lu.gouvernement.monguide72h.ui.screens

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Call
import androidx.compose.material.icons.filled.MedicalServices
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import lu.gouvernement.monguide72h.ui.theme.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MedicalICEScreen(onBack: () -> Unit) {
    val context = LocalContext.current

    var fullName by remember { mutableStateOf("Résident Luxembourg") }
    var bloodType by remember { mutableStateOf("O+") }
    var cnsNumber by remember { mutableStateOf("1985 04 12 12345") }
    var allergies by remember { mutableStateOf("Pénicilline (critique)") }
    var medications by remember { mutableStateOf("Insuline quotidienne, Inhalateur") }
    var contact1Name by remember { mutableStateOf("Marie Dupont (Conjointe)") }
    var contact1Tel by remember { mutableStateOf("+352 691 123 456") }
    var contact2Name by remember { mutableStateOf("Paul Dupont (Frère)") }
    var contact2Tel by remember { mutableStateOf("+352 621 987 654") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "Fiche Médicale d'Urgence (ICE)",
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
                colors = TopAppBarDefaults.topAppBarColors(containerColor = LuxRed)
            )
        }
    ) { innerPadding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .background(DarkBackground)
                .padding(innerPadding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            // Notice Banner
            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = LuxRed),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Row(
                        modifier = Modifier.padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Icon(
                            imageVector = Icons.Default.MedicalServices,
                            contentDescription = null,
                            tint = Color.White,
                            modifier = Modifier.size(36.dp)
                        )
                        Spacer(modifier = Modifier.width(14.dp))
                        Column {
                            Text(
                                text = "ACCÈS SECOURS D'URGENCE (112)",
                                color = Color.White,
                                fontWeight = FontWeight.Black,
                                fontSize = 14.sp
                            )
                            Spacer(modifier = Modifier.height(2.dp))
                            Text(
                                text = "Données médicales vitales consultables immédiatement par les pompiers / SAMU.",
                                color = Color(0xFFFFE4E6),
                                fontSize = 12.sp,
                                lineHeight = 16.sp
                            )
                        }
                    }
                }
            }

            // Blood Type Card
            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = DarkSurface),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Surface(
                            color = LuxRed,
                            shape = RoundedCornerShape(12.dp)
                        ) {
                            Text(
                                text = bloodType,
                                color = Color.White,
                                fontWeight = FontWeight.Black,
                                fontSize = 32.sp,
                                modifier = Modifier.padding(horizontal = 20.dp, vertical = 10.dp)
                            )
                        }

                        Spacer(modifier = Modifier.width(16.dp))

                        Column {
                            Text(
                                text = "GROUPE SANGUIN VITAL",
                                color = Color.Gray,
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Bold
                            )
                            Text(
                                text = fullName,
                                color = Color.White,
                                fontWeight = FontWeight.Bold,
                                fontSize = 17.sp
                            )
                            Text(
                                text = "Matricule CNS : $cnsNumber",
                                color = LuxLightBlue,
                                fontSize = 12.sp
                            )
                        }
                    }
                }
            }

            // Medical details
            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = DarkSurface),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Column(
                        modifier = Modifier.padding(16.dp),
                        verticalArrangement = Arrangement.spacedBy(10.dp)
                    ) {
                        Text(
                            text = "⚠️ ALLERGIES CRITIQUES",
                            color = OrangeWarning,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp
                        )
                        Text(
                            text = allergies,
                            color = Color.White,
                            fontSize = 14.sp,
                            fontWeight = FontWeight.SemiBold
                        )

                        Divider(color = Color(0xFF334155))

                        Text(
                            text = "💊 TRAITEMENTS VITAUX QUOTIDIENS",
                            color = LuxLightBlue,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp
                        )
                        Text(
                            text = medications,
                            color = Color.White,
                            fontSize = 14.sp,
                            fontWeight = FontWeight.SemiBold
                        )
                    }
                }
            }

            // Emergency Contacts with Dial Intent
            item {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = DarkSurface),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Column(
                        modifier = Modifier.padding(16.dp),
                        verticalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        Text(
                            text = "📞 CONTACTS D'URGENCE (ICE)",
                            color = LuxRed,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp
                        )

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Column {
                                Text(text = "ICE 1 : $contact1Name", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                                Text(text = contact1Tel, color = Color.Gray, fontSize = 12.sp)
                            }
                            IconButton(
                                onClick = {
                                    val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:${contact1Tel.replace(" ", "")}"))
                                    context.startActivity(intent)
                                }
                            ) {
                                Icon(imageVector = Icons.Default.Call, contentDescription = "Appeler", tint = Color(0xFF22C55E))
                            }
                        }

                        Divider(color = Color(0xFF334155))

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Column {
                                Text(text = "ICE 2 : $contact2Name", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                                Text(text = contact2Tel, color = Color.Gray, fontSize = 12.sp)
                            }
                            IconButton(
                                onClick = {
                                    val intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:${contact2Tel.replace(" ", "")}"))
                                    context.startActivity(intent)
                                }
                            ) {
                                Icon(imageVector = Icons.Default.Call, contentDescription = "Appeler", tint = Color(0xFF22C55E))
                            }
                        }
                    }
                }
            }
        }
    }
}
