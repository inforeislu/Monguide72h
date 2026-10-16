import Foundation
import SwiftUI
import Combine
import PDFKit

public class EmergencyPlanViewModel: ObservableObject {
    @Published public var plan: EmergencyPlan = EmergencyPlan()
    
    private let storageKey = "mon_guide_72h_saved_plan"
    
    public init() {
        loadPlan()
    }
    
    public func savePlan() {
        plan.dateUpdated = Date()
        if let data = try? JSONEncoder().encode(plan) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
        // Update widgets and send to Apple Watch
        WidgetDataManager.shared.refreshSnapshot()
    }
    
    public func loadPlan() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode(EmergencyPlan.self, from: data) {
            self.plan = saved
        }
    }
    
    public func addMember() {
        plan.members.append(HouseholdMember())
        savePlan()
    }
    
    public func removeMember(at index: Int) {
        guard plan.members.indices.contains(index) else { return }
        plan.members.remove(at: index)
        savePlan()
    }
    
    public func addMedicalEntry() {
        plan.medicalList.append(MedicalEntry())
        savePlan()
    }
    
    public func removeMedicalEntry(at index: Int) {
        guard plan.medicalList.indices.contains(index) else { return }
        plan.medicalList.remove(at: index)
        savePlan()
    }
    
    public func addPet() {
        plan.pets.append(PetEntry())
        savePlan()
    }
    
    public func removePet(at index: Int) {
        guard plan.pets.indices.contains(index) else { return }
        plan.pets.remove(at: index)
        savePlan()
    }
    
    public func addNeighbor(type: String) {
        if type == "give" {
            plan.neighborsGivingHelp.append(NeighborContact(helpType: "give"))
        } else {
            plan.neighborsNeedingHelp.append(NeighborContact(helpType: "receive"))
        }
        savePlan()
    }
    
    public func removeNeighbor(type: String, at index: Int) {
        if type == "give" {
            guard plan.neighborsGivingHelp.indices.contains(index) else { return }
            plan.neighborsGivingHelp.remove(at: index)
        } else {
            guard plan.neighborsNeedingHelp.indices.contains(index) else { return }
            plan.neighborsNeedingHelp.remove(at: index)
        }
        savePlan()
    }
    
    /// Generates a clean A4 PDF document for printing or offline storage
    public func generatePDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Mon Guide 72h - Lëtz prepare !",
            kCGPDFContextAuthor: plan.ownerName.isEmpty ? "Famille" : plan.ownerName,
            kCGPDFContextTitle: "Mon Plan Personnel d'Urgence"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth: CGFloat = 595.2 // A4 standard width
        let pageHeight: CGFloat = 841.8 // A4 standard height
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            // Header Title
            let titleFont = UIFont.boldSystemFont(ofSize: 16)
            let headerText = "LËTZ PREPARE ! — PLAN PERSONNEL D'URGENCE"
            headerText.draw(at: CGPoint(x: 40, y: 35), withAttributes: [.font: titleFont, .foregroundColor: UIColor(red: 0/255, green: 43/255, blue: 73/255, alpha: 1.0)])
            
            let bodyFont = UIFont.systemFont(ofSize: 10)
            let boldFont = UIFont.boldSystemFont(ofSize: 10)
            let sectionHeaderFont = UIFont.boldSystemFont(ofSize: 11)
            
            var y: CGFloat = 65
            
            // Ownership
            let owner = plan.ownerName.isEmpty ? "—" : plan.ownerName
            let address = plan.address.isEmpty ? "—" : plan.address
            let city = plan.city.isEmpty ? "—" : plan.city
            "Responsable du foyer : \(owner)".draw(at: CGPoint(x: 40, y: y), withAttributes: [.font: boldFont])
            y += 15
            "Adresse : \(address), \(city)".draw(at: CGPoint(x: 40, y: y), withAttributes: [.font: bodyFont])
            y += 20
            
            // Section 1: Members
            "1. HABITANTS DU FOYER".draw(at: CGPoint(x: 40, y: y), withAttributes: [.font: sectionHeaderFont, .foregroundColor: UIColor.red])
            y += 14
            for (idx, m) in plan.members.enumerated() {
                let name = m.fullName.isEmpty ? "Membre \(idx+1)" : m.fullName
                let phone = m.phone.isEmpty ? "—" : m.phone
                let cns = m.matricule.isEmpty ? "—" : m.matricule
                let bg = m.bloodGroup
                let text = "• \(name) | Tél: \(phone) | CNS: \(cns) | Groupe: \(bg)"
                text.draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
                y += 13
            }
            y += 10
            
            // Medical
            if !plan.medicalList.isEmpty {
                "SANTÉ & ALLERGIES".draw(at: CGPoint(x: 40, y: y), withAttributes: [.font: sectionHeaderFont, .foregroundColor: UIColor.red])
                y += 14
                for entry in plan.medicalList {
                    let text = "• \(entry.personName) : Allergies: \(entry.allergies) | Traitement: \(entry.medications) (\(entry.dosage))"
                    text.draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
                    y += 13
                }
                y += 10
            }
            
            // Pets
            if !plan.pets.isEmpty {
                "ANIMAUX DU FOYER".draw(at: CGPoint(x: 40, y: y), withAttributes: [.font: sectionHeaderFont, .foregroundColor: UIColor.red])
                y += 14
                for pet in plan.pets {
                    let text = "• \(pet.species) - \(pet.name) (\(pet.info))"
                    text.draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
                    y += 13
                }
                y += 10
            }
            
            // Section 2: House shutoffs
            "2. INSTALLATIONS DU DOMICILE".draw(at: CGPoint(x: 40, y: y), withAttributes: [.font: sectionHeaderFont, .foregroundColor: UIColor.red])
            y += 14
            "• Robinet général d'eau : \(plan.waterValveLocation.isEmpty ? "—" : plan.waterValveLocation)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 13
            "• Vanne générale de gaz : \(plan.gasValveLocation.isEmpty ? "—" : plan.gasValveLocation)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 13
            "• Disjoncteur électrique : \(plan.electricBreakerLocation.isEmpty ? "—" : plan.electricBreakerLocation)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 13
            "• Extincteur / Couverture anti-feu : \(plan.extinguisherLocation.isEmpty ? "—" : plan.extinguisherLocation)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 13
            "• Déverrouillage manuel garage : \(plan.garageManualInstructions.isEmpty ? "—" : plan.garageManualInstructions)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 13
            "• Issue de secours secondaire : \(plan.escapeRoute.isEmpty ? "—" : plan.escapeRoute)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 16
            
            // Section 3: Meeting points & contacts
            "3. POINTS DE RETROUVAILLES & ÉVACUATION".draw(at: CGPoint(x: 40, y: y), withAttributes: [.font: sectionHeaderFont, .foregroundColor: UIColor.red])
            y += 14
            "• Point de ralliement 1 (Quartier) : \(plan.meetingPoint1.isEmpty ? "—" : plan.meetingPoint1)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 13
            "• Point de ralliement 2 (Hors commune) : \(plan.meetingPoint2.isEmpty ? "—" : plan.meetingPoint2)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 13
            "• Récupération enfants à l'école : \(plan.schoolPickupPerson.isEmpty ? "—" : plan.schoolPickupPerson)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 13
            "• Contact d'urgence hors région : \(plan.outOfAreaContact.isEmpty ? "—" : plan.outOfAreaContact)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 13
            "• Hébergement d'urgence chez : \(plan.emergencyShelterContact.isEmpty ? "—" : plan.emergencyShelterContact)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
            y += 16
            
            // Section 4: Emergency numbers
            "4. NUMÉROS D'URGENCE NATIONAUX (LUXEMBOURG)".draw(at: CGPoint(x: 40, y: y), withAttributes: [.font: sectionHeaderFont, .foregroundColor: UIColor.red])
            y += 14
            "• 112 : CGDIS (Secours, Ambulances & Pompiers)".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: boldFont])
            y += 13
            "• 113 : Police Grand-Ducale".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: boldFont])
            y += 13
            "• 8002 7788 : Info-Crise Gouvernemental".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: boldFont])
            y += 13
            "• Radios officielles d'urgence : RTL Radio (88.9 & 92.5 MHz) | Radio 100.7 FM".draw(at: CGPoint(x: 50, y: y), withAttributes: [.font: bodyFont])
        }
        
        return data
    }
}
