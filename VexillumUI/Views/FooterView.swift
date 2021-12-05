//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 01.12.21.
//

import Foundation
import UIKit

final class FooterView: UIView, Reusable {
    enum State {
        case updating
        case updatedAt(Date)
    }
    
    enum DateDecorator {
        static let formatter = withObject(DateFormatter()) {
            $0.dateFormat = "MMM d, HH:mm"
        }
        
        static func decorate(_ date: Date) -> String {
            "Updated at: " + formatter.string(from: date)
        }
    }
    
    private let dateLabel = withObject(UILabel()) {
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateState(to state: FooterView.State) {
        switch state {
        case .updatedAt(let date):
            dateLabel.text = DateDecorator.decorate(date)
        case .updating:
            dateLabel.text = "⏳Fetching features..."
        }
    }
    
    private func setupUI() {
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
