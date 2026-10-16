import Foundation
import CoreLocation
import Combine

public struct LurefCoordinates: Equatable {
    public let east: Double
    public let north: Double
    
    public var formattedEast: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let num = NSNumber(value: Int(east.rounded()))
        return "\(formatter.string(from: num) ?? "\(Int(east.rounded()))") m"
    }
    
    public var formattedNorth: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let num = NSNumber(value: Int(north.rounded()))
        return "\(formatter.string(from: num) ?? "\(Int(north.rounded()))") m"
    }
}

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    public static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published public var location: CLLocation?
    @Published public var lurefCoords: LurefCoordinates?
    @Published public var lurefEastFormatted: String = "-- m"
    @Published public var lurefNorthFormatted: String = "-- m"
    @Published public var phoneticSentence: String = ""
    @Published public var emergencySMSBody: String = ""
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
        guard let loc = location else { return "Coordonnées indisponibles" }
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
        if loc.horizontalAccuracy < 0 { return "Précision inconnue" }
        return "± \(Int(loc.horizontalAccuracy)) m"
    }
    
    public var mapsAppleURL: String {
        guard let loc = location else { return "https://maps.apple.com" }
        return "https://maps.apple.com/?ll=\(loc.coordinate.latitude),\(loc.coordinate.longitude)&q=Secours+112+Luxembourg"
    }
    
    // MARK: - Official Luxembourg LUREF (EPSG:2169) Transformation
    public static func wgs84ToLuref(latitude latDeg: Double, longitude lonDeg: Double, altitude h: Double = 300.0) -> (east: Double, north: Double) {
        let latRad = latDeg * .pi / 180.0
        let lonRad = lonDeg * .pi / 180.0

        let aWgs: Double = 6378137.0
        let fWgs: Double = 1.0 / 298.257223563
        let e2Wgs: Double = 2.0 * fWgs - fWgs * fWgs

        let sinLat = sin(latRad)
        let cosLat = cos(latRad)
        let sinLon = sin(lonRad)
        let cosLon = cos(lonRad)

        let nWgs = aWgs / sqrt(1.0 - e2Wgs * sinLat * sinLat)
        let xWgs = (nWgs + h) * cosLat * cosLon
        let yWgs = (nWgs + h) * cosLat * sinLon
        let zWgs = (nWgs * (1.0 - e2Wgs) + h) * sinLat

        let dx: Double = -193.0
        let dy: Double = 13.7
        let dz: Double = -39.3
        let rxRad: Double = (-0.41 / 3600.0) * (.pi / 180.0)
        let ryRad: Double = (-2.933 / 3600.0) * (.pi / 180.0)
        let rzRad: Double = (2.688 / 3600.0) * (.pi / 180.0)
        let mScale: Double = 1.0 + (0.43 * 1e-6)

        let xLu = dx + mScale * (xWgs + rzRad * yWgs - ryRad * zWgs)
        let yLu = dy + mScale * (-rzRad * xWgs + yWgs + rxRad * zWgs)
        let zLu = dz + mScale * (ryRad * xWgs - rxRad * yWgs + zWgs)

        let aLu: Double = 6378388.0
        let fLu: Double = 1.0 / 297.0
        let e2Lu: Double = 2.0 * fLu - fLu * fLu
        let ePrime2Lu: Double = e2Lu / (1.0 - e2Lu)
        let bLu: Double = aLu * (1.0 - fLu)

        let p = sqrt(xLu * xLu + yLu * yLu)
        let theta = atan2(zLu * aLu, p * bLu)

        let latL = atan2(
            zLu + ePrime2Lu * bLu * pow(sin(theta), 3),
            p - e2Lu * aLu * pow(cos(theta), 3)
        )
        let lonL = atan2(yLu, xLu)

        let lon0 = (6.0 + 10.0 / 60.0) * (.pi / 180.0)
        let lat0 = (49.0 + 50.0 / 60.0) * (.pi / 180.0)
        let fe: Double = 80000.0
        let fn: Double = 100000.0
        let k0: Double = 1.0

        func meridianArc(_ phi: Double) -> Double {
            return aLu * (
                (1.0 - e2Lu / 4.0 - 3.0 * pow(e2Lu, 2) / 64.0 - 5.0 * pow(e2Lu, 3) / 256.0) * phi
                - (3.0 * e2Lu / 8.0 + 3.0 * pow(e2Lu, 2) / 32.0 + 45.0 * pow(e2Lu, 3) / 1024.0) * sin(2.0 * phi)
                + (15.0 * pow(e2Lu, 2) / 256.0 + 45.0 * pow(e2Lu, 3) / 1024.0) * sin(4.0 * phi)
                - (35.0 * pow(e2Lu, 3) / 3072.0) * sin(6.0 * phi)
            )
        }

        let m = meridianArc(latL)
        let m0 = meridianArc(lat0)
        let dlon = lonL - lon0

        let n = aLu / sqrt(1.0 - e2Lu * sin(latL) * sin(latL))
        let t = pow(tan(latL), 2)
        let c = ePrime2Lu * pow(cos(latL), 2)
        let a = dlon * cos(latL)

        let east = fe + k0 * n * (
            a + (1.0 - t + c) * pow(a, 3) / 6.0
            + (5.0 - 18.0 * t + t * t + 72.0 * c - 58.0 * ePrime2Lu) * pow(a, 5) / 120.0
        )

        let north = fn + k0 * (
            m - m0 + n * tan(latL) * (
                pow(a, 2) / 2.0
                + (5.0 - t + 9.0 * c + 4.0 * c * c) * pow(a, 4) / 24.0
                + (61.0 - 58.0 * t + t * t + 600.0 * c - 330.0 * ePrime2Lu) * pow(a, 6) / 720.0
            )
        )

        return (east, north)
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
        
        // Calculate LUREF EPSG:2169
        let alt = latest.altitude > 0 ? latest.altitude : 300.0
        let luref = LocationManager.wgs84ToLuref(
            latitude: latest.coordinate.latitude,
            longitude: latest.coordinate.longitude,
            altitude: alt
        )
        let lurefObj = LurefCoordinates(east: luref.east, north: luref.north)
        self.lurefCoords = lurefObj
        self.lurefEastFormatted = lurefObj.formattedEast
        self.lurefNorthFormatted = lurefObj.formattedNorth
        
        let accInt = Int(latest.horizontalAccuracy)
        let latStr = String(format: "%.5f", latest.coordinate.latitude)
        let lonStr = String(format: "%.5f", latest.coordinate.longitude)
        
        self.phoneticSentence = "\"112 CGDIS : Je suis localisé au Luxembourg. Coordonnées LUREF Est : \(Int(luref.east.rounded())), Nord : \(Int(luref.north.rounded())) (Précision : ±\(accInt)m). GPS : \(latStr) N, \(lonStr) E.\""
        
        self.emergencySMSBody = "URGENCE SECOURS LUXEMBOURG : Ma position est LUREF Est: \(Int(luref.east.rounded())), Nord: \(Int(luref.north.rounded())) (Précision ±\(accInt)m). GPS: https://maps.apple.com/?q=\(latStr),\(lonStr)"
        
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

