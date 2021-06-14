import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class APIRequest {
    static public let shared = APIRequest()
    
    private func requestData<T: Mappable>(url: String, method: HTTPMethod, headers: HTTPHeaders, params: Parameters?, encoding: JSONEncoding, completion: @escaping ((T?, _ error: Error?) -> Void)) {
        
        print("request: \(method) \(url)\n\(String(describing: params))\nHeaders: \(String(describing: headers))\n")
        
        Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers).responseObject { (response: DataResponse<T>) in
            print(response)
            switch response.result {
            case .success:
                if let response = response.value {
                    completion(response, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
        
    }
    
    private func requestData(url: String, method: HTTPMethod, headers: HTTPHeaders, params: Parameters?, encoding: JSONEncoding, completion: @escaping ((_ error: Error?) -> Void)) {
        
        print("request: \(method) \(url)\n\(String(describing: params))\nHeaders: \(String(describing: headers))\n")
        
        Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers).responseData { (data) in
            if let error = data.error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    private func makeHeaders() -> HTTPHeaders {
        return makeUnAuthHeaders().merging(makeAuthHeaders()) { (current, _) in current }
    }
    
    private func makeUnAuthHeaders() -> [String: String] {
        let headers = ["Content-Type": "application/json"]
        return headers
    }
    
    private func makeAuthHeaders() -> [String: String] {
        var headers = [String: String]()
        
        if let token = UserDefaults.standard.string(forKey: "Token") {
            headers["Authorization"] = "Token " + token
        }
        
        return headers
    }
}

// MARK: Auth
extension APIRequest {
    public func auth(params: [String: String], _ completion: @escaping (Token?, Error?) -> Void) {
        requestData(url: APIUrls.getToken, method: .post, headers: makeHeaders(), params: params, encoding: .default, completion: completion)
    }
    
    public func registration(params: [String: String], _ completion: @escaping (User?, Error?) -> Void) {
        requestData(url: APIUrls.registration, method: .post, headers: makeHeaders(), params: params, encoding: .default, completion: completion)
    }
    
    public func getUsers(_ completion: @escaping (UserResponse?, Error?) -> Void) {
        requestData(url: APIUrls.users, method: .get, headers: makeHeaders(), params: nil, encoding: .default, completion: completion)
    }
}

// MARK: Events
extension APIRequest {
    public func getEvents(_ completion: @escaping (Events?, Error?) -> Void) {
        requestData(url: APIUrls.getEvents, method: .get, headers: makeHeaders(), params: nil, encoding: .default, completion: completion)
    }
    
    public func addEvent(params: [String: Any], _ completion: @escaping (Event?, Error?) -> Void) {
        requestData(url: APIUrls.getEvents, method: .post, headers: makeHeaders(), params: params, encoding: .default, completion: completion)
    }
    
    public func removeEvent(id: String, _ completion: @escaping (Error?) -> Void) {
        requestData(url: APIUrls.getEvents + id + "/", method: .delete, headers: makeHeaders(), params: nil, encoding: .default, completion: completion)
    }
}

// MARK: Presentations
extension APIRequest {
    public func getPresentations(_ completion: @escaping (Presentations?, Error?) -> Void) {
        requestData(url: APIUrls.getPresentations, method: .get, headers: makeHeaders(), params: nil, encoding: .default, completion: completion)
    }
}
