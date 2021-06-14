import UIKit
import SDWebImage

class DetailPresentationScreenVC: UIViewController {
    @IBOutlet weak var presentationNameLabel: UILabel!
    @IBOutlet weak var presentationImage: UIImageView!
    @IBOutlet weak var presentationStartDateLabel: UILabel!
    @IBOutlet weak var presentationDescriptionTextView: UITextView!
    @IBOutlet weak var startStreamButton: UIButton!
    
    /// ViewModel
    var viewModel: DetailPresentationScreenVM?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    /// Настройка класса с входными данными
    public func setupWithPresentation(presentation: Presentation, isOwner: Bool) {
        self.viewModel = DetailPresentationScreenVM(presentation: presentation, isOwner: isOwner)
    }
    
    /// Настройка UI-элементов
    private func setupUI() {
        guard let viewModel = self.viewModel else { return }
        
        presentationNameLabel.text = viewModel.getPresentationTitle()
        
        if let imageURL = URL(string: viewModel.getPresentationImageLink()) {
            presentationImage.sd_setImage(with: imageURL, completed: nil)
        } else {
            presentationImage.image = UIImage(named: "eventDefaultImage")
        }
        
        presentationStartDateLabel.text = viewModel.getPresentationStartDate()
        presentationDescriptionTextView.text = viewModel.getPresentationDescription()
        
        let buttonTitle = viewModel.isPresentationOwner() ? "Начать стрим" : "Присоединиться"
        startStreamButton.setTitle(buttonTitle, for: .normal)
    }

    @IBAction func startStreamHandler(_ sender: UIButton) {
        guard let storyboard = storyboard, let presentation = viewModel?.getPresentation(), let isOwner = viewModel?.isPresentationOwner() else { return }
        
        let vc = UIViewController.controllerInStoryboard(storyboard, identifier: "PresentationChannelScreenVC") as! PresentationChannelScreenVC
        vc.setupVC(presentation: presentation, isOwner: isOwner)
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}
