import Foundation

// MARK: LoginRequestManagerProtocol
protocol LoginRequestManagerProtocol {
    /// Авторизация
    /// - Parameters:
    ///   - username: логин
    ///   - password: пароль
    ///   - completion: (String?, NSError?) -> Void
    func getToken(username: String, password: String, _ completion: @escaping (String?, NSError?) -> Void)
    
    /// Регистрация
    /// - Parameters:
    ///   - username: логин
    ///   - password: пароль
    ///   - completion: (String?, NSError?) -> Void
    func registration(username: String, password: String, firstName: String, lastName: String, _ completion: @escaping (User?, NSError?) -> Void)
    
    /// Получить данные о профиле пользователя
    /// - Parameter completion: (UserResponse?, NSError?) -> Void
    func getClientProfile(_ completion: @escaping (UserResponse?, NSError?) -> Void)
}

// MARK: LoginRequestManager
final class LoginRequestManager: LoginRequestManagerProtocol {
    // Авторизация
    /// - Parameters:
    ///   - username: логин
    ///   - password: пароль
    ///   - completion: (String?, NSError?) -> Void
    func getToken(username: String, password: String, _ completion: @escaping (String?, NSError?) -> Void) {
        /// Форрмирование параметров для запроса
        let params = ["username": username, "password": password]
        /// Запрос авторизации
        APIRequest.shared.auth(params: params) { (token, error) in
            if let error = error {
                completion(nil, error as NSError)
            } else if let token = token {
                completion(token.token, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    /// Регистрация
    /// - Parameters:
    ///   - username: логин
    ///   - password: пароль
    ///   - completion: (String?, NSError?) -> Void
    func registration(username: String, password: String, firstName: String, lastName: String, _ completion: @escaping (User?, NSError?) -> Void) {
        /// Форрмирование параметров для запроса
        let params = ["username": username, "password": password, "first_name": firstName, "last_name": lastName]
        /// Запрос регистрации
        APIRequest.shared.registration(params: params) { (user, error) in
            if let error = error {
                completion(nil, error as NSError)
            } else if let user = user {
                completion(user, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    /// Получить данные о профиле пользователя
    /// - Parameter completion: (UserResponse?, NSError?) -> Void
    func getClientProfile(_ completion: @escaping (UserResponse?, NSError?) -> Void) {
        /// Запрос на получение списка пользователей
        APIRequest.shared.getUsers({ (usersList, error) in
            if let error = error {
                completion(nil, error as NSError)
            } else if let users = usersList {
                completion(users, nil)
            } else {
                completion(nil, nil)
            }
        })
    }
}
