import UIKit

// MARK: MoreRegistrationDataVC
class MoreRegistrationDataVC: BaseViewController {
    // MARK: IBOutlet
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var secondNameField: UITextField!
    
    // MARK: Переменные
    private var viewModel: MoreRegistrationDataVM?

    
    // MARK: Методы жизненного цикла
    /// ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupFields()
        self.setupObservers()
    }
    
    
    // MARK: Методы
    /// Сохранить имя и фамилию пользователя
    public func saveData(username: String, password: String) {
        viewModel = MoreRegistrationDataVM(userName: username, password: password, requestManager: LoginRequestManager())
    }
    
    private func setupObservers() {
        viewModel?.successGetToken.observeNext(with: { [weak self] (success) in
            guard let _self = self, success else {
                return
            }
            
            _self.showAuthZone()
        }).dispose(in: self.reactive.bag)
        
        viewModel?.showHUD.observeNext { [weak self] (show) in
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
    
    private func setupFields() {
        firstNameField.delegate = self
        secondNameField.delegate = self
    }
    
    private func showAuthZone() {
        guard let storyboard = self.storyboard else {
            return
        }
        
        /// Переход на авторизованную зону
        let authTabBar = UIViewController.controllerInStoryboard(storyboard, identifier: "AuthTabBar")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = authTabBar
    }
    
    
    // MARK: IBAction
    @IBAction func registrationHandler(_ sender: UIButton) {
        if viewModel?.validateData() ?? false {
            viewModel?.registartionRequest()
        } else {
            showInfo(title: "Ошибка", message: "Заполните все поля", buttonTitle: "Вернуться к заполнению")
        }
    }
    
}

// MARK: UITextFieldDelegate
extension MoreRegistrationDataVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameField {
            viewModel?.saveFirstName(value: textField.text)
        } else if textField == secondNameField {
            viewModel?.saveSecondName(value: textField.text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /// Скрытие клавиатуры
        textField.resignFirstResponder()
        return true
    }
}
