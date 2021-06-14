import Foundation
import Bond
import ReactiveKit

// MARK: MyProfileScreenVMProtocol
protocol MyProfileScreenVMProtocol {
    var successGetClientProfile: Observable<Bool> { get set }
    var showHUD: Observable<Bool> { get set }
    var requestManager: LoginRequestManagerProtocol? { get set }
    
    func getClientProfile()
    func getUserName() -> String
    func getUserFirstName() -> String
    func getUserLastName() -> String
}

// MARK: MyProfileScreenVM
final class MyProfileScreenVM: MyProfileScreenVMProtocol {
    var successGetClientProfile = Observable<Bool>(false)
    var showHUD = Observable<Bool>(false)
    var requestManager: LoginRequestManagerProtocol?
    var user: User? {
        get {
            return LocalManager.shared.user
        }
    }
    
    
    /// Инициализатор
    init(requestManager: LoginRequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    
    func getClientProfile() {
        if user != nil {
            successGetClientProfile.send(true)
        } else {
            self.showHUD.send(true)
            requestManager?.getClientProfile({ (result, error) in
                self.showHUD.send(false)
                LocalManager.shared.user = result?.results?.filter({ $0.userName == (LocalManager.shared.userName ?? "") }).first
                self.successGetClientProfile.send(true)
            })
        }
    }
    
    func getUserName() -> String {
        guard let user = user else {
            return "Tester"
        }
        
        return user.userName ?? ""
    }
    
    func getUserFirstName() -> String {
        guard let user = user else {
            return "Oleg"
        }
        
        return user.firstName ?? ""
    }
    
    func getUserLastName() -> String {
        guard let user = user else {
            return "Ben"
        }
        
        return user.lastName ?? ""
    }
}
