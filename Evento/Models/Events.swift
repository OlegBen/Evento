import Foundation
import ObjectMapper

class Events: Mappable {
    var results: [Event]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.results <- map["results"]
    }
}


class Event: Mappable {
    var id: Int?
    var title: String?
    var description: String?
    var image: String?
    var creator: String?
    var presentations: [Presentation]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.title <- map["title"]
        self.description <- map["description"]
        self.image <- map["image"]
        self.creator <- map["creator"]
        self.presentations <- map["presentations"]
    }
}
