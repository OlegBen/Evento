import UIKit
import Lottie

final class SplashScreenViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var animatingLogoView: UIView!
    
    
    // MARK: Методы жизненного цикла
    /// ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLottieAnimation()
    }
    
    // MARK: Методы
    /// Генерация и запуск анимации для логотипа
    private func startLottieAnimation() {
        let animationView = AnimationView(name: "event_calendar")
        animationView.frame = animatingLogoView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 0.8
        animatingLogoView.addSubview(animationView)
            
        animationView.play { [weak self] (success) in
            guard let _self = self else {
                return
            }
            
            _self.navigationAfterShowLogo()
        }
    }
    
    /// Навигация после показа логотипа
    private func navigationAfterShowLogo() {
        guard let storyboard = self.storyboard else {
            return
        }
        
        if let _ = UserDefaults.standard.string(forKey: "Token") {
            /// Переход на авторизованную зону
            let authTabBar = UIViewController.controllerInStoryboard(storyboard, identifier: "AuthTabBar")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = authTabBar
        } else {
            /// Переход на не авторизованную зону
            let unAuthTabBar = UIViewController.controllerInStoryboard(storyboard, identifier: "UnAuthTabBar")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = unAuthTabBar
        }
        
        /// For TESTING STREAMING
//        let detailEvent = UIViewController.controllerInStoryboard(storyboard, identifier: "PresentationChannelScreenVC") as! PresentationChannelScreenVC
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = detailEvent
    }
}
