import Foundation
import CoreLocation

public enum POICategory: String, CaseIterable, Identifiable, Codable {
    case hospital
    case cgdis
    case iodinePoint
    case shelter
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .hospital:
            return "cross.case.fill"
        case .cgdis:
            return "flame.fill"
        case .iodinePoint:
            return "pills.fill"
        case .shelter:
            return "tent.fill"
        }
    }
}

public struct EmergencyPOI: Identifiable, Codable, Equatable {
    public let id: UUID
    public let name: String
    public let category: POICategory
    public let address: String
    public let commune: String
    public let postalCode: String
    public let latitude: Double
    public let longitude: Double
    public let phone: String?
    public let openingHours: String
    public let emergencyServices: [String]
    public let notes: String?
    
    public init(
        id: UUID = UUID(),
        name: String,
        category: POICategory,
        address: String,
        commune: String,
        postalCode: String,
        latitude: Double,
        longitude: Double,
        phone: String? = nil,
        openingHours: String,
        emergencyServices: [String] = [],
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.address = address
        self.commune = commune
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
        self.phone = phone
        self.openingHours = openingHours
        self.emergencyServices = emergencyServices
        self.notes = notes
    }
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    public func distanceFormatted(from userLocation: CLLocation?) -> String? {
        guard let userLoc = userLocation else { return nil }
        let meters = location.distance(from: userLoc)
        if meters < 1000 {
            return "\(Int(meters)) m"
        } else {
            return String(format: "%.1f km", meters / 1000.0)
        }
    }
    
    public func distanceInMeters(from userLocation: CLLocation?) -> Double {
        guard let userLoc = userLocation else { return Double.greatestFiniteMagnitude }
        return location.distance(from: userLoc)
    }
    
    public var cleanPhoneUrl: URL? {
        guard let phone = phone else { return nil }
        let cleaned = phone.filter { "0123456789+".contains($0) }
        return URL(string: "tel://\(cleaned)")
    }
    
    public var appleMapsDirectionsURL: URL? {
        let cleanName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)&q=\(cleanName)")
    }
}
