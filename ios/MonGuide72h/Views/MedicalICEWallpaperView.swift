import SwiftUI

public struct MedicalICEWallpaperView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @ObservedObject var manager = MedicalICECardManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedTab: Int = 0 // 0: Preview Wallpaper, 1: Editar Ficha
    @State private var generatedImage: UIImage? = nil
    @State private var isShowingShareSheet = false
    @State private var showingSavedAlert = false
    
    // Form fields
    @State private var fullName: String = ""
    @State private var cnsMatricule: String = ""
    @State private var bloodGroup: String = "O+"
    @State private var allergies: String = ""
    @State private var medicalConditions: String = ""
    @State private var regularMedications: String = ""
    @State private var contact1Name: String = ""
    @State private var contact1Phone: String = ""
    @State private var contact2Name: String = ""
    @State private var contact2Phone: String = ""
    
    let bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-", "Inconnu"]
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Segmented tab
                Picker("", selection: $selectedTab) {
                    Text(loc.tr("ice_tab_preview")).tag(0)
                    Text(loc.tr("ice_tab_edit")).tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                
                if selectedTab == 0 {
                    previewTabContent
                } else {
                    editTabContent
                }
            }
            .navigationTitle(loc.tr("ice_view_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(loc.tr("close_btn")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear(perform: loadDataAndRender)
            .sheet(isPresented: $isShowingShareSheet) {
                if let img = generatedImage {
                    WallpaperShareSheet(image: img)
                }
            }
            .alert(isPresented: $showingSavedAlert) {
                Alert(
                    title: Text(loc.tr("ice_saved_photos_title")),
                    message: Text(loc.tr("ice_saved_photos_msg")),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // MARK: - PREVIEW TAB
    
    private var previewTabContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Info banner
                HStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(loc.tr("ice_banner_title"))
                            .font(.subheadline.bold())
                        Text(loc.tr("ice_banner_sub"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(12)
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.top, 4)
                
                // Phone frame preview
                ZStack {
                    if let img = generatedImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 460)
                            .cornerRadius(32)
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 4)
                            )
                            .shadow(color: Color.black.opacity(0.25), radius: 15, x: 0, y: 8)
                    } else {
                        ProgressView()
                            .frame(height: 400)
                    }
                }
                .padding(.vertical, 8)
                
                // Action Buttons
                VStack(spacing: 10) {
                    Button(action: saveToPhotoLibrary) {
                        HStack {
                            Image(systemName: "square.and.arrow.down.fill")
                            Text(loc.tr("ice_btn_save_photo"))
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: { isShowingShareSheet = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text(loc.tr("ice_btn_share_wallpaper"))
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(.secondarySystemBackground))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }
    
    // MARK: - EDIT FORM TAB
    
    private var editTabContent: some View {
        Form {
            Section(header: Text(loc.tr("ice_section_identity"))) {
                TextField(loc.tr("ice_field_name"), text: $fullName)
                TextField("CNS Matricule (ex: 19850101 12345)", text: $cnsMatricule)
                
                Picker(loc.tr("ice_field_blood"), selection: $bloodGroup) {
                    ForEach(bloodGroups, id: \.self) { g in
                        Text(g).tag(g)
                    }
                }
            }
            
            Section(header: Text(loc.tr("ice_section_allergies")), footer: Text(loc.tr("ice_allergies_hint"))) {
                TextField(loc.tr("ice_field_allergies"), text: $allergies)
                TextField(loc.tr("ice_field_conditions"), text: $medicalConditions)
                TextField(loc.tr("ice_field_medications"), text: $regularMedications)
            }
            
            Section(header: Text(loc.tr("ice_section_contacts"))) {
                TextField(loc.tr("ice_field_contact1_name"), text: $contact1Name)
                TextField(loc.tr("ice_field_contact1_phone"), text: $contact1Phone)
                    .keyboardType(.phonePad)
                
                TextField(loc.tr("ice_field_contact2_name"), text: $contact2Name)
                TextField(loc.tr("ice_field_contact2_phone"), text: $contact2Phone)
                    .keyboardType(.phonePad)
            }
            
            Section {
                Button(action: saveAndRegenerate) {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                        Text(loc.tr("ice_btn_save_changes"))
                            .bold()
                        Spacer()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
    
    // MARK: - LOGIC
    
    private func loadDataAndRender() {
        let c = manager.card
        self.fullName = c.fullName
        self.cnsMatricule = c.cnsMatricule
        self.bloodGroup = c.bloodGroup.isEmpty ? "O+" : c.bloodGroup
        self.allergies = c.allergies
        self.medicalConditions = c.medicalConditions
        self.regularMedications = c.regularMedications
        self.contact1Name = c.emergencyContactName
        self.contact1Phone = c.emergencyContactPhone
        self.contact2Name = c.secondaryContactName
        self.contact2Phone = c.secondaryContactPhone
        
        self.generatedImage = manager.generateLockScreenWallpaper(card: c)
    }
    
    private func saveAndRegenerate() {
        manager.card.fullName = fullName
        manager.card.cnsMatricule = cnsMatricule
        manager.card.bloodGroup = bloodGroup
        manager.card.allergies = allergies
        manager.card.medicalConditions = medicalConditions
        manager.card.regularMedications = regularMedications
        manager.card.emergencyContactName = contact1Name
        manager.card.emergencyContactPhone = contact1Phone
        manager.card.secondaryContactName = contact2Name
        manager.card.secondaryContactPhone = contact2Phone
        
        manager.saveCard()
        self.generatedImage = manager.generateLockScreenWallpaper(card: manager.card)
        withAnimation {
            selectedTab = 0
        }
    }
    
    private func saveToPhotoLibrary() {
        guard let img = generatedImage else { return }
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        showingSavedAlert = true
    }
}

// MARK: - SHARE SHEET

private struct WallpaperShareSheet: UIViewControllerRepresentable {
    let image: UIImage
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
