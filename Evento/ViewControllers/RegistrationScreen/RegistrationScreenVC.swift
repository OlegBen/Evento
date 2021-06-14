import UIKit

class RegistrationScreenVC: BaseViewController {
    // MARK: IBOutlet
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordField: UITextField!
    

    // MARK: Методы жизненного цикла
    /// ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
    }
    
    
    // MARK: Методы
    /// Натсройка текстовых полей
    func setupTextFields() {
        loginField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    /// Анимированный показ `UIView`
    /// - Parameter view: UIView
    private func animatingShowView(_ view: UIView) {
        view.alpha = 1
        view.isHidden = false
        self.view.layoutIfNeeded()
    }
    
    /// Анимированное скрытие `UIView`
    /// - Parameter view: UIView
    private func animatingHideView(_ view: UIView) {
        view.alpha = 0
        view.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    /// Перейти на экран с дополнительной информацией о пользователе
    private func showMoreRegistrationDataScreen() {
        guard let storyboard = self.storyboard else {
            return
        }
        
        let moreRegDataVC = UIViewController.controllerInStoryboard(storyboard, identifier: "MoreRegistrationDataVC") as! MoreRegistrationDataVC
        moreRegDataVC.saveData(username: loginField.text ?? "", password: passwordField.text ?? "")
        self.navigationController?.pushViewController(moreRegDataVC, animated: true)
        
    }

    
    // MARK: IBAction
    /// Обработка нажатия на кнопку "Зарегистрироваться"
    @IBAction func registrationHandler(_ sender: UIButton) {
        if (loginField.text?.count ?? 0) > 0 && (passwordField.text?.count ?? 0) > 0 && (confirmPasswordField.text?.count ?? 0) > 0 {
            /// Переход на экран Заполнить больше данных
            showMoreRegistrationDataScreen()
        } else {
            showInfo(title: "Ошибка", message: "Заполните все поля", buttonTitle: "Вернуться к заполнению")
        }
    }
}

// MARK: UITextFieldDelegate
extension RegistrationScreenVC: UITextFieldDelegate {
    /// Метод делегата, работающий после редактирования поля
    /// - Parameter textField: UITextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordField {
            if (textField.text?.count ?? 0) > 0 {
                animatingShowView(confirmPasswordView)
            } else {
                animatingHideView(confirmPasswordView)
                confirmPasswordField.text = nil
            }
        } else if textField == confirmPasswordField {
            if textField.text != passwordField.text && textField.text != nil && textField.text != "" {
                textField.textColor = .systemRed
            } else {
                textField.textColor = .black
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /// Скрытие клавиатуры
        textField.resignFirstResponder()
        return true
    }
}
