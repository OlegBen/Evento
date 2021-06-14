import Foundation
import ObjectMapper

class Token: Mappable {
    var token: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
    }
}
