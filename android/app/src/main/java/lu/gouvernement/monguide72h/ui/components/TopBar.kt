package lu.gouvernement.monguide72h.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FlashOff
import androidx.compose.material.icons.filled.FlashOn
import androidx.compose.material.icons.filled.Language
import androidx.compose.material.icons.filled.Lightbulb
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
import lu.gouvernement.monguide72h.models.AppLanguage
import lu.gouvernement.monguide72h.ui.theme.DarkCard
import lu.gouvernement.monguide72h.ui.theme.LuxBlue
import lu.gouvernement.monguide72h.ui.theme.LuxRed
import lu.gouvernement.monguide72h.viewmodels.TorchManager

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppTopBar(
    torchManager: TorchManager,
    isBlackoutMode: Boolean,
    onToggleBlackout: () -> Unit
) {
    var showLanguageMenu by remember { mutableStateOf(false) }
    val currentLang by LocalizationManager.currentLanguage
    val isTorchOn by torchManager.isTorchOn
    val isSOS by torchManager.isSOSMode

    Surface(
        color = LuxBlue,
        shadowElevation = 4.dp
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .statusBarsPadding()
                .padding(horizontal = 16.dp, vertical = 12.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Logo, Title and subtitle
                Row(
                    modifier = Modifier.weight(1f),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    androidx.compose.foundation.Image(
                        painter = androidx.compose.ui.res.painterResource(id = lu.gouvernement.monguide72h.R.drawable.app_logo),
                        contentDescription = "Logo",
                        modifier = Modifier
                            .size(38.dp)
                            .clip(RoundedCornerShape(8.dp))
                    )
                    Spacer(modifier = Modifier.width(10.dp))
                    Column {
                        Text(
                            text = LocalizationManager.tr("app_title"),
                            color = Color.White,
                            fontSize = 16.sp,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = LocalizationManager.tr("app_subtitle"),
                            color = Color(0xFF94A3B8),
                            fontSize = 11.sp
                        )
                    }
                }

                // Action buttons: Torch, SOS, Blackout, Language
                Row(
                    horizontalArrangement = Arrangement.spacedBy(6.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    // Torch
                    IconButton(
                        onClick = { torchManager.toggleTorch() },
                        modifier = Modifier
                            .size(36.dp)
                            .clip(CircleShape)
                            .background(if (isTorchOn) Color(0xFFF59E0B) else DarkCard)
                    ) {
                        Icon(
                            imageVector = if (isTorchOn) Icons.Default.FlashOn else Icons.Default.FlashOff,
                            contentDescription = "Torch",
                            tint = if (isTorchOn) Color.Black else Color.White,
                            modifier = Modifier.size(18.dp)
                        )
                    }

                    // SOS
                    Box(
                        modifier = Modifier
                            .height(32.dp)
                            .clip(RoundedCornerShape(16.dp))
                            .background(if (isSOS) LuxRed else DarkCard)
                            .clickable { torchManager.toggleSOS() }
                            .padding(horizontal = 8.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = "SOS",
                            color = Color.White,
                            fontSize = 11.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }

                    // Blackout
                    IconButton(
                        onClick = onToggleBlackout,
                        modifier = Modifier
                            .size(36.dp)
                            .clip(CircleShape)
                            .background(if (isBlackoutMode) Color.Black else DarkCard)
                    ) {
                        Icon(
                            imageVector = Icons.Default.Lightbulb,
                            contentDescription = "Blackout",
                            tint = if (isBlackoutMode) Color.Yellow else Color.White,
                            modifier = Modifier.size(18.dp)
                        )
                    }

                    // Language dropdown
                    Box {
                        TextButton(
                            onClick = { showLanguageMenu = true },
                            colors = ButtonDefaults.textButtonColors(contentColor = Color.White),
                            contentPadding = PaddingValues(horizontal = 6.dp)
                        ) {
                            Text(
                                text = "${currentLang.flag} ${currentLang.code.uppercase()}",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }

                        DropdownMenu(
                            expanded = showLanguageMenu,
                            onDismissRequest = { showLanguageMenu = false },
                            modifier = Modifier.background(DarkCard)
                        ) {
                            AppLanguage.entries.forEach { lang ->
                                DropdownMenuItem(
                                    text = {
                                        Text(
                                            text = "${lang.flag} ${lang.displayName}",
                                            color = Color.White,
                                            fontSize = 14.sp
                                        )
                                    },
                                    onClick = {
                                        LocalizationManager.setLanguage(lang)
                                        showLanguageMenu = false
                                    }
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}
