//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 30.11.21.
//

import Foundation
import UIKit

open class ShakeController: UIViewController {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        handleShakeGesture()
    }
    
    open func handleShakeGesture() {
        fatalError("Shake gesture handler is not implemented")
    }
}
