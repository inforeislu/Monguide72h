import SwiftUI

public struct FamilyDrillView: View {
    @StateObject private var vm = FamilyDrillViewModel()
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingHistorySheet = false
    @State private var showingFinishAlert = false
    
    private var isFR: Bool {
        loc.currentLanguage == .fr || loc.currentLanguage == .lu || loc.currentLanguage == .de
    }
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Category Picker Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(DrillCategory.allCases) { cat in
                                Button(action: {
                                    vm.selectedCategory = cat
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: cat.icon)
                                        Text(cat.title)
                                            .font(.caption.bold())
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(vm.selectedCategory == cat ? cat.themeColor : Color(UIColor.secondarySystemBackground))
                                    .foregroundColor(vm.selectedCategory == cat ? .white : .primary)
                                    .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    
                    // Drill Overview Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: vm.selectedCategory.icon)
                                .font(.title2)
                                .foregroundColor(vm.selectedCategory.themeColor)
                            Text(vm.selectedCategory.title)
                                .font(.headline)
                            Spacer()
                            Text("Meta: \(vm.selectedCategory.targetSeconds / 60) min")
                                .font(.caption.bold())
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(vm.selectedCategory.themeColor.opacity(0.15))
                                .foregroundColor(vm.selectedCategory.themeColor)
                                .cornerRadius(6)
                        }
                        
                        Text(vm.selectedCategory.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(14)
                    
                    // Digital Stopwatch & Controls
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(vm.isOvertime ? (isFR ? "TEMPS DÉPASSÉ" : "TEMPO EXCEDIDO") : (isFR ? "CHRONO D'EXERCICE" : "CRONÓMETRO DE SIMULAÇÃO"))
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(vm.isOvertime ? .red : .secondary)
                                
                                Text(timeString(from: vm.elapsedSeconds))
                                    .font(.system(size: 42, weight: .black, design: .monospaced))
                                    .foregroundColor(vm.isOvertime ? .red : (vm.isRunning ? .green : .primary))
                            }
                            
                            Spacer()
                            
                            // Live Score Gauge
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(isFR ? "SCORE" : "PONTUAÇÃO")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.secondary)
                                Text("\(vm.currentScorePercentage)%")
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundColor(scoreColor(vm.currentScorePercentage))
                            }
                        }
                        
                        // Control Buttons
                        HStack(spacing: 12) {
                            if !vm.isRunning {
                                Button(action: {
                                    vm.startDrill()
                                }) {
                                    HStack {
                                        Image(systemName: "play.fill")
                                        Text(isFR ? (vm.elapsedSeconds == 0 ? "Démarrer l'Exercice" : "Reprendre") : (vm.elapsedSeconds == 0 ? "Começar Treino" : "Retomar"))
                                            .bold()
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.green)
                                    .cornerRadius(10)
                                }
                            } else {
                                Button(action: {
                                    vm.pauseDrill()
                                }) {
                                    HStack {
                                        Image(systemName: "pause.fill")
                                        Text(isFR ? "Pause" : "Pausar")
                                            .bold()
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.orange)
                                    .cornerRadius(10)
                                }
                            }
                            
                            if vm.isRunning || vm.elapsedSeconds > 0 {
                                Button(action: {
                                    vm.completeDrill()
                                    showingFinishAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "flag.checkered")
                                        Text(isFR ? "Terminer" : "Concluir")
                                            .bold()
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(vm.selectedCategory.themeColor)
                                    .cornerRadius(10)
                                }
                            }
                            
                            if vm.elapsedSeconds > 0 && !vm.isRunning {
                                Button(action: {
                                    vm.resetDrill()
                                }) {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.subheadline.bold())
                                        .foregroundColor(.secondary)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 14)
                                        .background(Color(UIColor.tertiarySystemFill))
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Spoken Voice Guide
                    VoiceGuideBar(
                        title: vm.selectedCategory.title,
                        textToSpeak: narrationTextForDrill()
                    )
                    
                    // Task Checklist
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "checklist")
                                .foregroundColor(.blue)
                            Text("PASSOS DO SIMULACRO EM FAMÍLIA")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(vm.currentTasks.filter { $0.isCompleted }.count)/\(vm.currentTasks.count) concluídos")
                                .font(.caption2.bold())
                                .foregroundColor(.secondary)
                        }
                        
                        ForEach(vm.currentTasks) { task in
                            Button(action: {
                                vm.toggleTask(task)
                            }) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundColor(task.isCompleted ? .green : .secondary)
                                        .padding(.top, 2)
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        HStack {
                                            Text(task.title)
                                                .font(.subheadline.bold())
                                                .foregroundColor(.primary)
                                                .strikethrough(task.isCompleted, color: .secondary)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                            Text("+\(task.points) pts")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(task.isCompleted ? .green : .secondary)
                                        }
                                        
                                        Text(task.detail)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                            Divider()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // History Quick Banner
                    Button(action: {
                        showingHistorySheet = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.blue)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(isFR ? "Historique des Exercices" : "Histórico de Simulacros")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.primary)
                                Text(isFR ? "\(vm.history.count) exercices réalisés précédemment" : "\(vm.history.count) treinos realizados anteriormente")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle(isFR ? "Entraînement en Famille" : "Treino em Família")
            .navigationBarItems(
                leading: Button(isFR ? "Historique" : "Histórico") {
                    showingHistorySheet = true
                },
                trailing: Button(isFR ? "Fermer" : "Fechar") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .sheet(isPresented: $showingHistorySheet) {
                DrillHistoryView(vm: vm)
            }
            .alert(isPresented: $showingFinishAlert) {
                Alert(
                    title: Text("Simulacro Concluído!"),
                    message: Text("Pontuação: \(vm.currentScorePercentage)%\nTempo: \(timeString(from: vm.elapsedSeconds))\nMeta: \(timeString(from: vm.selectedCategory.targetSeconds))\n\nO registo foi guardado no histórico de prontidão familiar."),
                    dismissButton: .default(Text("Ver Avaliação"))
                )
            }
        }
    }
    
    private func scoreColor(_ score: Int) -> Color {
        if score >= 85 { return .green }
        if score >= 60 { return .orange }
        return .red
    }
    
    private func timeString(from seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
    
    private func narrationTextForDrill() -> String {
        var str = "Início do \(vm.selectedCategory.title). "
        str += "Tempo meta: \(vm.selectedCategory.targetSeconds / 60) minutos. "
        str += "Objetivo: \(vm.selectedCategory.subtitle) "
        str += "Passos práticos: "
        for (idx, task) in vm.currentTasks.enumerated() {
            str += "Passo \(idx + 1): \(task.title). \(task.detail). "
        }
        return str
    }
}

