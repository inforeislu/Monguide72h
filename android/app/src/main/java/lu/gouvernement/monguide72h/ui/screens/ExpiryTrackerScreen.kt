package lu.gouvernement.monguide72h.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.HourglassTop
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import lu.gouvernement.monguide72h.ui.theme.*
import java.time.LocalDate
import java.time.temporal.ChronoUnit

data class ExpiryItem(
    val name: String,
    val expiryDate: String // YYYY-MM-DD
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ExpiryTrackerScreen(onBack: () -> Unit) {
    var items by remember {
        mutableStateOf(
            listOf(
                ExpiryItem("Pack 6x 1.5L Eau minérale", LocalDate.now().plusMonths(12).toString()),
                ExpiryItem("Conserves (Thon, Légumes, Plats)", LocalDate.now().plusMonths(24).toString()),
                ExpiryItem("Piles alcalines AA & AAA (Radio / Torche)", LocalDate.now().plusMonths(36).toString()),
                ExpiryItem("Trousse premiers secours & Compresses", LocalDate.now().plusMonths(18).toString())
            )
        )
    }

    var showAddDialog by remember { mutableStateOf(false) }
    var newItemName by remember { mutableStateOf("") }
    var newItemDate by remember { mutableStateOf(LocalDate.now().plusMonths(6).toString()) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "Suivi des Péremptions du Kit",
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
                actions = {
                    IconButton(onClick = { showAddDialog = true }) {
                        Icon(
                            imageVector = Icons.Default.Add,
                            contentDescription = "Ajouter",
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
                            imageVector = Icons.Default.HourglassTop,
                            contentDescription = null,
                            tint = LuxLightBlue,
                            modifier = Modifier.size(36.dp)
                        )
                        Spacer(modifier = Modifier.width(14.dp))
                        Column {
                            Text(
                                text = "Rotation des Réserves 72h",
                                color = Color.White,
                                fontWeight = FontWeight.Bold,
                                fontSize = 15.sp
                            )
                            Spacer(modifier = Modifier.height(2.dp))
                            Text(
                                text = "Surveillez la péremption de l'eau et des aliments pour renouveler vos stocks avant expiration.",
                                color = Color(0xFFCBD5E1),
                                fontSize = 12.sp,
                                lineHeight = 16.sp
                            )
                        }
                    }
                }
            }

            itemsIndexed(items) { index, item ->
                val daysRemaining = try {
                    val exp = LocalDate.parse(item.expiryDate)
                    ChronoUnit.DAYS.between(LocalDate.now(), exp)
                } catch (e: Exception) {
                    0L
                }

                val (statusColor, statusBg, statusText) = when {
                    daysRemaining < 0 -> Triple(Color(0xFFEF4444), Color(0x33EF4444), "Périmé !")
                    daysRemaining <= 60 -> Triple(Color(0xFFF59E0B), Color(0x33F59E0B), "À renouveler (${daysRemaining}j)")
                    else -> Triple(Color(0xFF22C55E), Color(0x3322C55E), "Valide (${daysRemaining}j)")
                }

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
                                text = item.name,
                                color = Color.White,
                                fontWeight = FontWeight.Bold,
                                fontSize = 15.sp
                            )
                            Spacer(modifier = Modifier.height(4.dp))
                            Text(
                                text = "Date limite : ${item.expiryDate}",
                                color = Color.Gray,
                                fontSize = 12.sp
                            )
                            Spacer(modifier = Modifier.height(6.dp))
                            Surface(
                                color = statusBg,
                                shape = RoundedCornerShape(12.dp)
                            ) {
                                Text(
                                    text = statusText,
                                    color = statusColor,
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 11.sp,
                                    modifier = Modifier.padding(horizontal = 10.dp, vertical = 3.dp)
                                )
                            }
                        }

                        IconButton(
                            onClick = {
                                items = items.toMutableList().also { it.removeAt(index) }
                            }
                        ) {
                            Icon(
                                imageVector = Icons.Default.Delete,
                                contentDescription = "Supprimer",
                                tint = Color(0xFFEF4444)
                            )
                        }
                    }
                }
            }
        }
    }

    if (showAddDialog) {
        AlertDialog(
            onDismissRequest = { showAddDialog = false },
            title = { Text(text = "Ajouter une réserve", fontWeight = FontWeight.Bold) },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    OutlinedTextField(
                        value = newItemName,
                        onValueChange = { newItemName = it },
                        label = { Text("Nom du produit") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth()
                    )
                    OutlinedTextField(
                        value = newItemDate,
                        onValueChange = { newItemDate = it },
                        label = { Text("Date limite (AAAA-MM-JJ)") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth()
                    )
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        if (newItemName.isNotBlank() && newItemDate.isNotBlank()) {
                            items = items + ExpiryItem(newItemName.trim(), newItemDate.trim())
                            newItemName = ""
                            showAddDialog = false
                        }
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = LuxBlue)
                ) {
                    Text("Ajouter")
                }
            },
            dismissButton = {
                TextButton(onClick = { showAddDialog = false }) {
                    Text("Annuler")
                }
            }
        )
    }
}
