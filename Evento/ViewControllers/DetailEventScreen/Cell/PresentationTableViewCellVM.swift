import Foundation

protocol PresentationTableViewCellVMProtocol {
    var presentation: Presentation? { get set }
}

final class PresentationTableViewCellVM: PresentationTableViewCellVMProtocol {
    var presentation: Presentation?
}
