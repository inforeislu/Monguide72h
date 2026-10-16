package lu.gouvernement.monguide72h.viewmodels

import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import lu.gouvernement.monguide72h.models.SirenType
import kotlin.math.PI
import kotlin.math.sin

class SirenAudioPlayer {
    private val _currentPlaying = mutableStateOf<SirenType?>(null)
    val currentPlaying: State<SirenType?> = _currentPlaying

    private var audioTrack: AudioTrack? = null
    private var playJob: Job? = null
    private val scope = CoroutineScope(Dispatchers.Default)

    fun toggleSiren(type: SirenType) {
        if (_currentPlaying.value == type) {
            stop()
        } else {
            play(type)
        }
    }

    fun play(type: SirenType) {
        stop()
        _currentPlaying.value = type

        val sampleRate = 44100
        val minBufferSize = AudioTrack.getMinBufferSize(
            sampleRate,
            AudioFormat.CHANNEL_OUT_MONO,
            AudioFormat.ENCODING_PCM_16BIT
        )
        val bufferSize = minBufferSize.coerceAtLeast(sampleRate / 10)

        val track = AudioTrack.Builder()
            .setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
            )
            .setAudioFormat(
                AudioFormat.Builder()
                    .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                    .setSampleRate(sampleRate)
                    .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                    .build()
            )
            .setBufferSizeInBytes(bufferSize)
            .setTransferMode(AudioTrack.MODE_STREAM)
            .build()

        audioTrack = track
        track.play()

        playJob = scope.launch {
            var phase = 0.0
            var currentFreq = 420.0
            var isRising = true
            var isSoundOn = true
            var lastToggleTime = System.currentTimeMillis()
            val startTime = System.currentTimeMillis()
            val buffer = ShortArray(bufferSize / 2)

            try {
                while (_currentPlaying.value == type) {
                    val now = System.currentTimeMillis()
                    // Auto-stop after 25 seconds preview
                    if (now - startTime > 25_000) {
                        break
                    }

                    when (type) {
                        SirenType.NATIONAL_ALARM -> {
                            // Rising and falling between 415Hz and 620Hz
                            if (isRising) {
                                currentFreq += 2.0
                                if (currentFreq >= 620.0) isRising = false
                            } else {
                                currentFreq -= 2.0
                                if (currentFreq <= 415.0) isRising = true
                            }
                        }
                        SirenType.ALL_CLEAR -> {
                            // Oscillating with pauses every 2 seconds
                            if (now - lastToggleTime > 2000) {
                                isSoundOn = !isSoundOn
                                lastToggleTime = now
                            }
                        }
                        else -> {
                            currentFreq = 420.0
                            isSoundOn = true
                        }
                    }

                    for (i in buffer.indices) {
                        val sampleValue = if (isSoundOn) {
                            (sin(phase) * Short.MAX_VALUE * 0.35).toInt().toShort()
                        } else {
                            0
                        }
                        buffer[i] = sampleValue
                        phase += 2.0 * PI * currentFreq / sampleRate
                        if (phase >= 2.0 * PI) {
                            phase -= 2.0 * PI
                        }
                    }

                    track.write(buffer, 0, buffer.size)
                }
            } catch (_: Exception) {
            } finally {
                with(Dispatchers.Main) {
                    stop()
                }
            }
        }
    }

    fun stop() {
        playJob?.cancel()
        playJob = null
        try {
            audioTrack?.pause()
            audioTrack?.flush()
            audioTrack?.release()
        } catch (_: Exception) {}
        audioTrack = null
        _currentPlaying.value = null
    }
}
