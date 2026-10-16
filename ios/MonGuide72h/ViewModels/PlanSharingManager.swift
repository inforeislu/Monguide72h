import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

public class PlanSharingManager {
    public static let shared = PlanSharingManager()
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    private init() {}
    
    // MARK: - PAYLOAD ENCODING / DECODING
    
    /// Converte o EmergencyPlan numa string compacta base64 (com compressão zlib)
    public func encodePlanToPayload(_ plan: EmergencyPlan) -> String? {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(plan)
            
            // Tenta comprimir com zlib para caber perfeitamente no QR Code
            if let compressed = try? (jsonData as NSData).compressed(using: .zlib) as Data {
                let base64 = compressed.base64EncodedString()
                return "MG72HZ:" + base64
            } else {
                let base64 = jsonData.base64EncodedString()
                return "MG72H:" + base64
            }
        } catch {
            print("Erro ao codificar plano: \(error)")
            return nil
        }
    }
    
    /// Descodifica a string do QR Code de volta para EmergencyPlan
    public func decodePlanFromPayload(_ payload: String) -> EmergencyPlan? {
        let trimmed = payload.trimmingCharacters(in: .whitespacesAndNewlines)
        let decoder = JSONDecoder()
        
        // 1. Formato Comprimido ZLIB
        if trimmed.hasPrefix("MG72HZ:") {
            let base64 = String(trimmed.dropFirst("MG72HZ:".count))
            guard let data = Data(base64Encoded: base64) else { return nil }
            guard let decompressed = try? (data as NSData).decompressed(using: .zlib) as Data else { return nil }
            return try? decoder.decode(EmergencyPlan.self, from: decompressed)
        }
        
        // 2. Formato Base64 Direto
        if trimmed.hasPrefix("MG72H:") {
            let base64 = String(trimmed.dropFirst("MG72H:".count))
            guard let data = Data(base64Encoded: base64) else { return nil }
            return try? decoder.decode(EmergencyPlan.self, from: data)
        }
        
        // 3. Fallback: JSON direto
        if let directData = trimmed.data(using: .utf8) {
            return try? decoder.decode(EmergencyPlan.self, from: directData)
        }
        
        return nil
    }
    
    // MARK: - QR CODE IMAGE GENERATION
    
    /// Gera uma imagem QR Code nítida e de alta resolução
    public func generateQRCode(from payload: String) -> UIImage? {
        guard let data = payload.data(using: .utf8) else { return nil }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel") // M = 15% error correction
        
        guard let outputImage = filter.outputImage else { return nil }
        
        // Escalar para alta resolução (512x512) para leitura instantânea pela câmara
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = outputImage.transformed(by: transform)
        
        if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return UIImage(ciImage: scaledImage)
    }
    
    // MARK: - AIRDROP / FILE EXPORT
    
    /// Exporta o plano para um ficheiro temporário pronto para partilhar via AirDrop
    public func exportPlanFile(plan: EmergencyPlan) -> URL? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(plan)
            
            let fileName = "PlanoEmergencia_72h_\(plan.ownerName.isEmpty ? "Familia" : plan.ownerName.filter { $0.isLetter || $0.isNumber }).json"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            try data.write(to: tempURL)
            return tempURL
        } catch {
            print("Erro ao exportar ficheiro: \(error)")
            return nil
        }
    }
    
    /// Lê e descodifica um ficheiro importado
    public func importPlanFromFile(url: URL) -> EmergencyPlan? {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(EmergencyPlan.self, from: data)
        } catch {
            print("Erro ao ler ficheiro importado: \(error)")
            return nil
        }
    }
}
