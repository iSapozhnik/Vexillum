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
}

class ViewController: ShakeController {

    private static let features = [
        Feature(key: .showRating, defaultState: true),
        Feature(key: .backgroundColor, defaultState: false, title: "App background color"),
        Feature(key: .appFilter, defaultState: true, title: "App filters", featureDescription: "Enabling filter by applications."),
        Feature(key: .someOther, defaultState: true, title: "Some Other cool feature", featureDescription: "Some other cool feature which requires restarting the app."),
    ]
    
    private var featureContainer: Vexillum!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        featureContainer = Vexillum(features: Self.features, featureStoreProvider: FeatureStore.userDefaults)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = featureContainer[.backgroundColor] ? .systemOrange : .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showFeatureController()
    }

    @IBAction func showFeatureFlags(_ sender: Any) {
        showFeatureController()
    }
    
    private func showFeatureController() {
        let navController = FeaturesNavigationController(withFeatureContainer: featureContainer)
        present(navController, animated: true)
    }
    
    override func handleShakeGesture() {
        showFeatureController()
    }
}
