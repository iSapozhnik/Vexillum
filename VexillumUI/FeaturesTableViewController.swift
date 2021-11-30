import Foundation
import UIKit
import Vexillum

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

final class FeaturesTableViewController: UITableViewController {
    let presenter: FeaturesPresenter
    let interactor: FeaturesInteractor

    public init<C: Collection>(features: C) where C.Element == AnyFeature {
        let arrayFeatures = Array(features)

        presenter = FeaturesPresenter(withFeatures: arrayFeatures)
        interactor = FeaturesInteractor(withPresenter: presenter)

        super.init(style: UITableView.Style.plain)
        presenter.viewController = self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Features"
        
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(onDone(_:)))
        navigationItem.leftBarButtonItem = .init(title: "Reset all", style: .plain, target: self, action: #selector(onReset(_:)))
        
        tableView.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.reuseIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = presenter
        tableView.delegate = interactor
    }
}

extension FeaturesTableViewController: SwitchCellDelegate {
    func switchCell(_ cell: SwitchCell, wantsToggleFeature feature: AnyFeature, isDenied: (() -> Void)?) {
        interactor.toggleFeature(feature, isDenied: isDenied)
    }
}

extension FeaturesTableViewController {
    @objc func onDone(_ sender: Any?) {
        presenter.onDone(sender)
    }
    
    @objc func onReset(_ sender: Any?) {
        interactor.resetAllFeatures(sender)
    }
}
