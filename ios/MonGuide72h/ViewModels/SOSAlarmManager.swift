import Foundation
import AVFoundation
import UIKit

public class SOSAlarmManager: ObservableObject {
    public static let shared = SOSAlarmManager()
    
    @Published public var isAlarmPlaying: Bool = false
    
    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    private var audioFormat: AVAudioFormat?
    private var timer: Timer?
    private var strobeTimer: Timer?
    private var strobeState: Bool = false
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.duckOthers])
            try session.setActive(true)
        } catch {
            print("AVAudioSession error: \(error)")
        }
    }
    
    public func startDistressAlarm() {
        guard !isAlarmPlaying else { return }
        isAlarmPlaying = true
        
        setupAudioSession()
        playSirenTone()
        startStrobeLight()
    }
    
    public func stopDistressAlarm() {
        isAlarmPlaying = false
        
        audioEngine?.stop()
        playerNode?.stop()
        audioEngine = nil
        playerNode = nil
        
        timer?.invalidate()
        timer = nil
        
        strobeTimer?.invalidate()
        strobeTimer = nil
        
        // Ensure torch is turned off
        TorchManager.shared.setTorch(enabled: false)
    }
    
    private func playSirenTone() {
        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        engine.attach(player)
        
        let sampleRate: Double = 44100.0
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else { return }
        engine.connect(player, to: engine.mainMixerNode, format: format)
        
        do {
            try engine.start()
            player.play()
            
            self.audioEngine = engine
            self.playerNode = player
            self.audioFormat = format
            
            // Loop continuous sweep tone: 800 Hz to 2000 Hz every 0.8s
            scheduleSweepBuffer(player: player, format: format, sampleRate: sampleRate)
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in
                guard let self = self, self.isAlarmPlaying, let p = self.playerNode, let f = self.audioFormat else { return }
                self.scheduleSweepBuffer(player: p, format: f, sampleRate: sampleRate)
            }
        } catch {
            print("Engine start error: \(error)")
        }
    }
    
    private func scheduleSweepBuffer(player: AVAudioPlayerNode, format: AVAudioFormat, sampleRate: Double) {
        let duration: Double = 0.8
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
        buffer.frameLength = frameCount
        
        guard let channelData = buffer.floatChannelData?[0] else { return }
        
        let fStart: Double = 850.0
        let fEnd: Double = 2200.0
        var phase: Double = 0.0
        
        for i in 0..<Int(frameCount) {
            let progress = Double(i) / Double(frameCount)
            let freq = fStart + (fEnd - fStart) * sin(progress * .pi)
            phase += 2.0 * .pi * freq / sampleRate
            channelData[i] = Float(sin(phase) * 0.95)
        }
        
        player.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
    }
    
    private func startStrobeLight() {
        strobeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, self.isAlarmPlaying else { return }
            self.strobeState.toggle()
            TorchManager.shared.setTorch(enabled: self.strobeState)
            
            // Haptic pulse
            if self.strobeState {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }
        }
    }
}
