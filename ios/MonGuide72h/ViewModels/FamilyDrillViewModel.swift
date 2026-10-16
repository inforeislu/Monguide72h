import Foundation
import SwiftUI
import Combine

public enum DrillCategory: String, CaseIterable, Identifiable, Codable {
    case evacuation = "evacuation"
    case blackout = "blackout"
    case confinement = "confinement"
    case waterOutage = "waterOutage"
    
    public var id: String { rawValue }
    
    public var title: String {
        let lang = LocalizationManager.shared.currentLanguage
        if lang == .fr || lang == .lu || lang == .de {
            switch self {
            case .evacuation: return "Exercice d'Évacuation Rapide"
            case .blackout: return "Exercice de Panne d'Électricité"
            case .confinement: return "Exercice de Confinement Hermétique"
            case .waterOutage: return "Exercice de Coupure d'Eau"
            }
        }
        switch self {
        case .evacuation: return "Simulacro de Evacuação Rápida"
        case .blackout: return "Simulacro de Apagão Noturno"
        case .confinement: return "Simulacro de Confinamento Hermético"
        case .waterOutage: return "Simulacro de Corte Repentino de Água"
        }
    }
    
    public var subtitle: String {
        let lang = LocalizationManager.shared.currentLanguage
        if lang == .fr || lang == .lu || lang == .de {
            switch self {
            case .evacuation: return "Quitter le domicile avec le sac et rejoindre le point de rencontre."
            case .blackout: return "Trouver le kit 72h dans le noir, allumer la radio et couper le disjoncteur."
            case .confinement: return "Fermer portes/fenêtres, couper la VMC et écouter RTL 88.9 FM."
            case .waterOutage: return "Réserve immédiate, pastilles de purification et rationnement de 3L."
            }
        }
        switch self {
        case .evacuation: return "Saída de casa com mochila e reunião no ponto de encontro acordado."
        case .blackout: return "Localizar o kit 72h no escuro, ligar rádio a pilhas e desligar disjuntores."
        case .confinement: return "Selar portas/janelas, desligar ventilação e sintonizar RTL 88.9 FM."
        case .waterOutage: return "Reserva imediata, pastilhas potabilizadoras e racionamento diário de 3L."
        }
    }
    
    public var icon: String {
        switch self {
        case .evacuation: return "figure.run"
        case .blackout: return "bolt.slash.fill"
        case .confinement: return "house.lodge.fill"
        case .waterOutage: return "drop.fill"
        }
    }
    
    public var themeColor: Color {
        switch self {
        case .evacuation: return Color.red
        case .blackout: return Color(red: 0/255, green: 43/255, blue: 73/255)
        case .confinement: return Color.orange
        case .waterOutage: return Color.blue
        }
    }
    
    public var targetSeconds: Int {
        switch self {
        case .evacuation: return 180   // 3 min
        case .blackout: return 300     // 5 min
        case .confinement: return 420  // 7 min
        case .waterOutage: return 600  // 10 min
        }
    }
    
    public var initialTasks: [DrillTask] {
        switch self {
        case .evacuation:
            return [
                DrillTask(title: "Alertar todos os membros da família em voz alta", detail: "Sem gritar em pânico, reunir todos no piso térreo.", points: 15),
                DrillTask(title: "Calçar sapatos resistentes e agasalho", detail: "Nunca evacuar descalço ou em chinelos.", points: 15),
                DrillTask(title: "Apanhar a Mochila de Evacuação (Kit 72h)", detail: "Certificar-se de que documentos e medicação estão incluídos.", points: 25),
                DrillTask(title: "Segurar animais de estimação na trela/caixa", detail: "Com documento de identificação e comida.", points: 15),
                DrillTask(title: "Sair e fechar as portas atrás de si", detail: "Para abrandar a propagação de fogo/fumos.", points: 15),
                DrillTask(title: "Reunir no Ponto de Encontro 1 e fazer chamada", detail: "Confirmar que todos estão presentes e a salvo.", points: 15)
            ]
        case .blackout:
            return [
                DrillTask(title: "Não entrar em pânico e acender a lanterna LED", detail: "Evitar usar fósforos ou velas no início.", points: 20),
                DrillTask(title: "Localizar e abrir o Kit 72h no escuro", detail: "Encontrar pilhas sobressalentes e rádio.", points: 25),
                DrillTask(title: "Sintonizar o rádio a pilhas nas frequências oficiais", detail: "RTL 88.9 / 92.5 FM ou 100.7 FM.", points: 20),
                DrillTask(title: "Identificar o disjuntor principal da habitação", detail: "Saber onde cortar aparelhos sensíveis.", points: 20),
                DrillTask(title: "Confirmar que o frigorífico/congelador ficou fechado", detail: "Para conservar a temperatura por 6 horas.", points: 15)
            ]
        case .confinement:
            return [
                DrillTask(title: "Recolher todos os familiares e animais para o interior", detail: "Nenhum membro pode permanecer no jardim ou rua.", points: 20),
                DrillTask(title: "Fechar e trancar todas as janelas e portas exteriores", detail: "Baixar estores e persianas exteriores.", points: 20),
                DrillTask(title: "Desligar o sistema de ventilação mecânica (VMC)", detail: "Evitar a entrada de ar contaminado exterior.", points: 25),
                DrillTask(title: "Isolar a divisão central com fita adesiva ou panos húmidos", detail: "Preferir uma divisão sem janelas exteriores.", points: 20),
                DrillTask(title: "Ligar o rádio ou aceder ao infocrise.public.lu", detail: "Aguardar o sinal de fim de alerta das autoridades.", points: 15)
            ]
        case .waterOutage:
            return [
                DrillTask(title: "Localizar a válvula geral de corte de água da casa", detail: "Saber como fechar rapidamente caso haja contaminação.", points: 25),
                DrillTask(title: "Calcular a reserva de água potável disponível", detail: "Mínimo 3 litros por pessoa por dia x 3 dias.", points: 25),
                DrillTask(title: "Localizar as pastilhas purificadoras / filtro de água", detail: "Saber como dosar 1 pastilha por litro.", points: 25),
                DrillTask(title: "Encher recipientes limpos de emergência", detail: "Baldes, garrafas vazias e termos para uso sanitário.", points: 25)
            ]
        }
    }
}

