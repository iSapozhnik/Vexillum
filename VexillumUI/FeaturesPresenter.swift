import Foundation
import UIKit
import Vexillum

final class FeaturesPresenter: NSObject {
    
    weak var viewController: FeaturesTableViewController?
    
    let features: [AnyFeature]
    
    init(withFeatures features: [AnyFeature]) {
        self.features = features
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? SwitchCell, let feature = features[indexPath.row] as? Feature {
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
        viewController?.tableView?.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
    func updateFeature(_ feature: AnyFeature) {
        guard let index = features.firstIndex(where: { $0.key == feature.key }) else { return }
        viewController?.tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}

extension FeaturesPresenter {
    @objc func onDone(_ sender: Any?) {
        viewController?.dismiss(animated: true)
    }
}

