import SwiftUI

public struct FamilyPlanSharingView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @ObservedObject var vm: EmergencyPlanViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedTab: Int = 0 // 0: Gerar QR Code, 1: Ler QR Code
    @State private var qrCodeImage: UIImage? = nil
    @State private var isExportingAirDrop = false
    @State private var exportedFileURL: URL? = nil
    
    // Scanner & Import state
    @State private var isShowingFileImporter = false
    @State private var importedPlanCandidate: EmergencyPlan? = nil
    @State private var showingImportConfirmation = false
    @State private var errorMessage: String? = nil
    @State private var showingErrorAlert = false
    @State private var showingSaveSuccessAlert = false
    
    public init(vm: EmergencyPlanViewModel) {
        self.vm = vm
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Segmented Switcher
                Picker("", selection: $selectedTab) {
                    Text(loc.tr("share_tab_show_qr")).tag(0)
                    Text(loc.tr("share_tab_scan_qr")).tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                
                if selectedTab == 0 {
                    qrDisplayView
                } else {
                    scannerTabContent
                }
            }
            .navigationTitle(loc.tr("share_view_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(loc.tr("close_btn")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear(perform: generateCode)
            .sheet(isPresented: $showingImportConfirmation) {
                if let candidate = importedPlanCandidate {
                    importConfirmationSheet(candidate)
                }
            }
            .sheet(isPresented: $isExportingAirDrop) {
                if let url = exportedFileURL {
                    ShareActivityView(activityItems: [url])
                }
            }
            .fileImporter(
                isPresented: $isShowingFileImporter,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false
            ) { result in
                handleFileImport(result: result)
            }
            .alert(isPresented: $showingSaveSuccessAlert) {
                Alert(
                    title: Text(loc.tr("share_import_success_title")),
                    message: Text(loc.tr("share_import_success_msg")),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    
    // MARK: - TAB 1: GERAR E EXIBIR QR CODE
    
    private var qrDisplayView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header badge
                HStack(spacing: 6) {
                    Image(systemName: "wifi.slash")
                        .foregroundColor(.green)
                    Text(loc.tr("share_offline_badge"))
                        .font(.caption.bold())
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.12))
                .cornerRadius(20)
                .padding(.top, 10)
                
                // QR Code Card
                VStack(spacing: 12) {
                    if let img = qrCodeImage {
                        Image(uiImage: img)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .padding(14)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
                    } else {
                        ProgressView()
                            .frame(width: 250, height: 250)
                    }
                    
                    Text(loc.tr("share_scan_instruction"))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Summary Card
                VStack(alignment: .leading, spacing: 8) {
                    Text(loc.tr("share_summary_title"))
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                        Text(vm.plan.ownerName.isEmpty ? loc.tr("plan_family_default") : vm.plan.ownerName)
                            .font(.subheadline.bold())
                        Spacer()
                        Text("\(vm.plan.members.count) \(loc.tr("share_members_count"))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if !vm.plan.meetingPoint1.isEmpty {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                            Text(vm.plan.meetingPoint1)
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(14)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                // Action Buttons
                VStack(spacing: 10) {
                    // AirDrop / Share File Button
                    Button(action: prepareAirDropFile) {
                        HStack {
                            Image(systemName: "airdrop")
                                .font(.headline)
                            Text(loc.tr("share_btn_airdrop"))
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
    }
    
    // MARK: - TAB 2: LER QR CODE
    
    private var scannerTabContent: some View {
        VStack(spacing: 16) {
            // Camera scanner view
            ZStack {
                QRCodeScannerView(
                    onScan: { rawValue in
                        handleScannedCode(rawValue)
                    },
                    onDismiss: {
                        selectedTab = 0
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 3)
                )
                .padding(.horizontal, 16)
                
                // Reticle / target frame
                VStack {
                    Image(systemName: "viewfinder")
                        .font(.system(size: 80, weight: .ultraLight))
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            
            // Or import JSON file button
            Button(action: { isShowingFileImporter = true }) {
                HStack {
                    Image(systemName: "doc.badge.plus")
                    Text(loc.tr("share_btn_import_file"))
                        .font(.subheadline.bold())
                }
                .foregroundColor(.blue)
                .padding(.vertical, 8)
            }
            .padding(.bottom, 12)
        }
        .padding(.top, 10)
    }
    
    // MARK: - IMPORT CONFIRMATION SHEET
    
    private func importConfirmationSheet(_ candidate: EmergencyPlan) -> some View {
        NavigationView {
            Form {
                Section(header: Text(loc.tr("share_import_preview_header"))) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(candidate.ownerName.isEmpty ? loc.tr("plan_family_default") : candidate.ownerName)
                                .font(.headline)
                            Text("\(candidate.address) \(candidate.city)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text(loc.tr("share_preview_members"))
                        Spacer()
                        Text("\(candidate.members.count)")
                            .bold()
                    }
                    
                    HStack {
                        Text(loc.tr("share_preview_contacts"))
                        Spacer()
                        Text("\(candidate.allEmergencyPhoneNumbers.count)")
                            .bold()
                    }
                    
                    if !candidate.meetingPoint1.isEmpty {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(loc.tr("share_preview_meeting1"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(candidate.meetingPoint1)
                                .font(.subheadline)
                        }
                    }
                }
                
                Section(footer: Text(loc.tr("share_import_warning_footer")).foregroundColor(.red)) {
                    Button(action: {
                        applyImportedPlan(candidate)
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.down.doc.fill")
                            Text(loc.tr("share_btn_confirm_import"))
                                .bold()
                            Spacer()
                        }
                        .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle(loc.tr("share_import_modal_title"))
            .navigationBarItems(trailing: Button(loc.tr("close_btn")) {
                showingImportConfirmation = false
            })
        }
    }
    
    // MARK: - LOGIC HELPERS
    
    private func generateCode() {
        if let payload = PlanSharingManager.shared.encodePlanToPayload(vm.plan) {
            self.qrCodeImage = PlanSharingManager.shared.generateQRCode(from: payload)
        }
    }
    
    private func prepareAirDropFile() {
        if let url = PlanSharingManager.shared.exportPlanFile(plan: vm.plan) {
            self.exportedFileURL = url
            self.isExportingAirDrop = true
        }
    }
    
    private func handleScannedCode(_ raw: String) {
        if let plan = PlanSharingManager.shared.decodePlanFromPayload(raw) {
            self.importedPlanCandidate = plan
            self.showingImportConfirmation = true
        } else {
            errorMessage = loc.tr("share_error_invalid_qr")
            showingErrorAlert = true
        }
    }
    
    private func handleFileImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                if let plan = PlanSharingManager.shared.importPlanFromFile(url: url) {
                    self.importedPlanCandidate = plan
                    self.showingImportConfirmation = true
                }
            }
        case .failure(let error):
            print("File import error: \(error)")
        }
    }
    
    private func applyImportedPlan(_ candidate: EmergencyPlan) {
        vm.plan = candidate
        vm.savePlan()
        showingImportConfirmation = false
        showingSaveSuccessAlert = true
    }
}

// MARK: - UIActivityViewController Wrapper for AirDrop

private struct ShareActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
