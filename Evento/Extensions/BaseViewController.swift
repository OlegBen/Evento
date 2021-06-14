import Foundation
import UIKit

class BaseViewController: UIViewController {
    /// Показать информационное диологовое окно
    /// - Parameters:
    ///   - title: Заголовок
    ///   - message: Сообщение
    ///   - buttonTitle: Название кнопки
    func showInfo(title: String?, message: String?, buttonTitle: String) {
        let infoAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: buttonTitle, style: .default) { (action) in
            infoAlert.dismiss(animated: true, completion: nil)
        }
        
        infoAlert.addAction(okButton)
        
        navigationController?.present(infoAlert, animated: true)
    }
    
    func showHUD() {
        let backgroundView = UIView(frame: self.view.frame)
        let activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityView.style = .large
        activityView.startAnimating()
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        activityView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.tag = 1000
        backgroundView.backgroundColor = UIColor.systemBackground
        backgroundView.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
        
        self.view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func dismissHUD() {
        let hudView = self.view.viewWithTag(1000)
        hudView?.removeFromSuperview()
    }
}
