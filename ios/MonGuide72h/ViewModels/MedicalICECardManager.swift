import Foundation
import UIKit
import SwiftUI

public class MedicalICECardManager: ObservableObject {
    public static let shared = MedicalICECardManager()
    
    @Published public var card: MedicalICECard
    
    private let storageKey = "mon_guide_72h_ice_medical_card"
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode(MedicalICECard.self, from: data) {
            self.card = saved
        } else {
            // Inicializar com dados do plano familiar se existirem
            self.card = MedicalICECardManager.loadInitialFromPlan()
        }
    }
    
    public func saveCard() {
        if let data = try? JSONEncoder().encode(card) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private static func loadInitialFromPlan() -> MedicalICECard {
        var newCard = MedicalICECard()
        if let planData = UserDefaults.standard.data(forKey: "mon_guide_72h_saved_plan"),
           let plan = try? JSONDecoder().decode(EmergencyPlan.self, from: planData) {
            if let first = plan.members.first {
                newCard.fullName = first.fullName
                newCard.cnsMatricule = first.matricule
                newCard.bloodGroup = first.bloodGroup.isEmpty ? "O+" : first.bloodGroup
            }
            if let med = plan.medicalList.first {
                newCard.allergies = med.allergies
                newCard.regularMedications = med.medications
            }
            if let firstContact = plan.allEmergencyPhoneNumbers.first {
                newCard.emergencyContactName = firstContact.name
                newCard.emergencyContactPhone = firstContact.phone
                newCard.emergencyContactRelation = "ICE"
            }
        }
        return newCard
    }
    
    // MARK: - GENERATE LOCK SCREEN WALLPAPER (1179 x 2556 px)
    
    public func generateLockScreenWallpaper(card: MedicalICECard) -> UIImage {
        let size = CGSize(width: 1179, height: 2556)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { ctx in
            let cg = ctx.cgContext
            
            // 1. Fundo escuro elegante (gradiente preto / azul escuro profundo)
            let colors = [
                UIColor(red: 10/255, green: 14/255, blue: 22/255, alpha: 1.0).cgColor,
                UIColor(red: 18/255, green: 22/255, blue: 34/255, alpha: 1.0).cgColor,
                UIColor(red: 8/255, green: 10/255, blue: 16/255, alpha: 1.0).cgColor
            ]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0.0, 0.5, 1.0]) {
                cg.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: [])
            }
            
            // 2. Zona Superior Reservada para o Relógio do iOS (y: 0 a 850px)
            // Deixar limpo com subtil grelha tática decorativa
            
            // 3. CARTÃO DE EMERGÊNCIA MÉDICA CENTRAL (y: 880 a 2050px)
            let cardRect = CGRect(x: 70, y: 880, width: size.width - 140, height: 1180)
            
            // Sombra do cartão
            cg.saveGState()
            cg.setShadow(offset: CGSize(width: 0, height: 12), blur: 30, color: UIColor.black.withAlphaComponent(0.6).cgColor)
            
            // Fundo do cartão
            let cardPath = UIBezierPath(roundedRect: cardRect, cornerRadius: 40)
            UIColor(red: 24/255, green: 28/255, blue: 38/255, alpha: 0.95).setFill()
            cardPath.fill()
            cg.restoreGState()
            
            // Borda do cartão vermelha de emergência
            UIColor(red: 220/255, green: 38/255, blue: 38/255, alpha: 0.8).setStroke()
            cardPath.lineWidth = 4
            cardPath.stroke()
            
            // Cabeçalho Vermelho do Cartão
            let headerRect = CGRect(x: cardRect.origin.x, y: cardRect.origin.y, width: cardRect.width, height: 120)
            let headerPath = UIBezierPath(
                roundedRect: headerRect,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: 40, height: 40)
            )
            UIColor(red: 220/255, green: 38/255, blue: 38/255, alpha: 1.0).setFill()
            headerPath.fill()
            
            // Texto do Cabeçalho
            let headerTitle = "FICHE MÉDICALE D'URGENCE • ICE"
            let headerAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 34, weight: .black),
                .foregroundColor: UIColor.white
            ]
            let headerTitleSize = (headerTitle as NSString).size(withAttributes: headerAttrs)
            (headerTitle as NSString).draw(
                at: CGPoint(x: cardRect.origin.x + (cardRect.width - headerTitleSize.width) / 2, y: cardRect.origin.y + 42),
                withAttributes: headerAttrs
            )
            
            // Conteúdo Interno
            var currentY = cardRect.origin.y + 150
            let contentX = cardRect.origin.x + 40
            let contentWidth = cardRect.width - 80
            
            // Nome Completo + Grupo Sanguíneo em destaque
            let name = card.fullName.isEmpty ? "TITULAIRE DU TÉLÉPHONE" : card.fullName.uppercased()
            let nameAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 46, weight: .heavy),
                .foregroundColor: UIColor.white
            ]
            (name as NSString).draw(at: CGPoint(x: contentX, y: currentY), withAttributes: nameAttrs)
            
            // Crachá do Grupo Sanguíneo no topo direito
            let bloodText = card.bloodGroup
            let bloodBadgeRect = CGRect(x: cardRect.maxX - 200, y: currentY - 10, width: 160, height: 75)
            let bloodBadgePath = UIBezierPath(roundedRect: bloodBadgeRect, cornerRadius: 18)
            UIColor(red: 220/255, green: 38/255, blue: 38/255, alpha: 0.25).setFill()
            bloodBadgePath.fill()
            UIColor(red: 220/255, green: 38/255, blue: 38/255, alpha: 1.0).setStroke()
            bloodBadgePath.lineWidth = 3
            bloodBadgePath.stroke()
            
            let bloodAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 38, weight: .black),
                .foregroundColor: UIColor(red: 248/255, green: 113/255, blue: 113/255, alpha: 1.0)
            ]
            let bloodSize = (bloodText as NSString).size(withAttributes: bloodAttrs)
            (bloodText as NSString).draw(
                at: CGPoint(
                    x: bloodBadgeRect.origin.x + (bloodBadgeRect.width - bloodSize.width) / 2,
                    y: bloodBadgeRect.origin.y + (bloodBadgeRect.height - bloodSize.height) / 2
                ),
                withAttributes: bloodAttrs
            )
            
            currentY += 75
            
            // Matricule CNS
            if !card.cnsMatricule.isEmpty {
                let cnsText = "CNS / Matricule : \(card.cnsMatricule)"
                let cnsAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                    .foregroundColor: UIColor.lightGray
                ]
                (cnsText as NSString).draw(at: CGPoint(x: contentX, y: currentY), withAttributes: cnsAttrs)
                currentY += 50
            }
            
            // Linha divisória
            cg.setStrokeColor(UIColor.gray.withAlphaComponent(0.3).cgColor)
            cg.setLineWidth(2)
            cg.move(to: CGPoint(x: contentX, y: currentY + 15))
            cg.addLine(to: CGPoint(x: contentX + contentWidth, y: currentY + 15))
            cg.strokePath()
            currentY += 35
            
            // ALERGIAS (EM DESTAQUE AMARELO/VERMELHO)
            let allergies = card.allergies.isEmpty ? "Aucune allergie connue signalée" : card.allergies
            let allergyBadgeRect = CGRect(x: contentX, y: currentY, width: contentWidth, height: 110)
            let allergyBadgePath = UIBezierPath(roundedRect: allergyBadgeRect, cornerRadius: 16)
            UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 0.15).setFill()
            allergyBadgePath.fill()
            UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 0.8).setStroke()
            allergyBadgePath.lineWidth = 2
            allergyBadgePath.stroke()
            
            let allergyTitle = "⚠️ ALLERGIES & RISQUES VITAUX"
            let allergyTitleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 22, weight: .black),
                .foregroundColor: UIColor(red: 251/255, green: 191/255, blue: 36/255, alpha: 1.0)
            ]
            (allergyTitle as NSString).draw(at: CGPoint(x: contentX + 20, y: currentY + 14), withAttributes: allergyTitleAttrs)
            
            let allergyTextAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            (allergies as NSString).draw(at: CGPoint(x: contentX + 20, y: currentY + 52), withAttributes: allergyTextAttrs)
            
            currentY += 135
            
            // PATOLOGIAS & MEDICAÇÃO REGULAR
            if !card.medicalConditions.isEmpty || !card.regularMedications.isEmpty {
                let medTitle = "ANTÉCÉDENTS & TRAITEMENTS :"
                let medTitleAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 22, weight: .bold),
                    .foregroundColor: UIColor.lightGray
                ]
                (medTitle as NSString).draw(at: CGPoint(x: contentX, y: currentY), withAttributes: medTitleAttrs)
                currentY += 35
                
                let details = [card.medicalConditions, card.regularMedications]
                    .filter { !$0.isEmpty }
                    .joined(separator: " • ")
                let detailsAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 26, weight: .medium),
                    .foregroundColor: UIColor.white
                ]
                (details as NSString).draw(
                    in: CGRect(x: contentX, y: currentY, width: contentWidth, height: 80),
                    withAttributes: detailsAttrs
                )
                currentY += 95
            }
            
            // CONTACTOS DE EMERGÊNCIA (ICE)
            let iceTitle = "CONTACTS D'URGENCE (ICE) :"
            let iceTitleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24, weight: .black),
                .foregroundColor: UIColor(red: 96/255, green: 165/255, blue: 250/255, alpha: 1.0)
            ]
            (iceTitle as NSString).draw(at: CGPoint(x: contentX, y: currentY), withAttributes: iceTitleAttrs)
            currentY += 45
            
            // Contacto 1
            let contact1 = "\(card.emergencyContactName.isEmpty ? "Proche ICE" : card.emergencyContactName) : \(card.emergencyContactPhone.isEmpty ? "112 (CGDIS)" : card.emergencyContactPhone)"
            let contactAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 34, weight: .heavy),
                .foregroundColor: UIColor.white
            ]
            (contact1 as NSString).draw(at: CGPoint(x: contentX, y: currentY), withAttributes: contactAttrs)
            currentY += 55
            
            // Contacto 2 (se existir)
            if !card.secondaryContactPhone.isEmpty {
                let contact2 = "\(card.secondaryContactName.isEmpty ? "Second Contact" : card.secondaryContactName) : \(card.secondaryContactPhone)"
                let contact2Attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                    .foregroundColor: UIColor.lightGray
                ]
                (contact2 as NSString).draw(at: CGPoint(x: contentX, y: currentY), withAttributes: contact2Attrs)
                currentY += 55
            }
            
            // Rodapé do Cartão com Indicação de Socorro
            let footerText = "SECOURS LUXEMBOURG : APPELER LE 112 • SAMU"
            let footerAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 22, weight: .bold),
                .foregroundColor: UIColor.gray
            ]
            let footerSize = (footerText as NSString).size(withAttributes: footerAttrs)
            (footerText as NSString).draw(
                at: CGPoint(x: cardRect.origin.x + (cardRect.width - footerSize.width) / 2, y: cardRect.maxY - 50),
                withAttributes: footerAttrs
            )
            
            // 4. Rodapé do Ecrã: Mensagem Informativa
            let bottomHelpText = "Fond d'écran d'urgence Mon Guide 72h • Visible sans déverrouiller"
            let bottomHelpAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 20, weight: .medium),
                .foregroundColor: UIColor.white.withAlphaComponent(0.4)
            ]
            let bottomHelpSize = (bottomHelpText as NSString).size(withAttributes: bottomHelpAttrs)
            (bottomHelpText as NSString).draw(
                at: CGPoint(x: (size.width - bottomHelpSize.width) / 2, y: size.height - 180),
                withAttributes: bottomHelpAttrs
            )
        }
    }
}
