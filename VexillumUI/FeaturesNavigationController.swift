//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 28.11.21.
//

import Foundation
import UIKit
import Vexillum

open class FeaturesNavigationController: UINavigationController {
    public init(withFeatureContainer featureContainer: FeatureContainer) {
        let featureFlagsController = FeaturesTableViewController(features: featureContainer.allFeatures)
        super.init(rootViewController: featureFlagsController)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
