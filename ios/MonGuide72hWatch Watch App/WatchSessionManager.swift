import Foundation
import WatchConnectivity
import Combine
import WatchKit

public struct WatchICEContact: Identifiable, Codable {
    public var id: String
    public var name: String
    public var phone: String
    public var role: String
    
    public init(id: String = UUID().uuidString, name: String, phone: String, role: String = "") {
        self.id = id
        self.name = name
        self.phone = phone
        self.role = role
    }
}

public struct WatchValveInfo: Codable {
    public var water: String = ""
    public var gas: String = ""
    public var breaker: String = ""
    public var extinguisher: String = ""
    
    public init(water: String = "", gas: String = "", breaker: String = "", extinguisher: String = "") {
        self.water = water
        self.gas = gas
        self.breaker = breaker
        self.extinguisher = extinguisher
    }
}

public class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    public static let shared = WatchSessionManager()
    
    @Published public var readinessScore: Int = 85
    @Published public var waterReadyLitres: Double = 18.0
    @Published public var waterTargetLitres: Double = 18.0
    @Published public var bagCheckedCount: Int = 11
    @Published public var bagTotalCount: Int = 15
    @Published public var daysOfAutonomy: Int = 3
    @Published public var meetingPoint1: String = ""
    @Published public var meetingPoint2: String = ""
    @Published public var valveLocations: WatchValveInfo = WatchValveInfo()
    @Published public var emergencyNotes: String = ""
    @Published public var iceContacts: [WatchICEContact] = []
    @Published public var lastSyncDate: Date? = nil
    @Published public var isReachable: Bool = false
    @Published public var isSyncing: Bool = false
    
    private let cacheKey = "mon_guide_72h_watch_synced_data"
    
    public override init() {
        super.init()
        loadCache()
        activateSession()
    }
    
    public func activateSession() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
    
    public func requestSyncFromPhone() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        guard session.activationState == .activated else {
            activateSession()
            return
        }
        
        isSyncing = true
        WKInterfaceDevice.current().play(.click)
        
        // Check if there is already latest applicationContext
        if !session.receivedApplicationContext.isEmpty {
            applyData(from: session.receivedApplicationContext)
        }
        
        if session.isReachable {
            session.sendMessage(["request": "refresh"]) { [weak self] reply in
                DispatchQueue.main.async {
                    self?.applyData(from: reply)
                    self?.isSyncing = false
                    WKInterfaceDevice.current().play(.success)
                }
            } errorHandler: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.isSyncing = false
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.isSyncing = false
            }
        }
    }
    
    private func applyData(from dict: [String: Any]) {
        if let score = dict["readinessScore"] as? Int {
            self.readinessScore = score
        }
        if let water = dict["waterReadyLitres"] as? Double {
            self.waterReadyLitres = water
        }
        if let target = dict["waterTargetLitres"] as? Double {
            self.waterTargetLitres = target
        }
        if let bag = dict["bagCheckedCount"] as? Int {
            self.bagCheckedCount = bag
        }
        if let bagTotal = dict["bagTotalCount"] as? Int {
            self.bagTotalCount = bagTotal
        }
        if let days = dict["daysOfAutonomy"] as? Int {
            self.daysOfAutonomy = days
        }
        if let mp1 = dict["meetingPoint1"] as? String {
            self.meetingPoint1 = mp1
        }
        if let mp2 = dict["meetingPoint2"] as? String {
            self.meetingPoint2 = mp2
        }
        if let notes = dict["homeNotes"] as? String {
            self.emergencyNotes = notes
        }
        
        var valves = WatchValveInfo()
        if let w = dict["waterValveLocation"] as? String { valves.water = w }
        if let g = dict["gasValveLocation"] as? String { valves.gas = g }
        if let b = dict["electricBreakerLocation"] as? String { valves.breaker = b }
        if let e = dict["extinguisherLocation"] as? String { valves.extinguisher = e }
        self.valveLocations = valves
        
        if let rawContacts = dict["iceContacts"] as? [[String: String]] {
            self.iceContacts = rawContacts.compactMap { item in
                guard let name = item["name"], !name.isEmpty,
                      let phone = item["phone"], !phone.isEmpty else { return nil }
                return WatchICEContact(name: name, phone: phone, role: item["role"] ?? "")
            }
        }
        
        if let ts = dict["lastSyncTimestamp"] as? TimeInterval {
            self.lastSyncDate = Date(timeIntervalSince1970: ts)
        } else {
            self.lastSyncDate = Date()
        }
        
        saveCache()
    }
    
    private func saveCache() {
        let cacheDict: [String: Any] = [
            "readinessScore": readinessScore,
            "waterReadyLitres": waterReadyLitres,
            "waterTargetLitres": waterTargetLitres,
            "bagCheckedCount": bagCheckedCount,
            "bagTotalCount": bagTotalCount,
            "daysOfAutonomy": daysOfAutonomy,
            "meetingPoint1": meetingPoint1,
            "meetingPoint2": meetingPoint2,
            "emergencyNotes": emergencyNotes,
            "waterValveLocation": valveLocations.water,
            "gasValveLocation": valveLocations.gas,
            "electricBreakerLocation": valveLocations.breaker,
            "extinguisherLocation": valveLocations.extinguisher,
            "lastSyncTimestamp": lastSyncDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        ]
        UserDefaults.standard.set(cacheDict, forKey: cacheKey)
        
        if let encodedContacts = try? JSONEncoder().encode(iceContacts) {
            UserDefaults.standard.set(encodedContacts, forKey: cacheKey + "_contacts")
        }
    }
    
    private func loadCache() {
        if let dict = UserDefaults.standard.dictionary(forKey: cacheKey) {
            self.readinessScore = dict["readinessScore"] as? Int ?? 85
            self.waterReadyLitres = dict["waterReadyLitres"] as? Double ?? 18.0
            self.waterTargetLitres = dict["waterTargetLitres"] as? Double ?? 18.0
            self.bagCheckedCount = dict["bagCheckedCount"] as? Int ?? 11
            self.bagTotalCount = dict["bagTotalCount"] as? Int ?? 15
            self.daysOfAutonomy = dict["daysOfAutonomy"] as? Int ?? 3
            self.meetingPoint1 = dict["meetingPoint1"] as? String ?? ""
            self.meetingPoint2 = dict["meetingPoint2"] as? String ?? ""
            self.emergencyNotes = dict["emergencyNotes"] as? String ?? ""
            
            var valves = WatchValveInfo()
            valves.water = dict["waterValveLocation"] as? String ?? ""
            valves.gas = dict["gasValveLocation"] as? String ?? ""
            valves.breaker = dict["electricBreakerLocation"] as? String ?? ""
            valves.extinguisher = dict["extinguisherLocation"] as? String ?? ""
            self.valveLocations = valves
            
            if let ts = dict["lastSyncTimestamp"] as? TimeInterval {
                self.lastSyncDate = Date(timeIntervalSince1970: ts)
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: cacheKey + "_contacts"),
           let contacts = try? JSONDecoder().decode([WatchICEContact].self, from: data) {
            self.iceContacts = contacts
        }
    }
    
    // MARK: - WCSessionDelegate
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
            if !session.receivedApplicationContext.isEmpty {
                self.applyData(from: session.receivedApplicationContext)
            }
        }
    }
    
    public func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            self.applyData(from: applicationContext)
            WKInterfaceDevice.current().play(.notification)
        }
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.applyData(from: message)
        }
    }
}
