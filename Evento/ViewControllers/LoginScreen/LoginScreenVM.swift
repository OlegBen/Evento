import Foundation
import Bond
import ReactiveKit

// MARK: LoginScreenVM
final class LoginScreenVM {
    /// `Observe`
    var successGetToken = Observable<Bool>(false)
    var showHUD = Observable<Bool>(false)
    
    /// Менеджер запросов
    var requestManager: LoginRequestManagerProtocol?
    
    /// Инициализатор
    init(requestManager: LoginRequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    /// Авторизоваться
    func getToken(username: String, password: String) {
        self.showHUD.send(true)
        requestManager?.getToken(username: username, password: password, { [weak self] (token, error) in
            guard let _self = self else {
                return
            }
            
            _self.showHUD.send(false)
            
            if let error = error {
                print(error)
            } else if let token = token {
                UserDefaults.standard.set(username, forKey: "UserName")
                UserDefaults.standard.set(token, forKey: "Token")
                _self.successGetToken.send(true)
            }
        })
    }
}
