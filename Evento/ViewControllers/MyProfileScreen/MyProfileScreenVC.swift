import UIKit
import Bond
import ReactiveKit

// MARK: MyProfileScreenVC
final class MyProfileScreenVC: BaseViewController {
    // MARK: IBOutlet
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFirstNameLabel: UILabel!
    @IBOutlet weak var userLastNameLabel: UILabel!
    
    
    // MARK: Переменные
    private let viewModel: MyProfileScreenVMProtocol!
    
    
    // MARK: Инициализатор и деинит
    // Инициализатор
    init() {
        self.viewModel = MyProfileScreenVM(requestManager: LoginRequestManager())
        super.init(nibName: nil, bundle: nil)
    }
    
    // Основной инициализатор
    required init?(coder: NSCoder) {
        self.viewModel = MyProfileScreenVM(requestManager: LoginRequestManager())
        super.init(coder: coder)
    }
    

    // MARK: Методы жизненного цикла
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getClientProfile()
        setupProfile()
    }
    
    
    // MARK: Методы
    private func setupObservers() {
        viewModel.successGetClientProfile.observeNext { [weak self] (success) in
            guard let _self = self, success else {
                return
            }
            
            _self.setupProfile()
        }.dispose(in: self.reactive.bag)
        
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
    
    private func setupProfile() {
        userNameLabel.text = viewModel.getUserName()
        userFirstNameLabel.text = viewModel.getUserFirstName()
        userLastNameLabel.text = viewModel.getUserLastName()
    }
    
    
    // MARK: IBAction
    @IBAction func logoutHandler(_ sender: UIButton) {
        guard let storyboard = self.storyboard else {
            return
        }
        
        /// Очистка токена
        UserDefaults.standard.setValue(nil, forKey: "Token")
        /// Очистка логина
        UserDefaults.standard.setValue(nil, forKey: "UserName")
        /// Очистка менеджера
        LocalManager.shared.clearManager()
        /// Переход на не авторизированную зону
        let unAuthTabBar = UIViewController.controllerInStoryboard(storyboard, identifier: "UnAuthTabBar")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = unAuthTabBar
    }
}
