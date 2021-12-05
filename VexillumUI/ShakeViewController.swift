//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 30.11.21.
//

import Foundation
import UIKit

public protocol FeatureTogglePresentable {
    func presentFeatureToggle()
}

open class VexilleViewController: UIViewController {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        handleShakeGesture()
    }
    
    func handleShakeGesture() {
        guard self is FeatureTogglePresentable else { return }
        (self as? FeatureTogglePresentable)?.presentFeatureToggle()
    }
}
