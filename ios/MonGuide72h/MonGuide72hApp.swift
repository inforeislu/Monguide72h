import SwiftUI

@main
struct MonGuide72hApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        // Initialize Watch connectivity and Widget manager
        _ = WatchConnectivityManager.shared
        _ = WidgetDataManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                WidgetDataManager.shared.refreshSnapshot()
            }
        }
    }
}
