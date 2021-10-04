import UIKit
import Combine

class AlertListViewController: UITableViewController {
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let viewModel = AlertListViewModel()
    private var source = [Alert]()
    private var cancellables = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alerts"

        addLoading()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        viewModel.$state.sink { [weak self] result in
            self?.refreshControl?.endRefreshing()
            self?.showLoading(false)
            switch result {
            case .alerts(let alerts):
                self?.source = alerts
                self?.tableView.reloadData()
            case .loading:
                self?.showLoading(true)
            case .error(let error):
                print(error)
            }
        }.store(in: &cancellables)

        viewModel.updateAlerts()
    }

    private func addLoading() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)

        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        showLoading(false)
    }

    private func showLoading(_ loading: Bool) {
        loading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = !loading
    }

    @objc private func refreshData() {
        viewModel.updateAlerts()
    }
}

extension AlertListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        source.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath) as? AlertCell
        guard let cell = cell else {
            return UITableViewCell()
        }
        cell.setUp(with: source[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AlertDetailsViewController")
        if let details = controller as? AlertDetailsViewController {
            details.alert = source[indexPath.row]
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}
