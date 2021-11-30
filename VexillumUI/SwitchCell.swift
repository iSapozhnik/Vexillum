//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 27.11.21.
//

import Foundation
import UIKit
import Vexillum

protocol SwitchCellDelegate: NSObjectProtocol {
    func switchCell(_ cell: SwitchCell, wantsToggleFeature feature: AnyFeature, isDenied: (() -> Void)?)
}

final class SwitchCell: UITableViewCell, Reusable {
    private let nameLabel = withObject(UILabel()) {
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .label
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    private let descriptionLabel = withObject(UILabel()) {
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    private let stateLabel = withObject(UILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .secondaryLabel
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .right
    }
    private lazy var switchControl = withObject(UISwitch()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(onSwitchChange(_:)), for: .valueChanged)
    }
    private let contentStackView = withObject(UIStackView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    private let verticalStackView = withObject(UIStackView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    weak var delegate: SwitchCellDelegate?
    var feature: Feature? {
        didSet {
            updateUI(withFeature: feature)
        }
    }
    
    var presenter: FeaturesPresenter?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        descriptionLabel.text = nil
        stateLabel.text = nil
        descriptionLabel.isHidden = true
    }
    
    @objc
    func onSwitchChange(_ sender: UISwitch) {
        guard let feature = feature else { return }

        delegate?.switchCell(self, wantsToggleFeature: feature) {
            sender.setOn(!sender.isOn, animated: true)
        }
    }
    
    private func updateUI(withFeature feature: Feature?) {
        guard let feature = feature else { return }

        nameLabel.text = feature.title
        if feature.requiresRestart {
            nameLabel.text?.append("*")
        }
        nameLabel.textColor = feature.color
        descriptionLabel.text = feature.featureDescription
        descriptionLabel.isHidden = feature.featureDescription.isEmpty
        switchControl.tintColor = feature.color
        switchControl.onTintColor = feature.color
        switchControl.isOn = feature.enabled
        stateLabel.text = feature.state.description
        stateLabel.textColor = feature.color
    }
    
    private func setupUI() {
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        contentStackView.addArrangedSubview(switchControl)
        contentStackView.addArrangedSubview(verticalStackView)
        contentStackView.addArrangedSubview(stateLabel)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
    }
}
