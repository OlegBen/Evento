import Foundation

protocol DetailEventScreenVMProtocol {
    var event: Event? { get set }
    
    func presintationsCount() -> Int
    func getPresentationCellVM(index: Int) -> PresentationTableViewCellVMProtocol
    func needShowEmptyView() -> Bool
    func getCellData(index: Int) -> (Presentation?, Bool?)
}

final class DetailEventScreenVM: DetailEventScreenVMProtocol {
    var event: Event?
    
    init(event: Event) {
        self.event = event
    }
    
    
    func needShowEmptyView() -> Bool {
        guard let event = event, let presentations = event.presentations, presentations.count > 0 else {
            return true
        }
        
        return false
    }
    
    func presintationsCount() -> Int {
        guard let event = event, let presentations = event.presentations else {
            return 0
        }
        
        return presentations.count
    }
    
    func getPresentationCellVM(index: Int) -> PresentationTableViewCellVMProtocol {
        guard let event = event, let presentations = event.presentations, index < presentations.count else {
            return PresentationTableViewCellVM()
        }
        
        let vm = PresentationTableViewCellVM()
        vm.presentation = presentations[index]
        return vm
    }
    
    func getCellData(index: Int) -> (Presentation?, Bool?) {
        var result: (Presentation?, Bool?) = (nil, nil)
        
        guard let event = event, let presentations = event.presentations, index < presentations.count else {
            return result
        }
        
        result.0 = presentations[index]
        result.1 = event.creator == LocalManager.shared.userName
        
        return result
    }
}
