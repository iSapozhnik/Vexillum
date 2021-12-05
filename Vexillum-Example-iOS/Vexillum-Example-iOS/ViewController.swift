//
//  ViewController.swift
//  Vexillum-Example-iOS
//
//  Created by Ivan Sapozhnik on 27.11.21.
//

import UIKit
import Vexillum
import VexillumUI

extension FeatureKey {
    static let appFilter = "app_filter"
    static let backgroundColor = "background_color"
    static let showRating = "show_rating"
    static let someOther = "sone_other"
    static let remoteFeature1 = "remote_feature1"
    static let remoteFeature2 = "remote_feature2"
    static let remoteFeature3 = "remote_feature3"
    static let remoteFeature4 = "remote_feature4"
}

class ViewController: VexilleViewController {
    
    private let uiFeatures = [
        Feature(key: .backgroundColor, defaultState: false, title: "App background color"),
        Feature(key: .remoteFeature4, defaultState: true, title: "Some UI feature", featureDescription: "Some UI feature flag that is backed by a remote feature flag provider", isLocal: false),
        Feature(key: .appFilter, defaultState: true, title: "App filters", featureDescription: "Enabling filter by applications."),
        Feature(key: .showRating, defaultState: true, requiresRestart: true),
    ]
    
    private let otherFeatures = [
        Feature(key: .someOther, defaultState: true, title: "Some Other cool feature", featureDescription: "Some other cool feature which requires restarting the app."),
    ]
    
    private let remoteFeatures = [
        Feature(key: .remoteFeature1, isLocal: false),
        Feature(key: .remoteFeature2, requiresRestart: true,isLocal: false),
        Feature(key: .remoteFeature3, isLocal: false),
    ]
    
    private lazy var featureGroups = [
        FeatureGroup(label: "UI Features", features: uiFeatures),
        FeatureGroup(label: "Other Features", features: otherFeatures),
        FeatureGroup(label: "Remote features", features: remoteFeatures)
    ]
    
    private var featureContainer: Vexillum!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        featureContainer = Vexillum(
            features: featureGroups.flatMap { $0.features },
            featureStoreProvider: FeatureStore.userDefaults
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = featureContainer[.backgroundColor] ? .systemOrange : .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentFeaturesController()
    }

    @IBAction func showFeatureFlags(_ sender: Any) {
        presentFeaturesController()
    }
    
    func presentFeaturesController() {
        let featureFlagsController = FeaturesTableViewController(featureGroups: featureGroups)
        let navigationController = UINavigationController(rootViewController: featureFlagsController)
        present(navigationController, animated: true)
    }
}

extension ViewController: FeatureTogglePresentable {
    func presentFeatureToggle() {
        presentFeaturesController()
    }
}
