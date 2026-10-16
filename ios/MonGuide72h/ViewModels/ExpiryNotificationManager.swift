import Foundation
import UserNotifications

public class ExpiryNotificationManager: ObservableObject {
    public static let shared = ExpiryNotificationManager()
    
    @Published public var isAuthorized: Bool = false
    
    private init() {
        checkAuthorization()
    }
    
    public func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = (settings.authorizationStatus == .authorized)
            }
        }
    }
    
    public func requestAuthorization(completion: @escaping (Bool) -> Void = { _ in }) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                completion(granted)
            }
        }
    }
    
    /// Schedules a local notification reminder for an item prior to its expiration
    public func scheduleExpiryAlert(for itemId: String, itemName: String, expiryDate: Date) {
        // Cancel any existing notification for this item
        cancelNotification(for: itemId)
        
        // Reminder 14 days before expiry at 9:00 AM
        guard let reminderDate = Calendar.current.date(byAdding: .day, value: -14, to: expiryDate),
              reminderDate > Date() else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Rotação de Stocks 72h — InfoReis"
        content.subtitle = "Validade a expirar em breve"
        content.body = "A provisão «\(itemName)» do seu Kit de Emergência expira a \(formattedDate(expiryDate)). Verifique e renove o stock."
        content.sound = .default
        
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "expiry_\(itemId)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    public func cancelNotification(for itemId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["expiry_\(itemId)"])
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "pt_PT")
        return formatter.string(from: date)
    }
}
