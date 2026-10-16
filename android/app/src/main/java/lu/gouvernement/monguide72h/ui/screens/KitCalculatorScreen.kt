package lu.gouvernement.monguide72h.ui.screens

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Remove
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import lu.gouvernement.monguide72h.localization.LocalizationManager
import lu.gouvernement.monguide72h.ui.theme.*
import lu.gouvernement.monguide72h.viewmodels.KitCalculatorViewModel

@Composable
fun KitCalculatorScreen(viewModel: KitCalculatorViewModel) {
    val progress by animateFloatAsState(targetValue = viewModel.progressPercentage, label = "progress")

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(DarkBackground)
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        contentPadding = PaddingValues(vertical = 16.dp)
    ) {
        // Title
        item {
            Text(
                text = LocalizationManager.tr("calc_title"),
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )
        }

        // Household Counters Card
        item {
            Card(
                colors = CardDefaults.cardColors(containerColor = DarkSurface),
                shape = RoundedCornerShape(12.dp)
            ) {
                Column(
                    modifier = Modifier.padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    CounterRow(
                        label = LocalizationManager.tr("adults"),
                        count = viewModel.adults.intValue,
                        onIncrement = { viewModel.setAdults(viewModel.adults.intValue + 1) },
                        onDecrement = { viewModel.setAdults(viewModel.adults.intValue - 1) }
                    )
                    Divider(color = DarkCardBorder)
                    CounterRow(
                        label = LocalizationManager.tr("children"),
                        count = viewModel.children.intValue,
                        onIncrement = { viewModel.setChildren(viewModel.children.intValue + 1) },
                        onDecrement = { viewModel.setChildren(viewModel.children.intValue - 1) }
                    )
                    Divider(color = DarkCardBorder)
                    CounterRow(
                        label = LocalizationManager.tr("babies"),
                        count = viewModel.babies.intValue,
                        onIncrement = { viewModel.setBabies(viewModel.babies.intValue + 1) },
                        onDecrement = { viewModel.setBabies(viewModel.babies.intValue - 1) }
                    )
                    Divider(color = DarkCardBorder)
                    CounterRow(
                        label = LocalizationManager.tr("pets"),
                        count = viewModel.pets.intValue,
                        onIncrement = { viewModel.setPets(viewModel.pets.intValue + 1) },
                        onDecrement = { viewModel.setPets(viewModel.pets.intValue - 1) }
                    )
                }
            }
        }

        // Summary Calculations Cards (Water & Food)
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                // Water Card
                Card(
                    modifier = Modifier.weight(1f),
                    colors = CardDefaults.cardColors(containerColor = DarkCard),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text(text = "💧 " + LocalizationManager.tr("water_vital"), fontSize = 12.sp, color = LuxLightBlue, fontWeight = FontWeight.Bold)
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(text = "${viewModel.totalWaterLitres} Litres", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Color.White)
                        Text(text = "≈ ${viewModel.totalWaterBottles} " + LocalizationManager.tr("bottles_rec"), fontSize = 12.sp, color = TextSecondary)
                    }
                }

                // Food Card
                Card(
                    modifier = Modifier.weight(1f),
                    colors = CardDefaults.cardColors(containerColor = DarkCard),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text(text = "🥫 " + LocalizationManager.tr("food_vital"), fontSize = 12.sp, color = OrangeWarning, fontWeight = FontWeight.Bold)
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(text = "${viewModel.totalMeals} Repas", fontSize = 22.sp, fontWeight = FontWeight.Bold, color = Color.White)
                        Text(text = "3 repas / jour × 3 jours", fontSize = 12.sp, color = TextSecondary)
                    }
                }
            }
        }

        // Progress Section
        item {
            Card(
                colors = CardDefaults.cardColors(containerColor = DarkSurface),
                shape = RoundedCornerShape(12.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text(text = LocalizationManager.tr("kit_progress"), fontSize = 13.sp, color = Color.White, fontWeight = FontWeight.Medium)
                        Text(text = "${(progress * 100).toInt()}%", fontSize = 13.sp, color = GreenSuccess, fontWeight = FontWeight.Bold)
                    }
                    Spacer(modifier = Modifier.height(8.dp))
                    LinearProgressIndicator(
                        progress = { progress },
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(8.dp)
                            .clip(RoundedCornerShape(4.dp)),
                        color = if (progress >= 1f) GreenSuccess else LuxLightBlue,
                        trackColor = DarkCardBorder
                    )
                }
            }
        }

        // Checklist Section Title
        item {
            Text(
                text = LocalizationManager.tr("checklist_title"),
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )
        }

        // Items list
        items(viewModel.items, key = { it.id }) { item ->
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { viewModel.toggleItem(item.id) },
                colors = CardDefaults.cardColors(
                    containerColor = if (item.isChecked) Color(0xFF142E28) else DarkSurface
                ),
                shape = RoundedCornerShape(10.dp)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(14.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(
                        modifier = Modifier
                            .size(24.dp)
                            .clip(RoundedCornerShape(6.dp))
                            .background(if (item.isChecked) GreenSuccess else DarkCard)
                            .padding(2.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        if (item.isChecked) {
                            Icon(
                                imageVector = Icons.Default.Check,
                                contentDescription = "Checked",
                                tint = Color.Black,
                                modifier = Modifier.size(16.dp)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.width(12.dp))

                    Column(modifier = Modifier.weight(1f)) {
                        Text(
                            text = LocalizationManager.tr(item.titleKey),
                            fontSize = 14.sp,
                            fontWeight = if (item.isChecked) FontWeight.Normal else FontWeight.Medium,
                            color = if (item.isChecked) Color(0xFF86EFAC) else Color.White
                        )
                        Text(
                            text = item.defaultCategory,
                            fontSize = 11.sp,
                            color = TextMuted
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun CounterRow(
    label: String,
    count: Int,
    onIncrement: () -> Unit,
    onDecrement: () -> Unit
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(text = label, color = Color.White, fontSize = 14.sp)
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            IconButton(
                onClick = onDecrement,
                modifier = Modifier
                    .size(32.dp)
                    .clip(RoundedCornerShape(6.dp))
                    .background(DarkCard)
            ) {
                Icon(Icons.Default.Remove, contentDescription = "Minus", tint = Color.White, modifier = Modifier.size(16.dp))
            }
            Text(text = "$count", color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.Bold)
            IconButton(
                onClick = onIncrement,
                modifier = Modifier
                    .size(32.dp)
                    .clip(RoundedCornerShape(6.dp))
                    .background(DarkCard)
            ) {
                Icon(Icons.Default.Add, contentDescription = "Plus", tint = Color.White, modifier = Modifier.size(16.dp))
            }
        }
    }
}