// MARK: - DRILL HISTORY SHEET

struct DrillHistoryView: View {
    @ObservedObject var vm: FamilyDrillViewModel
    @Environment(\.presentationMode) var presentationMode
    
    private var isFR: Bool {
        LocalizationManager.shared.currentLanguage == .fr || LocalizationManager.shared.currentLanguage == .lu || LocalizationManager.shared.currentLanguage == .de
    }
    
    var body: some View {
        NavigationView {
            List {
                if vm.history.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "figure.walk.motion")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        Text(isFR ? "Aucun exercice enregistré" : "Nenhum simulacro gravado")
                            .font(.headline)
                        Text("Realize um simulacro com a sua família para registar tempos e avaliar a sua prontidão de resposta.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity)
                } else {
                    ForEach(vm.history) { rec in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(rec.category.title)
                                    .font(.subheadline.bold())
                                Spacer()
                                Text(rec.awardLevel)
                                    .font(.caption.bold())
                            }
                            
                            HStack {
                                Text(formattedDate(rec.date))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("Tempo: \(formatSeconds(rec.elapsedSeconds)) (Meta: \(formatSeconds(rec.targetSeconds)))")
                                    .font(.caption.bold())
                                    .foregroundColor(rec.isTimeSuccess ? .green : .red)
                            }
                            
                            HStack {
                                Text("Tarefas: \(rec.completedTasksCount)/\(rec.totalTasksCount)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("Nota: \(rec.scorePercentage)%")
                                    .font(.subheadline.bold())
                                    .foregroundColor(rec.scorePercentage >= 80 ? .green : (rec.scorePercentage >= 60 ? .orange : .red))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    Section {
                        Button(isFR ? "Effacer Tout l'Historique" : "Limpar Todo o Histórico", role: .destructive) {
                            vm.clearHistory()
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(isFR ? "Historique des Exercices" : "Histórico de Simulacros")
            .navigationBarItems(trailing: Button(isFR ? "Fermer" : "Fechar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatSeconds(_ s: Int) -> String {
        let m = s / 60
        let sec = s % 60
        return String(format: "%02d:%02d", m, sec)
    }
}
