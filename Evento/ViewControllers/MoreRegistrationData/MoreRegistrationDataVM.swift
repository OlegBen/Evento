import Foundation
import Bond
import ReactiveKit

final class MoreRegistrationDataVM {
    /// `Observe`
    var successGetToken = Observable<Bool>(false)
    var showHUD = Observable<Bool>(false)
    /// Переменные
    private var userName: String
    private var password: String
    private var firstName: String?
    private var lastName: String?
    private var requestManager: LoginRequestManagerProtocol?
    private var user: User?
    
    
    /// Инициализатор
    /// - Parameters:
    ///   - userName: String
    ///   - password: String
    init(userName: String, password: String, requestManager: LoginRequestManagerProtocol) {
        self.userName = userName
        self.password = password
        self.requestManager = requestManager
    }
    
    /// Сохранить имя
    public func saveFirstName(value: String?) {
        guard let name = value else {
            return
        }
        
        firstName = name
    }
    
    /// Сохранить фамилию
    public func saveSecondName(value: String?) {
        guard let surname = value else {
            return
        }
        
        lastName = surname
    }
    
    /// Проверка данных на валидность
    public func validateData() -> Bool {
        if userName.count > 0 && password.count > 0 && (firstName?.count ?? 0) > 0 && (lastName?.count ?? 0) > 0 {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Запросы
    /// Регистрация
    public func registartionRequest() {
        guard userName.count > 0, password.count > 0, let firstName = firstName, firstName.count > 0, let lastName = lastName, lastName.count > 0 else {
            return
        }
        
        self.showHUD.send(true)
        
        requestManager?.registration(username: userName, password: password, firstName: firstName, lastName: lastName, { [weak self] (user, error) in
            guard let _self = self else {
                return
            }
            
            if let error = error {
                _self.showHUD.send(false)
                print(error)
            } else if let user = user {
                _self.user = user
                LocalManager.shared.user = user
                _self.getToken(username: _self.userName, password: _self.password)
            }
        })
    }
    
    /// Авторизоваться
    func getToken(username: String, password: String) {
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
