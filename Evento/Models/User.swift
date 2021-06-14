import Foundation
import ObjectMapper

class UserResponse: Mappable {
    var results: [User]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.results <- map["results"]
    }
}

class User: Mappable {
    var userName: String?
    var firstName: String?
    var lastName: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.userName <- map["username"]
        self.firstName <- map["first_name"]
        self.lastName <- map["last_name"]
    }
}
