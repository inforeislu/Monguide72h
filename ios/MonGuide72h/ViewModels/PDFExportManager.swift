import Foundation
import UIKit
import SwiftUI

public class PDFExportManager {
    public static let shared = PDFExportManager()
    
    private init() {}
    
    /// Generates a comprehensive official A4 emergency PDF dossier
    public func generateCompleteEmergencyDossier(
        plan: EmergencyPlan,
        kitVM: KitCalculatorViewModel,
        bagCheckedKeys: Set<String>,
        language: AppLanguage
    ) -> URL? {
        let pageWidth: CGFloat = 595.2 // A4 standard width in points (72 dpi)
        let pageHeight: CGFloat = 841.8 // A4 standard height
        let pageBounds = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            kCGPDFContextCreator: "Mon Guide 72h — InfoReis",
            kCGPDFContextAuthor: plan.ownerName.isEmpty ? "Famille" : plan.ownerName,
            kCGPDFContextTitle: "Dossier Oficial de Emergência 72h (Luxemburgo)"
        ] as [String: Any]
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageBounds, format: format)
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("Dossier_Emergencia_72h_Luxemburgo.pdf")
        
        do {
            try renderer.writePDF(to: fileURL) { context in
                // ================= PAGE 1: PLANO DE EMERGÊNCIA =================
                context.beginPage()
                drawPageHeader(
                    context: context.cgContext,
                    pageWidth: pageWidth,
                    title: "PLANO PESSOAL & FAMILIAR DE EMERGÊNCIA",
                    subtitle: "LËTZ PREPARE ! — ESTRATÉGIA NACIONAL DE RESILIÊNCIA",
                    pageNum: 1,
                    totalPages: 2
                )
                
                var y: CGFloat = 80
                
                // Section: Identificação do Foyer
                y = drawSectionTitle("1. IDENTIFICAÇÃO DO FOYER & MORADA", at: y, in: context.cgContext)
                let owner = plan.ownerName.isEmpty ? "Não especificado" : plan.ownerName
                let addr = plan.address.isEmpty ? "Não especificada" : plan.address
                let city = plan.city.isEmpty ? "" : plan.city
                
                y = drawKeyValue("Responsável / Família:", value: owner, at: y)
                y = drawKeyValue("Morada:", value: "\(addr) \(city)", at: y)
                y += 6
                
                // Section: Membros da Habitação
                y = drawSectionTitle("2. RESIDENTES DO FOYER", at: y, in: context.cgContext)
                if plan.members.isEmpty {
                    y = drawText("• Nenhum membro registado no plano.", at: y, isItalic: true)
                } else {
                    for (i, m) in plan.members.enumerated() {
                        let name = m.fullName.isEmpty ? "Membro \(i+1)" : m.fullName
                        let phone = m.phone.isEmpty ? "—" : m.phone
                        let cns = m.matricule.isEmpty ? "—" : m.matricule
                        let bg = m.bloodGroup
                        let desc = "• \(name) | Tel: \(phone) | CNS: \(cns) | Sangue: \(bg)"
                        y = drawText(desc, at: y, isBold: false)
                    }
                }
                y += 6
                
                // Section: Condições Médicas & Alergias
                if !plan.medicalList.isEmpty {
                    y = drawSectionTitle("3. SAÚDE, TRATAMENTOS & ALERGIAS", at: y, in: context.cgContext)
                    for entry in plan.medicalList {
                        let pName = entry.personName.isEmpty ? "Pessoa" : entry.personName
                        let med = "• \(pName) : Alergias: \(entry.allergies.isEmpty ? "Nenhuma" : entry.allergies) | Medicação: \(entry.medications.isEmpty ? "—" : entry.medications) (\(entry.dosage))"
                        y = drawText(med, at: y, isBold: false)
                    }
                    y += 6
                }
                
                // Section: Animais
                if !plan.pets.isEmpty {
                    y = drawSectionTitle("4. ANIMAIS DE ESTIMAÇÃO", at: y, in: context.cgContext)
                    for pet in plan.pets {
                        let pDesc = "• \(pet.species) - \(pet.name.isEmpty ? "Sem nome" : pet.name) (\(pet.info.isEmpty ? "Sem notas" : pet.info))"
                        y = drawText(pDesc, at: y, isBold: false)
                    }
                    y += 6
                }
                
                // Section: Cortes e Instalações da Casa
                y = drawSectionTitle("5. INSTALAÇÕES VITAIS DA CASA (CORTES)", at: y, in: context.cgContext)
                y = drawKeyValue("• Torneira Geral da Água:", value: plan.waterValveLocation.isEmpty ? "Não indicado" : plan.waterValveLocation, at: y)
                y = drawKeyValue("• Válvula Geral de Gás:", value: plan.gasValveLocation.isEmpty ? "Não indicado" : plan.gasValveLocation, at: y)
                y = drawKeyValue("• Disjuntor / Quadro Elétrico:", value: plan.electricBreakerLocation.isEmpty ? "Não indicado" : plan.electricBreakerLocation, at: y)
                y = drawKeyValue("• Extintor / Manta de Fogo:", value: plan.extinguisherLocation.isEmpty ? "Não indicado" : plan.extinguisherLocation, at: y)
                y = drawKeyValue("• Saída de Emergência Secundária:", value: plan.escapeRoute.isEmpty ? "Não indicado" : plan.escapeRoute, at: y)
                y += 6
                
                // Section: Pontos de Encontro & Contactos de Crise
                y = drawSectionTitle("6. PONTOS DE ENCONTRO & CONTACTOS FORA DA ZONA", at: y, in: context.cgContext)
                y = drawKeyValue("• Ponto de Encontro 1 (Bairro):", value: plan.meetingPoint1.isEmpty ? "Não indicado" : plan.meetingPoint1, at: y)
                y = drawKeyValue("• Ponto de Encontro 2 (Fora da Comuna):", value: plan.meetingPoint2.isEmpty ? "Não indicado" : plan.meetingPoint2, at: y)
                y = drawKeyValue("• Autorizado a recolher crianças na escola:", value: plan.schoolPickupPerson.isEmpty ? "Não indicado" : plan.schoolPickupPerson, at: y)
                y = drawKeyValue("• Contacto de emergência fora da região:", value: plan.outOfAreaContact.isEmpty ? "Não indicado" : plan.outOfAreaContact, at: y)
                y = drawKeyValue("• Acolhimento de emergência em casa de:", value: plan.emergencyShelterContact.isEmpty ? "Não indicado" : plan.emergencyShelterContact, at: y)
                
                // Page 1 Footer
                drawPageFooter(context: context.cgContext, pageWidth: pageWidth, pageHeight: pageHeight)
                
                // ================= PAGE 2: KIT 72H & MOCHILA =================
                context.beginPage()
                drawPageHeader(
                    context: context.cgContext,
                    pageWidth: pageWidth,
                    title: "PROVISÕES DO KIT 72H & MOCHILA DE EVACUAÇÃO",
                    subtitle: "LËTZ PREPARE ! — ESTRATÉGIA NACIONAL DE RESILIÊNCIA",
                    pageNum: 2,
                    totalPages: 2
                )
                
                y = 80
                
                // Section: Cálculo das Provisões
                y = drawSectionTitle("1. DIMENSIONAMENTO DO KIT 72H (3 DIAS)", at: y, in: context.cgContext)
                let compo = "\(kitVM.adults) Adultos | \(kitVM.children) Crianças | \(kitVM.babies) Bebés | \(kitVM.pets) Animais"
                y = drawKeyValue("Composição do Foyer:", value: compo, at: y)
                
                let waterText = "\(kitVM.totalWaterLitres) Litros de água potável (equivalente a ~\(kitVM.totalWaterBottles) garrafas de 1,5L)"
                y = drawKeyValue("Água Vital Recomendada:", value: waterText, at: y, highlight: true)
                
                let mealText = "Mínimo de \(kitVM.totalMeals) rações de refeições não perecíveis"
                y = drawKeyValue("Refeições 72 Horas:", value: mealText, at: y)
                y += 6
                
                // Section: Checklist de Provisões
                y = drawSectionTitle("2. CHECKLIST OFICIAL DO KIT DOMÉSTICO (72 HORAS)", at: y, in: context.cgContext)
                for item in kitVM.items {
                    let box = item.isChecked ? "[X]" : "[  ]"
                    let localizedName = LocalizationManager.shared.tr("item_\(item.id)")
                    let line = "\(box) \(localizedName) [\(item.defaultCategory)]"
                    y = drawText(line, at: y, isBold: item.isChecked)
                }
                y += 8
                
                // Section: Mochila de Evacuação Rápida (<10kg)
                y = drawSectionTitle("3. MOCHILA DE EVACUAÇÃO RÁPIDA (< 10 KG)", at: y, in: context.cgContext)
                let bagItems = [
                    ("bag_water", "1 a 2 garrafas leves de água (1L a 1,5L)"),
                    ("bag_food", "Snacks calóricos: barras energéticas e frutos secos"),
                    ("bag_meds", "Medicação essencial para 3 dias e receitas médicas"),
                    ("bag_phone", "Telemóvel e cabo de carregamento"),
                    ("bag_wallet", "Carteira com identificação, dinheiro vivo e cartões"),
                    ("bag_keys", "Chaves de casa e viatura sobressalentes"),
                    ("bag_powerbank", "Bateria portátil (Powerbank) carregada a 100%"),
                    ("bag_plan", "Cópia impressa deste Plano de Emergência"),
                    ("bag_firstaid", "Kit compacto de primeiros socorros"),
                    ("bag_hygiene", "Artigos de higiene essenciais e toalhitas"),
                    ("bag_clothes", "Muda de roupa quente e calçado confortável")
                ]
                
                for (key, label) in bagItems {
                    let isDone = bagCheckedKeys.contains(key)
                    let mark = isDone ? "[X]" : "[  ]"
                    y = drawText("\(mark) \(label)", at: y, isBold: isDone)
                }
                y += 8
                
                // Section: Telefones e Canais Oficiais de Socorro
                y = drawSectionTitle("4. NÚMEROS E FREQUÊNCIAS OFICIAIS DE CRISE", at: y, in: context.cgContext)
                y = drawText("• 112 : CGDIS (Ambulância, Socorro e Incêndios)", at: y, isBold: true)
                y = drawText("• 113 : Polícia Grão-Ducal (Emergência e Segurança)", at: y, isBold: true)
                y = drawText("• 8002 7788 : Linha Verde Oficial Info-Crise do Governo", at: y, isBold: true)
                y = drawText("• Rádios Oficiais : RTL Radio Lëtzebuerg (88.9 & 92.5 MHz) | Radio 100.7 FM", at: y, isBold: false)
                y = drawText("• Aplicação & Alertas : LU-Alert (Cell Broadcast e SMS)", at: y, isBold: false)
                
                // Page 2 Footer
                drawPageFooter(context: context.cgContext, pageWidth: pageWidth, pageHeight: pageHeight)
            }
            return fileURL
        } catch {
            print("Failed to generate PDF: \(error)")
            return nil
        }
    }
    
    // MARK: - DRAWING HELPERS
    
    private func drawPageHeader(
        context: CGContext,
        pageWidth: CGFloat,
        title: String,
        subtitle: String,
        pageNum: Int,
        totalPages: Int
    ) {
        // Top colored bar (Luxembourg Blue #002B49)
        let barRect = CGRect(x: 35, y: 25, width: pageWidth - 70, height: 4)
        context.setFillColor(red: 0/255, green: 43/255, blue: 73/255, alpha: 1.0)
        context.fill(barRect)
        
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .black),
            .foregroundColor: UIColor(red: 0/255, green: 43/255, blue: 73/255, alpha: 1.0)
        ]
        title.draw(at: CGPoint(x: 35, y: 35), withAttributes: titleAttrs)
        
        let subAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8, weight: .bold),
            .foregroundColor: UIColor(red: 237/255, green: 41/255, blue: 57/255, alpha: 1.0) // Red
        ]
        subtitle.draw(at: CGPoint(x: 35, y: 52), withAttributes: subAttrs)
        
        let pageAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9, weight: .medium),
            .foregroundColor: UIColor.gray
        ]
        let pageStr = "Página \(pageNum) de \(totalPages)"
        let pWidth = (pageStr as NSString).size(withAttributes: pageAttrs).width
        pageStr.draw(at: CGPoint(x: pageWidth - 35 - pWidth, y: 38), withAttributes: pageAttrs)
        
        // Light separator line
        context.setStrokeColor(UIColor.systemGray4.cgColor)
        context.setLineWidth(0.8)
        context.strokeLineSegments(between: [CGPoint(x: 35, y: 68), CGPoint(x: pageWidth - 35, y: 68)])
    }
    
    private func drawSectionTitle(_ title: String, at y: CGFloat, in context: CGContext) -> CGFloat {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9.5, weight: .bold),
            .foregroundColor: UIColor(red: 0/255, green: 43/255, blue: 73/255, alpha: 1.0)
        ]
        title.draw(at: CGPoint(x: 35, y: y), withAttributes: attrs)
        return y + 14
    }
    
    private func drawKeyValue(_ key: String, value: String, at y: CGFloat, highlight: Bool = false) -> CGFloat {
        let kAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8.5, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        let vAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8.5, weight: highlight ? .bold : .regular),
            .foregroundColor: highlight ? UIColor(red: 0/255, green: 100/255, blue: 200/255, alpha: 1.0) : UIColor.darkGray
        ]
        
        let kWidth = (key as NSString).size(withAttributes: kAttrs).width
        key.draw(at: CGPoint(x: 45, y: y), withAttributes: kAttrs)
        value.draw(at: CGPoint(x: 45 + kWidth + 6, y: y), withAttributes: vAttrs)
        
        return y + 12
    }
    
    private func drawText(_ text: String, at y: CGFloat, isBold: Bool = false, isItalic: Bool = false) -> CGFloat {
        var font = UIFont.systemFont(ofSize: 8.5)
        if isBold { font = UIFont.boldSystemFont(ofSize: 8.5) }
        else if isItalic { font = UIFont.italicSystemFont(ofSize: 8.5) }
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.darkGray
        ]
        text.draw(at: CGPoint(x: 45, y: y), withAttributes: attrs)
        return y + 12
    }
    
    private func drawPageFooter(context: CGContext, pageWidth: CGFloat, pageHeight: CGFloat) {
        let sepY = pageHeight - 40
        context.setStrokeColor(UIColor.systemGray4.cgColor)
        context.setLineWidth(0.8)
        context.strokeLineSegments(between: [CGPoint(x: 35, y: sepY), CGPoint(x: pageWidth - 35, y: sepY)])
        
        let fAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 7.5, weight: .regular),
            .foregroundColor: UIColor.gray
        ]
        let leftText = "Documento de emergência pessoal — Guarde este impresso junto ao Kit 72h e à entrada de casa."
        leftText.draw(at: CGPoint(x: 35, y: sepY + 8), withAttributes: fAttrs)
        
        let rightText = "Desenvolvido por InfoReis (inforeis.lu)"
        let rWidth = (rightText as NSString).size(withAttributes: fAttrs).width
        rightText.draw(at: CGPoint(x: pageWidth - 35 - rWidth, y: sepY + 8), withAttributes: fAttrs)
    }
    
    /// Prints the given PDF file directly using AirPrint
    public func printFile(at url: URL, from viewController: UIViewController) {
        if UIPrintInteractionController.isPrintingAvailable {
            let printController = UIPrintInteractionController.shared
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.outputType = .general
            printInfo.jobName = "Dossier_Emergencia_72h"
            printController.printInfo = printInfo
            printController.printingItem = url
            
            printController.present(animated: true) { _, _, error in
                if let error = error {
                    print("AirPrint error: \(error.localizedDescription)")
                }
            }
        }
    }
}

public struct ShareSheet: UIViewControllerRepresentable {
    public var activityItems: [Any]
    public var applicationActivities: [UIActivity]? = nil

    public init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        if let popover = controller.popoverPresentationController {
            popover.permittedArrowDirections = []
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                popover.sourceView = rootVC.view
                popover.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
            }
        }
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
