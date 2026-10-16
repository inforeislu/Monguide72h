package lu.gouvernement.monguide72h.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import lu.gouvernement.monguide72h.localization.LocalizationManager
import lu.gouvernement.monguide72h.ui.components.AppTopBar
import lu.gouvernement.monguide72h.ui.theme.*
import lu.gouvernement.monguide72h.viewmodels.EmergencyPlanViewModel
import lu.gouvernement.monguide72h.viewmodels.KitCalculatorViewModel
import lu.gouvernement.monguide72h.viewmodels.SirenAudioPlayer
import lu.gouvernement.monguide72h.viewmodels.TorchManager

enum class MainTab(val titleKey: String, val icon: ImageVector) {
    KIT("tab_kit", Icons.Default.Inventory2),
    BAG("tab_bag", Icons.Default.Backpack),
    PLAN("tab_plan", Icons.Default.Assignment),
    HUB("tab_hub", Icons.Default.Shield)
}

enum class SubScreen {
    NONE,
    OFFLINE_READER,
    RISKS,
    SIRENS,
    TIMELINE,
    RADIOS,
    EXPIRY,
    ICE_CARD
}

@Composable
fun MainScreen(
    kitViewModel: KitCalculatorViewModel,
    planViewModel: EmergencyPlanViewModel,
    torchManager: TorchManager,
    audioPlayer: SirenAudioPlayer
) {
    var selectedTab by remember { mutableStateOf(MainTab.KIT) }
    var currentSubScreen by remember { mutableStateOf(SubScreen.NONE) }
    var isBlackoutMode by remember { mutableStateOf(false) }

    val isTorchOn by torchManager.isTorchOn

    // If Blackout mode is active: 100% true black OLED screen
    if (isBlackoutMode) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color.Black)
                .statusBarsPadding()
                .padding(24.dp),
            contentAlignment = Alignment.Center
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(20.dp)
            ) {
                Text(
                    text = "MODE BLACKOUT (OLED 100% NOIR)",
                    color = Color.White,
                    fontWeight = FontWeight.Bold,
                    fontSize = 18.sp
                )

                Text(
                    text = "Économie maximale d'énergie en cas de panne électrique générale.",
                    color = Color.Gray,
                    fontSize = 13.sp
                )

                Button(
                    onClick = { torchManager.toggleTorch() },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = if (isTorchOn) Color(0xFFF59E0B) else Color(0xFF1E293B)
                    ),
                    shape = RoundedCornerShape(10.dp)
                ) {
                    Icon(
                        imageVector = if (isTorchOn) Icons.Default.FlashOn else Icons.Default.FlashOff,
                        contentDescription = "Torch",
                        tint = if (isTorchOn) Color.Black else Color.White
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = if (isTorchOn) "Éteindre Lampe" else "Allumer Lampe Torche",
                        color = if (isTorchOn) Color.Black else Color.White
                    )
                }

                OutlinedButton(
                    onClick = { isBlackoutMode = false },
                    colors = ButtonDefaults.outlinedButtonColors(contentColor = Color.White),
                    shape = RoundedCornerShape(10.dp)
                ) {
                    Text(text = LocalizationManager.tr("exit_blackout"))
                }
            }
        }
        return
    }

    Scaffold(
        topBar = {
            AppTopBar(
                torchManager = torchManager,
                isBlackoutMode = isBlackoutMode,
                onToggleBlackout = { isBlackoutMode = !isBlackoutMode }
            )
        },
        bottomBar = {
            NavigationBar(
                containerColor = LuxBlue,
                contentColor = Color.White
            ) {
                MainTab.entries.forEach { tab ->
                    val isSelected = selectedTab == tab && currentSubScreen == SubScreen.NONE
                    NavigationBarItem(
                        selected = isSelected,
                        onClick = {
                            selectedTab = tab
                            currentSubScreen = SubScreen.NONE
                        },
                        icon = {
                            Icon(
                                imageVector = tab.icon,
                                contentDescription = LocalizationManager.tr(tab.titleKey)
                            )
                        },
                        label = {
                            Text(
                                text = LocalizationManager.tr(tab.titleKey),
                                fontSize = 11.sp,
                                fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal
                            )
                        },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = Color.White,
                            selectedTextColor = Color.White,
                            unselectedIconColor = Color(0xFF94A3B8),
                            unselectedTextColor = Color(0xFF94A3B8),
                            indicatorColor = LuxLightBlue
                        )
                    )
                }
            }
        }
    ) { innerPadding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
        ) {
            when (currentSubScreen) {
                SubScreen.OFFLINE_READER -> OfflineGuideReaderScreen(onBack = { currentSubScreen = SubScreen.NONE })
                SubScreen.RISKS -> RisksGuideScreen(onBack = { currentSubScreen = SubScreen.NONE })
                SubScreen.SIRENS -> SirensScreen(audioPlayer = audioPlayer, onBack = { currentSubScreen = SubScreen.NONE })
                SubScreen.TIMELINE -> ScenarioTimelineScreen(onBack = { currentSubScreen = SubScreen.NONE })
                SubScreen.RADIOS -> EmergencyRadioScreen(onBack = { currentSubScreen = SubScreen.NONE })
                SubScreen.EXPIRY -> ExpiryTrackerScreen(onBack = { currentSubScreen = SubScreen.NONE })
                SubScreen.ICE_CARD -> MedicalICEScreen(onBack = { currentSubScreen = SubScreen.NONE })
                SubScreen.NONE -> {
                    when (selectedTab) {
                        MainTab.KIT -> KitCalculatorScreen(viewModel = kitViewModel)
                        MainTab.BAG -> EvacuationBagScreen()
                        MainTab.PLAN -> EmergencyPlanScreen(viewModel = planViewModel)
                        MainTab.HUB -> GuidesHubScreen(
                            onNavigateToOfflineReader = { currentSubScreen = SubScreen.OFFLINE_READER },
                            onNavigateToRisks = { currentSubScreen = SubScreen.RISKS },
                            onNavigateToSirens = { currentSubScreen = SubScreen.SIRENS },
                            onNavigateToTimeline = { currentSubScreen = SubScreen.TIMELINE },
                            onNavigateToRadios = { currentSubScreen = SubScreen.RADIOS },
                            onNavigateToExpiry = { currentSubScreen = SubScreen.EXPIRY },
                            onNavigateToICE = { currentSubScreen = SubScreen.ICE_CARD }
                        )
                    }
                }
            }
        }
    }
}
