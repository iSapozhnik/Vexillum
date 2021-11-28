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

@objc open class FeaturesTableViewController: UITableViewController {
    let presenter: FeaturesPresenter
    let interactor: FeaturesInteractor

    public init<C: Collection>(features: C) where C.Element == AnyFeature {
        let arrayFeatures = Array(features)

        presenter = FeaturesPresenter(withFeatures: arrayFeatures)
        interactor = FeaturesInteractor(withPresenter: presenter)

        super.init(style: UITableView.Style.plain)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.reuseIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = presenter
        tableView.delegate = interactor
    }
}


