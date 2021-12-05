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

public struct FeatureGroup {
    public init(label: String, features: [AnyFeature]) {
        self.label = label
        self.features = features
    }
    
    public let label: String
    public let features: [AnyFeature]
}

public final class FeaturesTableViewController: UITableViewController {
    
    let presenter: FeaturesPresenter
    let interactor: FeaturesInteractor
    
    lazy var footerView = FooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 24))
    
    private lazy var refresh = withObject(UIRefreshControl()) {
        $0.addTarget(interactor, action: #selector(FeaturesInteractor.handleRefreshControl), for: .valueChanged)
    }
    
    public init(featureGroups: [FeatureGroup]) {
        presenter = FeaturesPresenter(withFeatureGroups: featureGroups)//FeaturesPresenter(withFeatures: featureGroups.flatMap { $0.features })
        interactor = FeaturesInteractor(withPresenter: presenter)
        
        super.init(style: .grouped)
        presenter.viewController = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        title = "Features"
        
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: presenter, action: #selector(FeaturesPresenter.onDone(_:)))
        navigationItem.leftBarButtonItem = .init(title: "Reset all", style: .plain, target: interactor, action: #selector(FeaturesInteractor.onReset(_:)))
        
        tableView.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.reuseIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        tableView.dataSource = presenter
        tableView.delegate = interactor
        tableView.refreshControl = refresh
        tableView.tableFooterView = footerView
        footerView.updateState(to: .updatedAt(Date()))
    }
}

extension FeaturesTableViewController {
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView,
                        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
        interactor.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
    }
}

extension FeaturesTableViewController: SwitchCellDelegate {
    func switchCell(_ cell: SwitchCell, wantsToggleFeature feature: AnyFeature, isDenied: (() -> Void)?) {
        interactor.toggleFeature(feature, forCell: cell, isDenied: isDenied)
    }
}
