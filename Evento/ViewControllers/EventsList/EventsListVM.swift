import Foundation
import Bond
import ReactiveKit

class EventsListVM {
    var needToReloadTable = Observable<Bool>(false)
    var showHUD = Observable<Bool>(false)
    
    public var events = [Event]()
    
    public func getEvents() {
        self.showHUD.send(true)
        
        APIRequest.shared.getEvents() { (events, error) in
            self.showHUD.send(false)
            if error != nil {
                self.needToReloadTable.send(true)
            } else if let events = events, let results = events.results {
                self.events.removeAll()
                self.events.append(contentsOf: results)
                self.needToReloadTable.send(true)
            }
        }
    }
    
    public func deleteEvent(event: Event) {
        guard let id = event.id else {
            return
        }
        
        self.showHUD.send(true)
        
        APIRequest.shared.removeEvent(id: String(id)) { (error) in
            self.showHUD.send(false)
            if let error = error {
                print(error)
            } else {
                self.events.removeAll(where: { $0.id == id })
                self.needToReloadTable.send(true)
            }
        }
    }
}
