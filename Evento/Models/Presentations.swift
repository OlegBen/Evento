import Foundation
import ObjectMapper

final class Presentations: Mappable {
    var results: [Presentation]?
    
    init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.results <- map["results"]
    }
}

final class Presentation: Mappable {
    var id: Int?
    var eventId: Int?
    var title: String?
    var description: String?
    var image: String?
    var startDate: String?
    var speakers: [Speaker]?
    
    init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.eventId <- map["event"]
        self.title <- map["title"]
        self.description <- map["description"]
        self.image <- map["image"]
        self.startDate <- map["start_date"]
        self.speakers <- map["speakers"]
    }
}
