import Foundation
import CoreLocation
import Combine

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    public static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published public var location: CLLocation?
    @Published public var addressString: String = ""
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published public var isLocating: Bool = false
    @Published public var locationError: String?
    
    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    public func requestPermissionAndStart() {
        requestPermission()
        startUpdating()
    }
    
    public func startUpdating() {
        isLocating = true
        locationError = nil
        if authorizationStatus == .notDetermined {
            requestPermission()
        }
        manager.startUpdatingLocation()
    }
    
    public func stopUpdating() {
        isLocating = false
        manager.stopUpdatingLocation()
    }
    
    public var formattedCoordinates: String {
        guard let loc = location else { return "Coordenadas indisponíveis" }
        let lat = String(format: "%.5f", abs(loc.coordinate.latitude))
        let lon = String(format: "%.5f", abs(loc.coordinate.longitude))
        let latDir = loc.coordinate.latitude >= 0 ? "N" : "S"
        let lonDir = loc.coordinate.longitude >= 0 ? "E" : "W"
        return "\(lat)° \(latDir), \(lon)° \(lonDir)"
    }
    
    public var rawCoordinates: (lat: Double, lon: Double)? {
        guard let loc = location else { return nil }
        return (loc.coordinate.latitude, loc.coordinate.longitude)
    }
    
    public var formattedAccuracy: String {
        guard let loc = location else { return "" }
        if loc.horizontalAccuracy < 0 { return "Precisão desconhecida" }
        return "± \(Int(loc.horizontalAccuracy)) metros"
    }
    
    public var mapsAppleURL: String {
        guard let loc = location else { return "https://maps.apple.com" }
        return "https://maps.apple.com/?ll=\(loc.coordinate.latitude),\(loc.coordinate.longitude)&q=Localizacao+SOS"
    }
    
    // CLLocationManagerDelegate
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        self.location = latest
        
        // Reverse geocode to get locality
        geocoder.reverseGeocodeLocation(latest) { [weak self] placemarks, _ in
            guard let self = self, let p = placemarks?.first else { return }
            let locality = p.locality ?? ""
            let thoroughfare = p.thoroughfare ?? ""
            let name = [thoroughfare, locality].filter { !$0.isEmpty }.joined(separator: ", ")
            DispatchQueue.main.async {
                self.addressString = name.isEmpty ? "Luxembourg" : name
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationError = error.localizedDescription
    }
}
