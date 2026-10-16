package lu.gouvernement.monguide72h.viewmodels

import android.content.Context
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class TorchManager(context: Context) {
    private val appContext = context.applicationContext
    private val cameraManager = appContext.getSystemService(Context.CAMERA_SERVICE) as? CameraManager
    private var cameraId: String? = null

    private val _isTorchOn = mutableStateOf(false)
    val isTorchOn: State<Boolean> = _isTorchOn

    private val _isSOSMode = mutableStateOf(false)
    val isSOSMode: State<Boolean> = _isSOSMode

    private var sosJob: Job? = null
    private val scope = CoroutineScope(Dispatchers.Main)

    private val sosPattern = listOf(
        true, false, true, false, true, false, false,
        true, true, true, false, true, true, true, false, true, true, true, false, false,
        true, false, true, false, true, false, false, false, false
    )

    init {
        try {
            cameraId = cameraManager?.cameraIdList?.firstOrNull()
        } catch (_: Exception) {}
    }

    fun toggleTorch() {
        if (_isSOSMode.value) {
            stopSOS()
        }
        setTorch(!_isTorchOn.value)
    }

    fun toggleSOS() {
        if (_isSOSMode.value) {
            stopSOS()
        } else {
            startSOS()
        }
    }

    fun setTorch(enabled: Boolean) {
        val cid = cameraId
        if (cid != null && cameraManager != null) {
            try {
                cameraManager.setTorchMode(cid, enabled)
                _isTorchOn.value = enabled
            } catch (_: CameraAccessException) {
                _isTorchOn.value = enabled
            } catch (_: Exception) {
                _isTorchOn.value = enabled
            }
        } else {
            // Emulated for preview / devices without camera
            _isTorchOn.value = enabled
        }
    }

    private fun startSOS() {
        _isSOSMode.value = true
        sosJob?.cancel()
        sosJob = scope.launch {
            var index = 0
            while (_isSOSMode.value) {
                val state = sosPattern[index % sosPattern.size]
                setTorch(state)
                index++
                delay(250)
            }
        }
    }

    private fun stopSOS() {
        _isSOSMode.value = false
        sosJob?.cancel()
        sosJob = null
        setTorch(false)
    }
}
