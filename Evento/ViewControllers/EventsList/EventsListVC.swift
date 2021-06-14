import UIKit
import Bond
import ReactiveKit

class EventsListVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var viewModel = EventsListVM()
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupObservers()
        loadData()
    }
    
    func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventTableViewCell")
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = 100
        self.refreshControl.tintColor = .black
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    func setupObservers() {
        viewModel.needToReloadTable.observeNext { [weak self] (need) in
            guard let _self = self, need else {
                return
            }
            
            DispatchQueue.main.async {
                if _self.refreshControl.isRefreshing {
                    _self.refreshControl.endRefreshing()
                }
                _self.tableView.reloadData()
            }
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
    
    func loadData() {
        self.viewModel.getEvents()
    }
    
    @objc func refresh() {
        loadData()
    }

    @IBAction func addNewEvent(_sender: UIButton) {
        guard let storyboard = self.storyboard else {
            return
        }
        
        let eventsVC = UIViewController.controllerInStoryboard(storyboard, identifier: "CreateEventScreenVC")
        self.navigationController?.pushViewController(eventsVC, animated: true)
    }
}

//MARK: UITableView dataSource and delegate imp
extension EventsListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventTableViewCell
        let cellData = self.viewModel.events[indexPath.row]

        cell.selectionStyle = .none
        cell.setupCell(with: cellData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let stroyboard = storyboard else {
            return
        }
        let events = viewModel.events
        let event = events[indexPath.row]
        
        let detailEvent = UIViewController.controllerInStoryboard(stroyboard, identifier: "DetailEventScreenVC") as! DetailEventScreenVC
        detailEvent.setupWithEvent(event: event)
        navigationController?.pushViewController(detailEvent, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let userName = LocalManager.shared.userName else {
            return false
        }
        let cellData = viewModel.events[indexPath.row]
        return cellData.creator == userName
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cellData = viewModel.events[indexPath.row]
        viewModel.deleteEvent(event: cellData)
    }
}
