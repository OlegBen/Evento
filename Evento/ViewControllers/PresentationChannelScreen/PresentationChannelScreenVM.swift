import Foundation
import AgoraRtcKit

final class PresentationChannelScreenVM {
    private var appID = "001cef565035487fa43c9e97843cb362"
    private var channelName = "Presentations"
    private var channelToken = "006001cef565035487fa43c9e97843cb362IABBT711m/rNZZNGcY0hzP/d0ticMXC8RpoDeBaCp25WdOgg7cEAAAAAEACDSUn7rXLHYAEAAQCscsdg"
    private var presentation: Presentation?
    private var isOwner: Bool?
    
    init(presentation: Presentation, isOwner: Bool) {
        self.presentation = presentation
        self.isOwner = isOwner
    }
    
    public func getAppID() -> String {
        return self.appID
    }
    
    public func getChannelName() -> String {
        return self.channelName
    }
    
    public func getChannelToken() -> String {
        return self.channelToken
    }
    
    public func isPresentationOwner() -> Bool {
        return self.isOwner ?? false
    }
}
