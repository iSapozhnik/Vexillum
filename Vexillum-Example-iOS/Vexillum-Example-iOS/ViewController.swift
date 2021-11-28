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
        showFeatureController()
    }

    @IBAction func showFeatureFlags(_ sender: Any) {
        showFeatureController()
    }
    
    private func showFeatureController() {
        let featureFlagsController = FeatureFlagsController()
        let navController = UINavigationController(rootViewController: featureFlagsController)
        present(navController, animated: true)
    }
}

