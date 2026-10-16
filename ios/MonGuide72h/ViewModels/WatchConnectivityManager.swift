import Foundation
import WatchConnectivity
import Combine

public final class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    public static let shared = WatchConnectivityManager()
    
    @Published public var isWatchAppInstalled: Bool = false
    @Published public var isPaired: Bool = false
    @Published public var isReachable: Bool = false
    @Published public var lastSyncTimestamp: Date? = nil
    
    public override init() {
        super.init()
        setupSession()
    }
    
    public func setupSession() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    public func buildPayload() -> [String: Any] {
        let planVM = EmergencyPlanViewModel()
        let widgetSnapshot = WidgetDataManager.shared.currentSnapshot
        
        var contacts: [[String: String]] = []
        for contact in planVM.plan.allEmergencyPhoneNumbers {
            contacts.append([
                "name": contact.name,
                "phone": contact.phone,
                "role": "ICE Familiar"
            ])
        }
        
        let payload: [String: Any] = [
            "readinessScore": widgetSnapshot.readinessScore,
            "waterReadyLitres": widgetSnapshot.waterLitersReady,
            "waterTargetLitres": widgetSnapshot.waterLitersTarget,
            "bagCheckedCount": widgetSnapshot.bagCheckedCount,
            "bagTotalCount": widgetSnapshot.bagTotalCount,
            "daysOfAutonomy": widgetSnapshot.daysOfAutonomy,
            "meetingPoint1": planVM.plan.meetingPoint1,
            "meetingPoint2": planVM.plan.meetingPoint2,
            "waterValveLocation": planVM.plan.waterValveLocation,
            "gasValveLocation": planVM.plan.gasValveLocation,
            "electricBreakerLocation": planVM.plan.electricBreakerLocation,
            "extinguisherLocation": planVM.plan.extinguisherLocation,
            "outOfAreaContact": planVM.plan.outOfAreaContact,
            "homeNotes": planVM.plan.homeNotes,
            "iceContacts": contacts,
            "lastSyncTimestamp": Date().timeIntervalSince1970
        ]
        return payload
    }
    
    public func sendSnapshotToWatch() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        guard session.activationState == .activated else { return }
        
        let payload = buildPayload()
        
        do {
            try session.updateApplicationContext(payload)
            DispatchQueue.main.async {
                self.lastSyncTimestamp = Date()
            }
        } catch {
            print("[WatchConnectivity] Erro ao atualizar contexto: \(error.localizedDescription)")
        }
        
        if session.isReachable {
            session.sendMessage(payload, replyHandler: nil) { err in
                print("[WatchConnectivity] Erro ao enviar mensagem direta: \(err.localizedDescription)")
            }
        }
    }
    
    // MARK: - WCSessionDelegate
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isPaired = session.isPaired
            self.isWatchAppInstalled = session.isWatchAppInstalled
            self.isReachable = session.isReachable
        }
        if activationState == .activated {
            sendSnapshotToWatch()
        }
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {}
    
    public func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    
    public func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["request"] as? String == "refresh" {
            let reply = buildPayload()
            replyHandler(reply)
            DispatchQueue.main.async {
                self.lastSyncTimestamp = Date()
            }
        }
    }
}
