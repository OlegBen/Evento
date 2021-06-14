import UIKit
import Bond
import ReactiveKit

final class LoginScreenVC: BaseViewController {
    // MARK: IBOutlet
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK: Переменные
    /// ViewModel
    private let viewModel = LoginScreenVM(requestManager: LoginRequestManager())
    
    
    // MARK: Методы жизненного цикла
    /// ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObservers()
    }
    
    
    // MARK: Методы
    /// Настройка `Observe`
    func setupObservers() {
        viewModel.successGetToken.observeNext(with: { [weak self] (success) in
            guard let _self = self, let storyboard = _self.storyboard, success else {
                return
            }
            
            /// Переход на авторизованную зону
            let authTabBar = UIViewController.controllerInStoryboard(storyboard, identifier: "AuthTabBar")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = authTabBar
        }).dispose(in: self.reactive.bag)
        
        viewModel.showHUD.observeNext { [weak self] (show) in
            guard let _self = self else {
                return
            }
            
            if show {
                _self.showHUD()
            } else {
                _self.dismissHUD()
            }
        }.dispose(in: self.reactive.bag)
    }
    

    // MARK: IBAction
    /// Нажатие на кнопку "Авторизоваться"
    @IBAction func auth(_ sender: UIButton) {
        getUserToken()
    }
    
}

//MARK: Work with token
extension LoginScreenVC {
    func getUserToken() {
        guard let userName = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        
        viewModel.getToken(username: userName, password: password)
    }
}
