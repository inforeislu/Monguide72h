package lu.gouvernement.monguide72h

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import lu.gouvernement.monguide72h.ui.screens.MainScreen
import lu.gouvernement.monguide72h.ui.theme.DarkBackground
import lu.gouvernement.monguide72h.ui.theme.MonGuide72hTheme
import lu.gouvernement.monguide72h.viewmodels.EmergencyPlanViewModel
import lu.gouvernement.monguide72h.viewmodels.KitCalculatorViewModel
import lu.gouvernement.monguide72h.viewmodels.SirenAudioPlayer
import lu.gouvernement.monguide72h.viewmodels.TorchManager

class MainActivity : ComponentActivity() {

    private lateinit var torchManager: TorchManager
    private lateinit var sirenAudioPlayer: SirenAudioPlayer

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        torchManager = TorchManager(this)
        sirenAudioPlayer = SirenAudioPlayer()

        val kitViewModel = KitCalculatorViewModel(this)
        val planViewModel = EmergencyPlanViewModel(this)

        setContent {
            MonGuide72hTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = DarkBackground
                ) {
                    MainScreen(
                        kitViewModel = kitViewModel,
                        planViewModel = planViewModel,
                        torchManager = torchManager,
                        audioPlayer = sirenAudioPlayer
                    )
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        sirenAudioPlayer.stop()
        torchManager.setTorch(false)
    }
}
