import Foundation
import ObjectMapper

final class Speakers: Mappable {
    var results: [Speaker]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.results <- map["results"]
    }
}

final class Speaker: Mappable {
    var id: Int?
    var presentation: Presentation?
    var firstName: String?
    var secondName: String?
    var age: Int?
    var avatar: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.presentation <- map["presentation"]
        self.firstName <- map["firstName"]
        self.secondName <- map["secondName"]
        self.age <- map["age"]
        self.avatar <- map["avatar"]
    }
}
