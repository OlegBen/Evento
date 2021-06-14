import Foundation
import Bond
import ReactiveKit

protocol CreateEventScreenVMProtocol {
    var successCreateEvent: Observable<Bool> { get set }
    var showHUD: Observable<Bool> { get set }
    
    func createEvent(title: String, description: String)
}

final class CreateEventScreenVM: CreateEventScreenVMProtocol {
    var successCreateEvent = Observable<Bool>(false)
    var showHUD = Observable<Bool>(false)
    
    func createEvent(title: String, description: String) {
        guard let username = LocalManager.shared.userName else {
            return
        }
        
        self.showHUD.send(true)
        
        let params = ["title": title, "description": description, "image": "https://proprikol.ru/wp-content/uploads/2019/09/kartinki-krasivye-priroda-na-rabochij-stol-na-ves-ekran-1-1.jpg", "creator": username]
        
        APIRequest.shared.addEvent(params: params) { (event, error) in
            self.showHUD.send(false)
            if let error = error {
                print(error)
            } else if let event = event {
                self.successCreateEvent.send(true)
            }
        }
    }
}
