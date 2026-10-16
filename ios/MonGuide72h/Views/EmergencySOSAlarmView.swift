import SwiftUI
import MessageUI

public struct EmergencySOSAlarmView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @StateObject private var alarmManager = SOSAlarmManager.shared
    @StateObject private var locManager = LocationManager.shared
    @StateObject private var planVM = EmergencyPlanViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingMessageCompose = false
    @State private var showingCopiedAlert = false
    @State private var pulseAnimation = false
    @State private var showingHospitalMapSheet = false
    @State private var showingStrobeSheet = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Distress Alarm Giant Control
                    VStack(spacing: 16) {
                        ZStack {
                            if alarmManager.isAlarmPlaying {
                                Circle()
                                    .stroke(Color.red.opacity(0.3), lineWidth: 20)
                                    .frame(width: 170, height: 170)
                                    .scaleEffect(pulseAnimation ? 1.25 : 1.0)
                                    .opacity(pulseAnimation ? 0.0 : 1.0)
                                    .animation(Animation.easeOut(duration: 0.8).repeatForever(autoreverses: false), value: pulseAnimation)
                            }
                            
                            Button(action: {
                                if alarmManager.isAlarmPlaying {
                                    alarmManager.stopDistressAlarm()
                                } else {
                                    alarmManager.startDistressAlarm()
                                    pulseAnimation = true
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(alarmManager.isAlarmPlaying ? Color.red : Color(red: 220/255, green: 38/255, blue: 38/255))
                                        .frame(width: 140, height: 140)
                                        .shadow(color: Color.red.opacity(0.5), radius: 15, x: 0, y: 5)
                                    
                                    VStack(spacing: 6) {
                                        Image(systemName: alarmManager.isAlarmPlaying ? "speaker.slash.fill" : "speaker.wave.3.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                        Text(alarmManager.isAlarmPlaying ? loc.tr("sos_stop") : loc.tr("sos_start"))
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)
                        
                        Text(alarmManager.isAlarmPlaying ? loc.tr("sos_active_status") : loc.tr("sos_idle_status"))
                            .font(.caption.bold())
                            .foregroundColor(alarmManager.isAlarmPlaying ? .red : .secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Live GPS & Coordinates Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "location.north.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                            Text(loc.tr("gps_title"))
                                .font(.headline)
                            Spacer()
                            if locManager.isLocating {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(locManager.formattedCoordinates)
                                .font(.system(size: 20, weight: .black, design: .monospaced))
                                .foregroundColor(.primary)
                            
                            HStack {
                                Text(locManager.formattedAccuracy)
                                    .font(.caption.bold())
                                    .foregroundColor(.green)
                                Spacer()
                                Text(locManager.addressString)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(10)
                        
                        HStack(spacing: 8) {
                            // Copy Coordinates Button
                            Button(action: copyCoordinates) {
                                HStack(spacing: 4) {
                                    Image(systemName: "doc.on.doc.fill")
                                    Text(showingCopiedAlert ? loc.tr("gps_copied") : loc.tr("gps_copy"))
                                        .bold()
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.blue.opacity(0.12))
                                .cornerRadius(8)
                            }
                            
                            // Nearest Hospital Map Button
                            Button(action: {
                                showingHospitalMapSheet = true
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "cross.case.fill")
                                    Text(loc.tr("sos_btn_view_hospitals"))
                                        .bold()
                                }
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.red)
                                .cornerRadius(8)
                            }
                        }
                        
// Night Rescue Signaling / Strobe Button
                        Button(action: {
                            showingStrobeSheet = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "light.beacon.max.fill")
                                Text(loc.tr("sos_btn_strobe_beacon"))
                                    .bold()
                            }
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.orange)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Send SOS SMS Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "message.badge.filled.fill")
                                .foregroundColor(.orange)
                                .font(.title3)
                            Text(loc.tr("share_contacts_title"))
                                .font(.headline)
                        }
                        
                        Text(loc.tr("share_contacts_sub"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        // Contact tags
                        let contacts = planVM.plan.allEmergencyPhoneNumbers
                        if !contacts.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(contacts, id: \.phone) { c in
                                        HStack(spacing: 4) {
                                            Image(systemName: "person.crop.circle")
                                                .font(.caption2)
                                            Text("\(c.name) (\(c.phone))")
                                                .font(.caption2.bold())
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.orange.opacity(0.15))
                                        .foregroundColor(.orange)
                                        .cornerRadius(6)
                                    }
                                }
                            }
                        }
                        
                        Button(action: sendSOSSMS) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text(loc.tr("send_sos_sms"))
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
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // One-Touch 112 Call
                    Button(action: {
                        if let url = URL(string: "tel://112") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text(loc.tr("call_cgdis_action"))
                                .bold()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(red: 220/255, green: 38/255, blue: 38/255))
                        .cornerRadius(12)
                        .shadow(color: Color.red.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
                .padding()
            }
            .navigationTitle(loc.tr("sos_title"))
            .navigationBarItems(trailing: Button(loc.tr("close_btn")) {
                alarmManager.stopDistressAlarm()
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                locManager.requestPermissionAndStart()
            }
            .onDisappear {
                alarmManager.stopDistressAlarm()
                locManager.stopUpdating()
            }
            .sheet(isPresented: $showingMessageCompose) {
                MessageComposeView(
                    recipients: planVM.plan.allEmergencyPhoneNumbers.map { $0.phone },
                    body: generateSOSMessage()
                )
            }
        }
    }
    
    private func copyCoordinates() {
        let prefix: String
        switch loc.currentLanguage {
        case .pt:
            prefix = "EMERGÊNCIA 72h - Minhas coordenadas:"
        default:
            prefix = "URGENCE 72h - Mes coordonnées GPS :"
        }
        let text = "\(prefix) \(locManager.formattedCoordinates) (\(locManager.addressString)). Link: \(locManager.mapsAppleURL)"
        UIPasteboard.general.string = text
        showingCopiedAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showingCopiedAlert = false
        }
    }
    
    private func generateSOSMessage() -> String {
        switch loc.currentLanguage {
        case .pt:
            return "EMERGÊNCIA! Preciso de ajuda imediata. Localização atual: \(locManager.formattedCoordinates), \(locManager.addressString). Mapa: \(locManager.mapsAppleURL). [Enviado via app MonGuide 72h]"
        default:
            return "URGENCE ! J'ai besoin d'une assistance immédiate. Position GPS : \(locManager.formattedCoordinates), \(locManager.addressString). Lien Carte : \(locManager.mapsAppleURL). [Envoyé via l'application MonGuide 72h]"
        }
    }
    
    private func sendSOSSMS() {
        if MFMessageComposeViewController.canSendText() {
            showingMessageCompose = true
        } else {
            // Fallback for devices without native SMS composer
            let smsRecipients = planVM.plan.allEmergencyPhoneNumbers.map { $0.phone }.joined(separator: ",")
            let encodedBody = generateSOSMessage().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: "sms:\(smsRecipients)&body=\(encodedBody)") {
                UIApplication.shared.open(url)
            }
        }
    }
}

struct MessageComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var body: String
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = recipients
        vc.body = body
        vc.messageComposeDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposeView
        init(_ parent: MessageComposeView) {
            self.parent = parent
        }
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
        }
    }
}
