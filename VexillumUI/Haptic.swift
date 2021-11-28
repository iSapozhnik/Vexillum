//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 28.11.21.
//
import UIKit

enum Haptic {
    static func generate() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
}
