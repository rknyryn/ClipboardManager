import Foundation
import ServiceManagement

class LaunchAtLoginManager {
    static let shared = LaunchAtLoginManager()
    
    private init() {}
    
    func enableLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Launch at login ayarlanırken hata: \(error.localizedDescription)")
        }
    }
    
    func isEnabled() -> Bool {
        return SMAppService.mainApp.status == .enabled
    }
}
