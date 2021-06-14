import UIKit

class CreateEventScreenVC: BaseViewController {
    // MARK: IBOutlet
    @IBOutlet weak var eventTitle: UITextView!
    @IBOutlet weak var eventDescription: UITextView!
    
    
    // MARK: Переменные
    private var viewModel: CreateEventScreenVMProtocol!
    
    
    // MARK: Инициализатор и деинит
    // Инициализатор
    init() {
        self.viewModel = CreateEventScreenVM()
        super.init(nibName: nil, bundle: nil)
    }
    
    // Основной инициализатор
    required init?(coder: NSCoder) {
        self.viewModel = CreateEventScreenVM()
        super.init(coder: coder)
    }
    

    // MARK: Методы жизненного цикла
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupObservers()
    }
    
    
    // MARK: Методы
    func setupObservers() {
        viewModel.successCreateEvent.observeNext { [weak self] (success) in
            guard let _self = self, success else {
                return
            }
            
            _self.eventTitle.text = ""
            _self.eventDescription.text = ""
            _self.eventTitle.resignFirstResponder()
            _self.eventDescription.resignFirstResponder()
            _self.showSuccessView()
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
    
    private func showSuccessView() {
        self.showInfo(title: "Успешно", message: "Вы успешно создали новое сообытие", buttonTitle: "Ок")
    }
    
    // MARK: IBAction
    @IBAction func createButtonHandler(_ sender: UIButton) {
        if eventTitle.text.count > 0 && eventDescription.text.count > 0 {
            viewModel.createEvent(title: eventTitle.text, description: eventDescription.text)
        } else {
            showInfo(title: "Ошибка", message: "Заполните все поля", buttonTitle: "Вернуться к заполнению")
        }
    }
}
