//
//  ViewController.swift
//  Vexillum-Example-iOS
//
//  Created by Ivan Sapozhnik on 27.11.21.
//

import UIKit
import Vexillum
import VexillumUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let featureFlagsController = FeatureFlagsController()
        featureFlagsController.modalPresentationStyle = .automatic
        let navController = UINavigationController(rootViewController: featureFlagsController)
        self.present(navController, animated: true)
    }

    @IBAction func showFeatureFlags(_ sender: Any) {
        let featureFlagsController = FeatureFlagsController()
        featureFlagsController.modalPresentationStyle = .automatic
        let navController = UINavigationController(rootViewController: featureFlagsController)
        self.present(navController, animated: true)
    }
    
}

