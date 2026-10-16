import Foundation
import AVFoundation

public class VoiceGuideManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    public static let shared = VoiceGuideManager()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published public var isSpeaking: Bool = false
    @Published public var isPaused: Bool = false
    @Published public var currentTextTitle: String = ""
    
    override private init() {
        super.init()
        synthesizer.delegate = self
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        } catch {
            print("VoiceGuideManager audio session error: \(error)")
        }
    }
    
    public func speak(title: String, text: String, language: AppLanguage) {
        stop()
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to activate audio session: \(error)")
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voiceForLanguage(language)
        utterance.rate = 0.48 // Calm, clear, measured rate for high stress/emergency situations
        utterance.pitchMultiplier = 1.0
        utterance.preUtteranceDelay = 0.2
        utterance.postUtteranceDelay = 0.2
        
        currentTextTitle = title
        isSpeaking = true
        isPaused = false
        
        synthesizer.speak(utterance)
    }
    
    public func pause() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
            isPaused = true
        }
    }
    
    public func resume() {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            isPaused = false
        }
    }
    
    public func stop() {
        if synthesizer.isSpeaking || synthesizer.isPaused {
            synthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
        isPaused = false
        currentTextTitle = ""
    }
    
    public func togglePlayback(title: String, text: String, language: AppLanguage) {
        if isSpeaking {
            if isPaused {
                resume()
            } else {
                pause()
            }
        } else {
            speak(title: title, text: text, language: language)
        }
    }
    
    private func voiceForLanguage(_ lang: AppLanguage) -> AVSpeechSynthesisVoice? {
        let code: String
        switch lang {
        case .pt: code = "pt-PT"
        case .fr: code = "fr-FR"
        case .de: code = "de-DE"
        case .en: code = "en-GB"
        case .es: code = "es-ES"
        case .it: code = "it-IT"
        case .nl: code = "nl-NL"
        case .pl: code = "pl-PL"
        case .ro: code = "ro-RO"
        case .el: code = "el-GR"
        case .cs: code = "cs-CZ"
        case .sv: code = "sv-SE"
        case .hu: code = "hu-HU"
        case .bg: code = "bg-BG"
        case .da: code = "da-DK"
        case .fi: code = "fi-FI"
        case .sk: code = "sk-SK"
        case .hr: code = "hr-HR"
        case .lt: code = "lt-LT"
        case .sl: code = "sl-SI"
        case .lv: code = "lv-LV"
        case .et: code = "et-EE"
        case .ga: code = "ga-IE"
        case .mt: code = "mt-MT"
        case .lu:
            // Check if Luxembourgish voice is installed, otherwise fallback to German/French
            if let lbVoice = AVSpeechSynthesisVoice(language: "lb-LU") {
                return lbVoice
            }
            code = "de-DE"
        }
        
        return AVSpeechSynthesisVoice(language: code) ?? AVSpeechSynthesisVoice(language: "fr-FR")
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = true
            self.isPaused = false
        }
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.isPaused = false
            self.currentTextTitle = ""
        }
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isPaused = true
        }
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isPaused = false
        }
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.isPaused = false
            self.currentTextTitle = ""
        }
    }
}
