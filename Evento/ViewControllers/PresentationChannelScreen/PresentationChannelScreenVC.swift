import UIKit
import AgoraRtcKit
import AVKit


class PresentationChannelScreenVC: UIViewController {
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var microButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var waitRemoteUserView: UIView!
    
    var viewModel: PresentationChannelScreenVM?
    // Defines agoraKit
    var agoraKit: AgoraRtcEngineKit?
    
    var localVideoCanvas: AgoraRtcVideoCanvas?
    var remoteVideoCanvas: AgoraRtcVideoCanvas?
    
    var enableMicro = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                DispatchQueue.main.async {
                    self.streamingSetup()
                }
            
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.streamingSetup()
                        }
                    }
                }
            
            case .denied: // The user has previously denied access.
                dismiss(animated: true, completion: nil)

            case .restricted: // The user can't grant access due to restrictions.
                dismiss(animated: true, completion: nil)
        }
    }
    
    
    public func setupVC(presentation: Presentation, isOwner: Bool) {
        viewModel = PresentationChannelScreenVM(presentation: presentation, isOwner: isOwner)
    }
    
    func streamingSetup() {
        // The following functions are used when calling Agora APIs
        initializeAgoraEngine()
        agoraKit?.setChannelProfile(.liveBroadcasting)
        agoraKit?.setClientRole(.broadcaster)
        setupLocalVideo()
        joinChannel()
    }
    
    func initializeAgoraEngine() {
        guard let appID = viewModel?.getAppID() else { return }
        
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
    }
    
    func setupLocalVideo() {
        // Enables the video module
        let view = UIView(frame: localView.frame)
        localVideoCanvas = AgoraRtcVideoCanvas()
        localVideoCanvas!.view = view
        localVideoCanvas!.renderMode = .hidden
        localVideoCanvas!.uid = 0
        localView.addSubview(localVideoCanvas!.view!)
        agoraKit?.setupLocalVideo(localVideoCanvas)
        agoraKit?.startPreview()
        userNicknameLabel.text = LocalManager.shared.userName
    }
    
    func joinChannel(){
        guard let channelName = viewModel?.getChannelName(), let channelToken = viewModel?.getChannelToken() else { return }
        // The uid of each user in the channel must be unique.
        agoraKit?.joinChannel(byToken: channelToken, channelId: channelName, info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
            print("Join success")
        })
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        UIApplication.shared.isIdleTimerDisabled = false
        localView.isHidden = true
        remoteView.isHidden = true
        AgoraRtcEngineKit.destroy()
    }
    
    @IBAction func microButtonHandler(_ sender: UIButton) {
        enableMicro = !enableMicro
        
        // mute local audio
        agoraKit?.muteLocalAudioStream(!enableMicro)
        
        microButton.setImage(UIImage(systemName: enableMicro ? "mic.fill" : "mic.slash.fill"), for: .normal)
    }
    
    @IBAction func callButtonHandler(_ sender: UIButton) {
        leaveChannel()
        dismiss(animated: true, completion: nil)
    }
    
}

extension PresentationChannelScreenVC : AgoraRtcEngineDelegate {
    // Monitors the didJoinedOfUid callback
    // The SDK triggers the callback when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: remoteView.frame.size))
        remoteVideoCanvas = AgoraRtcVideoCanvas()
        remoteVideoCanvas!.view = view
        remoteVideoCanvas!.renderMode = .hidden
        remoteVideoCanvas!.uid = uid
        remoteView.addSubview(remoteVideoCanvas!.view!)
        agoraKit?.setupRemoteVideo(remoteVideoCanvas!)
        waitRemoteUserView.isHidden = true
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        print("Leave")
    }
    
    /// Reports an error during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - errorCode: Error code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print(errorCode.rawValue)
    }
}
