package lu.gouvernement.monguide72h.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material.icons.filled.Info
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

@Composable
fun EvacuationBagScreen() {
    val bagItems = remember {
        listOf(
            "bag_water",
            "bag_food",
            "bag_meds",
            "bag_phone",
            "bag_wallet",
            "bag_keys",
            "bag_powerbank",
            "bag_plan",
            "bag_firstaid",
            "bag_hygiene",
            "bag_clothes"
        )
    }

    val checkedStates = remember { mutableStateMapOf<String, Boolean>() }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(DarkBackground)
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(14.dp),
        contentPadding = PaddingValues(vertical = 16.dp)
    ) {
        // Title
        item {
            Text(
                text = LocalizationManager.tr("bag_items"),
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )
        }

        // Official Recommendation Card
        item {
            Card(
                colors = CardDefaults.cardColors(containerColor = DarkSurface),
                shape = RoundedCornerShape(12.dp)
            ) {
                Row(
                    modifier = Modifier.padding(16.dp),
                    verticalAlignment = Alignment.Top
                ) {
                    Icon(
                        imageVector = Icons.Default.Info,
                        contentDescription = "Info",
                        tint = LuxLightBlue,
                        modifier = Modifier.size(24.dp)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                    Column {
                        Text(
                            text = LocalizationManager.tr("bag_recom"),
                            color = Color.White,
                            fontWeight = FontWeight.Bold,
                            fontSize = 14.sp
                        )
                        Spacer(modifier = Modifier.height(4.dp))
                        Text(
                            text = LocalizationManager.tr("bag_desc"),
                            color = TextSecondary,
                            fontSize = 13.sp,
                            lineHeight = 18.sp
                        )
                    }
                }
            }
        }

        // Checklist items
        items(bagItems) { key ->
            val isChecked = checkedStates[key] == true
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { checkedStates[key] = !isChecked },
                colors = CardDefaults.cardColors(
                    containerColor = if (isChecked) Color(0xFF142E28) else DarkCard
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
                            .background(if (isChecked) GreenSuccess else DarkSurface)
                            .padding(2.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        if (isChecked) {
                            Icon(
                                imageVector = Icons.Default.Check,
                                contentDescription = "Checked",
                                tint = Color.Black,
                                modifier = Modifier.size(16.dp)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.width(12.dp))

                    Text(
                        text = LocalizationManager.tr(key),
                        fontSize = 14.sp,
                        fontWeight = if (isChecked) FontWeight.Normal else FontWeight.Medium,
                        color = if (isChecked) Color(0xFF86EFAC) else Color.White,
                        modifier = Modifier.weight(1f)
                    )
                }
            }
        }
    }
}
