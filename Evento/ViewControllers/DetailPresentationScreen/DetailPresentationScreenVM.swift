import Foundation

final class DetailPresentationScreenVM {
    private var presentation: Presentation?
    private var isOwner: Bool?
    
    /// Инициализатор
    init(presentation: Presentation, isOwner: Bool) {
        self.presentation = presentation
        self.isOwner = isOwner
    }
    
    public func getPresentationTitle() -> String {
        return self.presentation?.title ?? ""
    }
    
    public func getPresentationImageLink() -> String {
        return self.presentation?.image ?? ""
    }
    
    public func getPresentationStartDate() -> String {
        let df = DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ", locale: "RU_ru")
        let newDF = DateFormatter(withFormat: "dd-MM-yyyy HH:mm", locale: "RU_ru")
        
        if let date = df.date(from: self.presentation?.startDate ?? "") {
            let dateStr = newDF.string(from: date)
            return dateStr
        } else {
            return ""
        }
    }
    
    public func getPresentationDescription() -> String {
        return self.presentation?.description ?? ""
    }
    
    public func isPresentationOwner() -> Bool {
        return self.isOwner ?? false
    }
    
    public func getPresentation() -> Presentation? {
        return self.presentation
    }
}
