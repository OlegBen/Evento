import Foundation

final class LocalManager {
    static let shared = LocalManager()
    
    var user: User?
    var userName: String? {
        get {
            return UserDefaults.standard.string(forKey: "UserName")
        }
    }
    
    
    func clearManager() {
        user = nil
    }
}
