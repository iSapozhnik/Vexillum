//
//  FeatureFlagsController.swift
//  Vexillum-Example-iOS
//
//  Created by Ivan Sapozhnik on 27.11.21.
//

import Foundation
import Vexillum
import VexillumUI

extension FeatureKey {
    static let appFilter = "app_filter"
    static let backgroundColor = "background_color"
    static let showRating = "show_rating"
}

final class FeatureFlagsController: FeaturesTableViewController {
    private static let features = [
        Feature(key: .showRating, defaultState: true),
        Feature(key: .backgroundColor, defaultState: false, title: "App background color"),
        Feature(key: .appFilter, defaultState: true, title: "App filters", featureDescription: "Enabling filter by applications."),
    ]

    private let featureContainer: FeatureContainer

    init() {
        self.featureContainer = FeatureContainer(features: Self.features, featureStoreProvider: FeatureStore.userDefaults)
        super.init(features: featureContainer.allFeatures)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Features"
    }
}
