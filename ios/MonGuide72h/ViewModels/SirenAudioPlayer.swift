import Foundation
import AVFoundation
import UIKit
import Combine

public class SirenAudioPlayer: ObservableObject {
    public static let shared = SirenAudioPlayer()
    
    @Published public var currentPlaying: SirenType? = nil
    
    private var audioEngine: AVAudioEngine?
    private var sourceNode: AVAudioSourceNode?
    private var timer: Timer?
    private var currentPhase: Double = 0.0
    private var targetFrequency: Double = 420.0
    private var isRising: Bool = true
    private var soundEnabled: Bool = true
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }
    
    public func toggleSiren(_ type: SirenType) {
        if currentPlaying == type {
            stop()
        } else {
            play(type)
        }
    }
    
    public func play(_ type: SirenType) {
        stop()
        currentPlaying = type
        
        // Haptic feedback
        let feedback = UINotificationFeedbackGenerator()
        feedback.notificationOccurred(.warning)
        
        let engine = AVAudioEngine()
        self.audioEngine = engine
        let mainMixer = engine.mainMixerNode
        let sampleRate = mainMixer.outputFormat(forBus: 0).sampleRate
        
        targetFrequency = 420.0
        currentPhase = 0.0
        soundEnabled = true
        
        let node = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            
            for frame in 0..<Int(frameCount) {
                let value = self.soundEnabled ? sin(self.currentPhase) * 0.25 : 0.0
                self.currentPhase += 2.0 * Double.pi * self.targetFrequency / sampleRate
                if self.currentPhase >= 2.0 * Double.pi {
                    self.currentPhase -= 2.0 * Double.pi
                }
                
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = Float(value)
                }
            }
            return noErr
        }
        
        self.sourceNode = node
        engine.attach(node)
        engine.connect(node, to: mainMixer, format: mainMixer.outputFormat(forBus: 0))
        
        do {
            try engine.start()
        } catch {
            print("Engine start error: \(error)")
            stop()
            return
        }
        
        // Dynamic modulation according to official Luxembourg siren specification
        if type == .nationalAlarm {
            // Rising and falling tone (415Hz to 620Hz)
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.isRising {
                    self.targetFrequency += 12.0
                    if self.targetFrequency >= 620.0 { self.isRising = false }
                } else {
                    self.targetFrequency -= 12.0
                    if self.targetFrequency <= 415.0 { self.isRising = true }
                }
            }
        } else if type == .allClear {
            // Tone with pauses every 2 seconds
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.soundEnabled.toggle()
            }
        }
        
        // Auto-stop after 25 seconds of preview
        DispatchQueue.main.asyncAfter(deadline: .now() + 25.0) { [weak self] in
            if self?.currentPlaying == type {
                self?.stop()
            }
        }
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
        if let engine = audioEngine, engine.isRunning {
            engine.stop()
            if let node = sourceNode {
                engine.detach(node)
            }
        }
        audioEngine = nil
        sourceNode = nil
        currentPlaying = nil
    }
}
