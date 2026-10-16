import Foundation
import AVFoundation
import UIKit

public enum SignalingMode: String, CaseIterable, Identifiable {
    case sos = "SOS Morse"
    case strobe = "Estroboscópio (8 Hz)"
    case beacon = "Baliza Noturna (0.5 Hz)"
    case redAlert = "Alerta Vermelho SAMU"
    case steadyTorch = "Lanterna Contínua"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .sos: return "sos"
        case .strobe: return "bolt.horizontal.fill"
        case .beacon: return "light.beacon.max.fill"
        case .redAlert: return "exclamationmark.shield.fill"
        case .steadyTorch: return "flashlight.on.fill"
        }
    }
}

public class TorchManager: ObservableObject {
    public static let shared = TorchManager()
    
    @Published public var isTorchOn: Bool = false
    @Published public var isSOSMode: Bool = false
    @Published public var activeMode: SignalingMode? = nil
    
    // Screen strobe synchronization
    @Published public var isScreenFlashing: Bool = false
    @Published public var screenStrobeColor: UIColor = .white
    @Published public var useScreenStrobe: Bool = true
    @Published public var useRearLED: Bool = true
    
    private var signalTimer: Timer?
    private var patternIndex: Int = 0
    private var originalBrightness: CGFloat = 0.5
    
    // S.O.S. pattern in morse: ... --- ... (short=1, long=3, pause=1)
    private let sosPattern: [Bool] = [
        true, false, true, false, true, false, false,
        true, true, true, false, true, true, true, false, true, true, true, false, false,
        true, false, true, false, true, false, false, false, false
    ]
    
    private init() {}
    
    // MARK: - SIMPLE TORCH
    
    public func toggleTorch() {
        if activeMode != nil {
            stopSignaling()
        }
        setTorch(enabled: !isTorchOn)
    }
    
    public func toggleSOS() {
        if activeMode == .sos {
            stopSignaling()
        } else {
            startSignaling(mode: .sos)
        }
    }
    
    // MARK: - ADVANCED SIGNALING MODES
    
    public func startSignaling(mode: SignalingMode) {
        stopSignaling()
        
        activeMode = mode
        isSOSMode = (mode == .sos)
        patternIndex = 0
        
        // Guardar brilho atual e aumentar para máximo se o ecrã estiver ativo
        if useScreenStrobe {
            originalBrightness = UIScreen.main.brightness
            UIScreen.main.brightness = 1.0
        }
        
        switch mode {
        case .sos:
            runPattern(interval: 0.22, pattern: sosPattern)
        case .strobe:
            // 8 Hz strobe (alternates every 0.0625s)
            runPattern(interval: 0.065, pattern: [true, false])
        case .beacon:
            // 1 pulse every 2 seconds (0.2s on, 1.8s off)
            runPattern(interval: 0.2, pattern: [true, false, false, false, false, false, false, false, false, false])
        case .redAlert:
            // Alternates red screen and rear led
            screenStrobeColor = UIColor(red: 220/255, green: 38/255, blue: 38/255, alpha: 1.0)
            runPattern(interval: 0.25, pattern: [true, false, true, false])
        case .steadyTorch:
            if useRearLED { setTorch(enabled: true) }
            if useScreenStrobe { isScreenFlashing = true; screenStrobeColor = .white }
        }
    }
    
    public func stopSignaling() {
        signalTimer?.invalidate()
        signalTimer = nil
        activeMode = nil
        isSOSMode = false
        isScreenFlashing = false
        screenStrobeColor = .white
        
        setTorch(enabled: false)
        
        // Restaurar brilho original do ecrã
        if useScreenStrobe && originalBrightness > 0 {
            UIScreen.main.brightness = originalBrightness
        }
    }
    
    private func runPattern(interval: TimeInterval, pattern: [Bool]) {
        signalTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let state = pattern[self.patternIndex % pattern.count]
            
            if self.useRearLED {
                self.setTorch(enabled: state)
            }
            
            if self.useScreenStrobe {
                self.isScreenFlashing = state
            }
            
            self.patternIndex += 1
        }
    }
    
    public func setTorch(enabled: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            isTorchOn = enabled
            return
        }
        
        do {
            try device.lockForConfiguration()
            if enabled {
                try device.setTorchModeOn(level: 1.0)
                isTorchOn = true
            } else {
                device.torchMode = .off
                isTorchOn = false
            }
            device.unlockForConfiguration()
        } catch {
            print("Torch error: \(error)")
        }
    }
}
