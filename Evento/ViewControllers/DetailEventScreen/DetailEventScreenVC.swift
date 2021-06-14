import UIKit
import Bond
import ReactiveKit
import SDWebImage

final class DetailEventScreenVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var presentationListLabel: UILabel!
    @IBOutlet weak var presentationsList: UITableView!
    @IBOutlet weak var emptyListView: UIView!
    @IBOutlet weak var presentationsListHeight: NSLayoutConstraint!
    
    
    private var viewModel: DetailEventScreenVMProtocol!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupObservers()
        setupUI()
    }
    
    public func setupWithEvent(event: Event) {
        let vm = DetailEventScreenVM(event: event)
        viewModel = vm
    }
    
    private func setupUI() {
        guard let event = viewModel.event else {
            return
        }
        
        if let image = event.image, let url = URL(string: image) {
            eventImage.sd_setImage(with: url, placeholderImage: UIImage(named: "eventDefaultImage"), options: .allowInvalidSSLCertificates, completed: nil)
        } else {
            eventImage.image = UIImage(named: "eventDefaultImage")
        }
        
        eventTitle.text = event.title
        eventDescription.text = event.description
        
        presentationsList.delegate = self
        presentationsList.dataSource = self
        presentationsList.register(UINib(nibName: "PresentationTableViewCell", bundle: nil), forCellReuseIdentifier: "PresentationTableViewCell")
        presentationsList.rowHeight = UITableView.automaticDimension
        presentationsList.estimatedRowHeight = 200
        
        presentationListLabel.isHidden = viewModel.needShowEmptyView()
        emptyListView.isHidden = !viewModel.needShowEmptyView()
        presentationsList.isHidden = viewModel.needShowEmptyView()
    }
    
    private func setupObservers() {
        presentationsList.reactive.keyPath("contentSize", ofType: CGSize.self).observeNext { [weak self] (size) in
            guard let _self = self else {
                return
            }

            _self.presentationsListHeight.constant = size.height
        }.dispose(in: self.reactive.bag)
    }

}

extension DetailEventScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.presintationsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.presentationsList.dequeueReusableCell(withIdentifier: "PresentationTableViewCell", for: indexPath) as! PresentationTableViewCell
        cell.selectionStyle = .none
        cell.setupCell(with: viewModel.getPresentationCellVM(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellInfo = viewModel.getCellData(index: indexPath.row)
        
        guard let storyboard = self.storyboard, let presentation = cellInfo.0, let isOwner = cellInfo.1 else { return }
        
        let presentationDetailVC = UIViewController.controllerInStoryboard(storyboard, identifier: "DetailPresentationScreenVC") as! DetailPresentationScreenVC
        presentationDetailVC.setupWithPresentation(presentation: presentation, isOwner: isOwner)
        self.navigationController?.pushViewController(presentationDetailVC, animated: true)
    }
}
