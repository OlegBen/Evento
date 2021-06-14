import UIKit
import SDWebImage

class PresentationTableViewCell: UITableViewCell {
    @IBOutlet weak var presentationImage: UIImageView!
    @IBOutlet weak var presentationTitle: UILabel!
    @IBOutlet weak var presentationDescription: UILabel!
    
    private var viewModel: PresentationTableViewCellVMProtocol!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    
    public func setupCell(with viewModel: PresentationTableViewCellVMProtocol) {
        self.viewModel = viewModel
        self.setupUI()
    }
    
    private func setupUI() {
        guard let presentation = viewModel.presentation else { return }
        
        if let image = presentation.image, let url = URL(string: image) {
            presentationImage.sd_setImage(with: url, placeholderImage: UIImage(systemName: "calendar"), options: .allowInvalidSSLCertificates, completed: nil)
        } else {
            presentationImage.image = UIImage(systemName: "calendar")
        }
        
        if let title = presentation.title {
            presentationTitle.text = title
        } else {
            presentationTitle.text = ""
        }
        
        if let description = presentation.description {
            presentationDescription.text = description
        } else {
            presentationDescription.text = ""
        }
    }
}