public struct DrillTask: Identifiable, Codable, Equatable {
    public var id = UUID()
    public var title: String
    public var detail: String
    public var points: Int
    public var isCompleted: Bool = false
    
    public init(title: String, detail: String, points: Int, isCompleted: Bool = false) {
        self.title = title
        self.detail = detail
        self.points = points
        self.isCompleted = isCompleted
    }
}

public struct DrillHistoryRecord: Identifiable, Codable {
    public var id = UUID()
    public var category: DrillCategory
    public var date: Date
    public var elapsedSeconds: Int
    public var targetSeconds: Int
    public var scorePercentage: Int
    public var completedTasksCount: Int
    public var totalTasksCount: Int
    
    public var isTimeSuccess: Bool {
        elapsedSeconds <= targetSeconds
    }
    
    public var awardLevel: String {
        if scorePercentage >= 90 && isTimeSuccess {
            return "🥇 Nível Ouro (Excelência)"
        } else if scorePercentage >= 75 {
            return "🥈 Nível Prata (Bom Preparo)"
        } else if scorePercentage >= 50 {
            return "🥉 Nível Bronze (Apto com Melhorias)"
        } else {
            return "⚠️ Necessita Novo Treino"
        }
    }
}

public class FamilyDrillViewModel: ObservableObject {
    @Published public var selectedCategory: DrillCategory = .evacuation {
        didSet {
            resetDrill()
        }
    }
    
    @Published public var currentTasks: [DrillTask] = []
    @Published public var elapsedSeconds: Int = 0
    @Published public var isRunning: Bool = false
    @Published public var isFinished: Bool = false
    @Published public var history: [DrillHistoryRecord] = []
    
    private var timer: Timer?
    private let historyStorageKey = "family_drill_history_records"
    
    public init() {
        loadHistory()
        resetDrill()
    }
    
    public func resetDrill() {
        stopTimer()
        elapsedSeconds = 0
        isFinished = false
        currentTasks = selectedCategory.initialTasks
    }
    
    public func startDrill() {
        guard !isRunning else { return }
        isRunning = true
        isFinished = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedSeconds += 1
            
            // Audio prompt when target time is reached
            if self.elapsedSeconds == self.selectedCategory.targetSeconds {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }
        }
    }
    
    public func pauseDrill() {
        stopTimer()
    }
    
    public func completeDrill() {
        stopTimer()
        isFinished = true
        
        // Save record
        let record = DrillHistoryRecord(
            category: selectedCategory,
            date: Date(),
            elapsedSeconds: elapsedSeconds,
            targetSeconds: selectedCategory.targetSeconds,
            scorePercentage: currentScorePercentage,
            completedTasksCount: currentTasks.filter { $0.isCompleted }.count,
            totalTasksCount: currentTasks.count
        )
        history.insert(record, at: 0)
        saveHistory()
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    public func toggleTask(_ task: DrillTask) {
        if let idx = currentTasks.firstIndex(where: { $0.id == task.id }) {
            currentTasks[idx].isCompleted.toggle()
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            
            // Check if all tasks completed, auto-prompt complete
            if currentTasks.allSatisfy({ $0.isCompleted }) && isRunning {
                completeDrill()
            }
        }
    }
    
    public var currentScorePercentage: Int {
        let maxPoints = currentTasks.reduce(0) { $0 + $1.points }
        guard maxPoints > 0 else { return 0 }
        let earnedPoints = currentTasks.filter { $0.isCompleted }.reduce(0) { $0 + $1.points }
        
        var score = (earnedPoints * 100) / maxPoints
        // Slight penalty if time exceeded by more than 50%
        if elapsedSeconds > Int(Double(selectedCategory.targetSeconds) * 1.5) {
            score = max(0, score - 10)
        }
        return score
    }
    
    public var remainingSecondsToTarget: Int {
        max(0, selectedCategory.targetSeconds - elapsedSeconds)
    }
    
    public var isOvertime: Bool {
        elapsedSeconds > selectedCategory.targetSeconds
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyStorageKey),
           let list = try? JSONDecoder().decode([DrillHistoryRecord].self, from: data) {
            self.history = list
        }
    }
    
    private func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyStorageKey)
        }
    }
    
    public func clearHistory() {
        history.removeAll()
        UserDefaults.standard.removeObject(forKey: historyStorageKey)
    }
}
