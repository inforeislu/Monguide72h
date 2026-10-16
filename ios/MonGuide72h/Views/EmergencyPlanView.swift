import SwiftUI
import PDFKit

public struct EmergencyPlanView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @StateObject var vm = EmergencyPlanViewModel()
    @ObservedObject var watchManager = WatchConnectivityManager.shared
    @State private var showingShareSheet = false
    @State private var showingDrillSheet = false
    @State private var showingFamilyShareSheet = false
    @State private var pdfURLToShare: URL? = nil
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                // Actions: Export & Practical Drill
                Section {
                    Button(action: exportPDF) {
                        HStack {
                            Image(systemName: "printer.fill")
                            Text(loc.tr("print_pdf"))
                                .bold()
                        }
                        .foregroundColor(Color(red: 0/255, green: 43/255, blue: 73/255))
                    }
                    
                                        Button(action: { showingFamilyShareSheet = true }) {
                        HStack {
                            Image(systemName: "qrcode")
                            Text(loc.tr("plan_share_family_btn"))
                                .bold()
                        }
                        .foregroundColor(.blue)
                    }
                    Button(action: { showingDrillSheet = true }) {
                        HStack {
                            Image(systemName: "figure.walk.motion")
                            Text(loc.tr("plan_drill_button"))
                                .bold()
                        }
                        .foregroundColor(.green)
                    }
                }
                
                // Apple Watch Synchronization Section
                Section {
                    HStack(spacing: 12) {
                        Image(systemName: "applewatch")
                            .font(.title2)
                            .foregroundColor(watchManager.isPaired ? .blue : .secondary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(watchManager.isPaired ? "Apple Watch Sincronizado" : "Apple Watch")
                                .font(.subheadline.bold())
                            Text(watchManager.isPaired ? "Contactos ICE, Válvulas e Plano no pulso" : "Emparelhe um Apple Watch para acesso offline")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if watchManager.isPaired {
                            Button(action: {
                                watchManager.sendSnapshotToWatch()
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .padding(.vertical, 2)
                }
                
                // Owner Info
                Section(header: Text(loc.tr("plan_identity"))) {
                    TextField(loc.tr("plan_owner_name"), text: $vm.plan.ownerName)
                        .onChange(of: vm.plan.ownerName) { _ in vm.savePlan() }
                    TextField(loc.tr("plan_address"), text: $vm.plan.address)
                        .onChange(of: vm.plan.address) { _ in vm.savePlan() }
                    TextField(loc.tr("plan_city"), text: $vm.plan.city)
                        .onChange(of: vm.plan.city) { _ in vm.savePlan() }
                }
                
                // 1. Members
                Section(header: HStack {
                    Text(loc.tr("plan_members"))
                    Spacer()
                    Button(loc.tr("plan_add_member")) { vm.addMember() }
                        .font(.caption.bold())
                }) {
                    ForEach(Array(vm.plan.members.enumerated()), id: \.element.id) { idx, member in
                        if idx < vm.plan.members.count {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    TextField(loc.tr("plan_member_fullname"), text: $vm.plan.members[idx].fullName)
                                        .font(.subheadline.bold())
                                    Spacer()
                                    Button(action: { vm.removeMember(at: idx) }) {
                                        Image(systemName: "trash").foregroundColor(.red).font(.caption)
                                    }
                                }
                                HStack {
                                    TextField(loc.tr("plan_phone"), text: $vm.plan.members[idx].phone)
                                        .keyboardType(.phonePad)
                                    TextField(loc.tr("plan_cns"), text: $vm.plan.members[idx].matricule)
                                }
                                Picker(loc.tr("plan_blood_group"), selection: $vm.plan.members[idx].bloodGroup) {
                                    ForEach(["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-", "Desc."], id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                // 2. Installations
                Section(header: Text(loc.tr("plan_valves"))) {
                    TextField(loc.tr("plan_water_valve"), text: $vm.plan.waterValveLocation)
                        .onChange(of: vm.plan.waterValveLocation) { _ in vm.savePlan() }
                    TextField(loc.tr("plan_gas_valve"), text: $vm.plan.gasValveLocation)
                        .onChange(of: vm.plan.gasValveLocation) { _ in vm.savePlan() }
                    TextField(loc.tr("plan_electric_breaker"), text: $vm.plan.electricBreakerLocation)
                        .onChange(of: vm.plan.electricBreakerLocation) { _ in vm.savePlan() }
                    TextField(loc.tr("plan_extinguisher"), text: $vm.plan.extinguisherLocation)
                        .onChange(of: vm.plan.extinguisherLocation) { _ in vm.savePlan() }
                    TextField(loc.tr("plan_garage_manual"), text: $vm.plan.garageManualInstructions)
                        .onChange(of: vm.plan.garageManualInstructions) { _ in vm.savePlan() }
                    TextField(loc.tr("plan_escape_route"), text: $vm.plan.escapeRoute)
                        .onChange(of: vm.plan.escapeRoute) { _ in vm.savePlan() }
                }
                
                // 3. Meeting Points
                Section(header: Text(loc.tr("plan_meeting"))) {
                    TextField(loc.tr("plan_meet_1"), text: $vm.plan.meetingPoint1)
                        .onChange(of: vm.plan.meetingPoint1) { _ in vm.savePlan() }
                    TextField(loc.tr("plan_meet_2"), text: $vm.plan.meetingPoint2)
                        .onChange(of: vm.plan.meetingPoint2) { _ in vm.savePlan() }
                    TextField(loc.tr("plan_school_pickup"), text: $vm.plan.schoolPickupPerson)
                        .onChange(of: vm.plan.schoolPickupPerson) { _ in vm.savePlan() }
                    TextField(loc.tr("plan_out_of_area_contact"), text: $vm.plan.outOfAreaContact)
                        .keyboardType(.phonePad)
                        .onChange(of: vm.plan.outOfAreaContact) { _ in vm.savePlan() }
                }
                
                // 4. Solidariedade Local
                Section(header: HStack {
                    Text(loc.tr("plan_neighbors"))
                    Spacer()
                    Button(loc.tr("plan_add_neighbor")) { vm.addNeighbor(type: "give") }
                        .font(.caption.bold())
                }) {
                    ForEach(Array(vm.plan.neighborsGivingHelp.enumerated()), id: \.element.id) { idx, n in
                        if idx < vm.plan.neighborsGivingHelp.count {
                            HStack {
                                TextField(loc.tr("plan_neighbor_name"), text: $vm.plan.neighborsGivingHelp[idx].name)
                                TextField("Telemóvel", text: $vm.plan.neighborsGivingHelp[idx].phone)
                                    .keyboardType(.phonePad)
                            }
                        }
                    }
                }
                
                // 5. Animais
                Section(header: HStack {
                    Text(loc.tr("plan_pets"))
                    Spacer()
                    Button(loc.tr("plan_add_pet")) { vm.addPet() }
                        .font(.caption.bold())
                }) {
                    ForEach(Array(vm.plan.pets.enumerated()), id: \.element.id) { idx, pet in
                        if idx < vm.plan.pets.count {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    TextField(loc.tr("plan_pet_name"), text: $vm.plan.pets[idx].name)
                                    TextField(loc.tr("plan_pet_species"), text: $vm.plan.pets[idx].species)
                                    Button(action: { vm.removePet(at: idx) }) {
                                        Image(systemName: "trash").foregroundColor(.red).font(.caption)
                                    }
                                }
                                TextField(loc.tr("plan_pet_chip"), text: $vm.plan.pets[idx].info)
                            }
                        }
                    }
                }
                
                // 6. Important Numbers
                Section(header: Text(loc.tr("plan_contacts"))) {
                    TextField(loc.tr("plan_telecom"), text: $vm.plan.telecomProvider)
                    TextField(loc.tr("plan_electricity"), text: $vm.plan.electricityProvider)
                    TextField(loc.tr("plan_gas"), text: $vm.plan.gasProvider)
                    TextField(loc.tr("plan_water"), text: $vm.plan.waterProvider)
                    TextField(loc.tr("plan_insurance"), text: $vm.plan.insurancePolicy)
                    TextField(loc.tr("plan_doctor"), text: $vm.plan.familyDoctor)
                }
            }
            .navigationTitle(loc.tr("tab_plan"))
            .sheet(isPresented: $showingShareSheet) {
                if let url = pdfURLToShare {
                    ShareSheet(activityItems: [url])
                }
            }
            .sheet(isPresented: $showingDrillSheet) {
                FamilyDrillView()
            }
        }
    }
    
    private func exportPDF() {
        vm.savePlan()
        let kitVM = KitCalculatorViewModel()
        let bagKeys = Set(UserDefaults.standard.array(forKey: "mon_guide_72h_evacuation_bag_checked") as? [String] ?? [])
        if let url = PDFExportManager.shared.generateCompleteEmergencyDossier(
            plan: vm.plan,
            kitVM: kitVM,
            bagCheckedKeys: bagKeys,
            language: loc.currentLanguage
        ) {
            self.pdfURLToShare = url
            self.showingShareSheet = true
        }
    }
}
