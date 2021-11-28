import Foundation
import UIKit
import Vexillum

class FeaturesInteractor: NSObject {

    let presenter: FeaturesPresenter

    init(withPresenter presenter: FeaturesPresenter) {
        self.presenter = presenter
    }
}

extension FeaturesInteractor: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    open func tableView(_ tableView: UITableView,
                        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {

        guard indexPath.row <= presenter.features.count,
            let feature = presenter.features[indexPath.row] as? Feature
            else { return UISwipeActionsConfiguration.init(actions: []) }

        let action = UIContextualAction(style: .normal,
                                        title: "Default") { [weak self] (_, _, callback: (Bool) -> Void) in
                                            self?.swipeHandler(forFeature: feature,
                                                               state: .default,
                                                               tableView: tableView,
                                                               indexPath: indexPath,
                                                               completion: callback)
        }

        action.backgroundColor = feature.defaultState ? .systemGreen : .systemGray3
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func swipeHandler(forFeature feature: AnyFeature,
                      state: FeatureState,
                      tableView: UITableView,
                      indexPath: IndexPath,
                      completion: (Bool) -> Void) {

        Haptic.generate()
        feature.state = state
        completion(true)
        presenter.updateFeature(tableView: tableView, indexPath: indexPath)
    }
}