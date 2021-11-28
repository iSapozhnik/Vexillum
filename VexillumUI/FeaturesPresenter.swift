import Foundation
import UIKit
import Vexillum

final class FeaturesPresenter: NSObject {
    weak var viewController: UIViewController?
    
    let features: [AnyFeature]
    
    init(withFeatures features: [AnyFeature]) {
        self.features = features
    }
}

extension FeaturesPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? SwitchCell, let feature = features[indexPath.row] as? Feature {
            cell.feature = feature
        }
        return cell
    }
}

extension FeaturesPresenter {
    func updateFeature(tableView: UITableView, indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func reload() {
        (viewController as? UITableViewController)?.tableView?.reloadSections(IndexSet(integer: 0), with: .fade)
    }
}

extension FeaturesPresenter {
    @objc func onDone(_ sender: Any?) {
        viewController?.dismiss(animated: true)
    }
}

