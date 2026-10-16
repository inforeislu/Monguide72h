import SwiftUI

public struct VoiceGuideBar: View {
    let title: String
    let textToSpeak: String
    @ObservedObject var voiceManager = VoiceGuideManager.shared
    @ObservedObject var loc = LocalizationManager.shared
    
    public init(title: String, textToSpeak: String) {
        self.title = title
        self.textToSpeak = textToSpeak
    }
    
    private var isThisActive: Bool {
        voiceManager.isSpeaking && voiceManager.currentTextTitle == title
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // Speaker or Wave Icon
            ZStack {
                Circle()
                    .fill(isThisActive ? Color.blue : Color(UIColor.tertiarySystemFill))
                    .frame(width: 36, height: 36)
                
                Image(systemName: isThisActive ? "waveform" : "speaker.wave.2.fill")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(isThisActive ? .white : .primary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(isThisActive ? (voiceManager.isPaused ? "Áudio-Guia em Pausa" : "A Narrar em Voz Alta...") : "Áudio-Guia Falado (Apagão / Fumo)")
                    .font(.caption.bold())
                    .foregroundColor(isThisActive ? .blue : .primary)
                
                Text(isThisActive ? title : "Ouvir instruções faladas no idioma da aplicação")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Language Flag
            Text(loc.currentLanguage.flag)
                .font(.caption)
            
            // Play/Pause Button
            Button(action: {
                if isThisActive {
                    voiceManager.togglePlayback(title: title, text: textToSpeak, language: loc.currentLanguage)
                } else {
                    voiceManager.speak(title: title, text: textToSpeak, language: loc.currentLanguage)
                }
            }) {
                Image(systemName: (isThisActive && !voiceManager.isPaused) ? "pause.fill" : "play.fill")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
            
            // Stop Button (if active)
            if isThisActive {
                Button(action: {
                    voiceManager.stop()
                }) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isThisActive ? Color.blue.opacity(0.12) : Color(UIColor.secondarySystemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isThisActive ? Color.blue.opacity(0.4) : Color.clear, lineWidth: 1.5)
        )
        .cornerRadius(12)
    }
}
