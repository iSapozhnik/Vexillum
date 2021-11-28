//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 28.11.21.
//
import UIKit

enum Haptic {
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    static func toggle() {
        let generator = UIImpactFeedbackGenerator()
        generator.prepare()
        generator.impactOccurred()
    }
}
