import Foundation
import UIKit
import Vexillum

final class FeaturesPresenter: NSObject {
    
    weak var viewController: FeaturesTableViewController?
    
    let featureGroups: [FeatureGroup]
    
    init(withFeatures features: [AnyFeature]) {
        self.featureGroups = [FeatureGroup(label: "Default group", features: features)]
    }
    
    init(withFeatureGroups featureGroups: [FeatureGroup]) {
        self.featureGroups = featureGroups
    }
    
    func promptToRestart(for feature: AnyFeature, isAccepted: @escaping () -> Void, isDenied: (() -> Void)? = nil) {
        guard let viewController = viewController, feature.requiresRestart else { return isAccepted() }

        let message = "The app needs to be restarted in order to apply changes to the feature \(feature.title)."
        let alert = UIAlertController(title: "Restart required", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in isDenied?() })
        alert.addAction(UIAlertAction(title: "Restart later", style: .default) { _ in isAccepted() })
        alert.addAction(UIAlertAction(title: "Terminate", style: .destructive) { _ in isAccepted(); self.restartAdterDelay() })
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func promptToResetAllFeatures(isAccepted: @escaping () -> Void) {
        guard let viewController = viewController else { return isAccepted() }

        let restartNeeded = !(featureGroups.flatMap { $0.features }.filter { $0.requiresRestart }.isEmpty)
        
        let message = "Are you sure you want reset all features to their default states?"
        let restartNeededMessage = "This action require a restart to take action"
        var messageComponents = [message]
        if restartNeeded {
            messageComponents.append(restartNeededMessage)
        }
        let alert = UIAlertController(title: "Reset all features", message: messageComponents.joined(separator: " "), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Restart later", style: .default) { _ in isAccepted() })
        alert.addAction(UIAlertAction(title: "Yes and Terminate", style: .destructive) { _ in isAccepted(); self.restartAdterDelay() })
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func updateFooterWithDate(_ date: Date) {
        viewController?.footerView.updateState(to: .updating)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            DispatchQueue.main.async {
                self.viewController?.refreshControl?.endRefreshing()
                self.viewController?.footerView.updateState(to: .updatedAt(Date()))
            }
        }
        
    }
    
    private func restartAdterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exit(EXIT_SUCCESS )
        }
    }
    
    func promptToRestart(for feature: AnyFeature, isAccepted: @escaping () -> Void, isDenied: (() -> Void)? = nil) {
        guard let viewController = viewController, feature.requiresRestart else { return isAccepted() }

        let message = "The app needs to be restarted in order to apply changes to the feature \(feature.title)."
        let alert = UIAlertController(title: "Restart required", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in isDenied?() })
        alert.addAction(UIAlertAction(title: "Restart later", style: .default) { _ in isAccepted() })
        alert.addAction(UIAlertAction(title: "Terminate", style: .destructive) { _ in isAccepted(); self.restartAdterDelay() })
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func promptToResetAllFeatures(isAccepted: @escaping () -> Void) {
        guard let viewController = viewController else { return isAccepted() }

        let restartNeeded = !(features.filter { $0.requiresRestart }.isEmpty)
        
        let message = "Are you sure you want reset all features to their default states?"
        let restartNeededMessage = "This action require a restart to take action"
        var messageComponents = [message]
        if restartNeeded {
            messageComponents.append(restartNeededMessage)
        }
        let alert = UIAlertController(title: "Reset all features", message: messageComponents.joined(separator: " "), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Restart later", style: .default) { _ in isAccepted() })
        alert.addAction(UIAlertAction(title: "Yes and Terminate", style: .destructive) { _ in isAccepted(); self.restartAdterDelay() })
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func restartAdterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exit(EXIT_SUCCESS )
        }
    }
}

extension FeaturesPresenter: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        featureGroups.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        featureGroups[section].label + " (\(featureGroups[section].features.count))"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        featureGroups[section].features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.reuseIdentifier, for: indexPath)
        let featureGroup = featureGroups[indexPath.section]
        if let cell = cell as? SwitchCell, let feature = featureGroup.features[indexPath.row] as? Feature {
            cell.feature = feature
            cell.delegate = viewController
        }
        return cell
    }
}

extension FeaturesPresenter {
    func updateFeature(withIndexPath indexPath: IndexPath) {
        viewController?.tableView?.reloadRows(at: [indexPath], with: .fade)
    }
    
    func reload() {
        let indexPaths = (0..<featureGroups.count).map { section in
            (0..<featureGroups[section].features.count).map { IndexPath(row: $0, section: section) }
        }.flatMap { $0 }
        viewController?.tableView?.reloadRows(at: indexPaths, with: .fade)
    }
    
    func updateFeature(_ feature: AnyFeature, forCell cell: SwitchCell) {
        guard let indexPath = viewController?.tableView.indexPath(for: cell) else { return }
        viewController?.tableView?.reloadRows(at: [indexPath], with: .fade)
    }
}

extension FeaturesPresenter {
    @objc func onDone(_ sender: Any?) {
        viewController?.dismiss(animated: true)
    }
}

