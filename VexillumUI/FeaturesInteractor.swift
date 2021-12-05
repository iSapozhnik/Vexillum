import Foundation
import UIKit
import Vexillum

final class FeaturesInteractor: NSObject {

    let presenter: FeaturesPresenter

    init(withPresenter presenter: FeaturesPresenter) {
        self.presenter = presenter
    }
    
    func toggleFeature(_ feature: AnyFeature, forCell cell: SwitchCell, isDenied: (() -> Void)?) {
        presenter.promptToRestart(for: feature, isAccepted: { [weak self] in
            feature.state = feature.enabled ? .off : .on
            Haptic.toggle()
            self?.presenter.updateFeature(feature, forCell: cell)
        }, isDenied: isDenied)
    }
    
    @objc func handleRefreshControl() {
        presenter.updateFooterWithDate(Date())
    }
}

extension FeaturesInteractor: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            indexPath.section <= presenter.featureGroups.count,
            indexPath.row <= presenter.featureGroups[indexPath.section].features.count,
            let feature = presenter.featureGroups[indexPath.section].features[indexPath.row] as? Feature
            else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.promptToRestart(for: feature) { [weak self] in
            feature.state = feature.enabled ? .off : .on
            self?.presenter.updateFeature(withIndexPath: indexPath)
            Haptic.toggle()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        guard
            indexPath.section <= presenter.featureGroups.count,
            indexPath.row <= presenter.featureGroups[indexPath.section].features.count,
            let feature = presenter.featureGroups[indexPath.section].features[indexPath.row] as? Feature
            else { return UISwipeActionsConfiguration.init(actions: []) }

        let action = UIContextualAction(style: .normal, title: "Default") { [weak self] (_, _, callback: (Bool) -> Void) in
            self?.swipeHandler(forFeature: feature,
                               state: .default,
                               tableView: tableView,
                               indexPath: indexPath,
                               completion: callback
            )
        }

        action.backgroundColor = feature.defaultState ? .systemGreen : .systemGray3
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    private func swipeHandler(forFeature feature: AnyFeature,
                      state: FeatureState,
                      tableView: UITableView,
                      indexPath: IndexPath,
                      completion: (Bool) -> Void) {

        Haptic.success()
        completion(true)
        presenter.promptToRestart(for: feature) { [weak self] in
            feature.state = state
            self?.presenter.updateFeature(withIndexPath: indexPath)
        }
    }
}

extension FeaturesInteractor {
    @objc
    func onReset(_ sender: Any?) {
        let reset = { [weak self] in
            self?.presenter.featureGroups.forEach { $0.features.forEach { $0.state = .default } }
            self?.presenter.reload()
        }
        let restartNotRequired = presenter.featureGroups
            .lazy
            .flatMap { $0.features }
            .filter { $0.requiresRestart }
            .allSatisfy { $0.state == .default }
        restartNotRequired ? reset() : presenter.promptToResetAllFeatures(isAccepted: reset)
    }
}
