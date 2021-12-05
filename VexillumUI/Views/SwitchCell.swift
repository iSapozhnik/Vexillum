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
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .label
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    private let descriptionLabel = withObject(UILabel()) {
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
    private let remoteFeatureView = withObject(UIImageView()) {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "icloud")
    }
    private let restartNeededView = withObject(UIImageView()) {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "arrow.clockwise.circle")
    }
    private lazy var switchControl = withObject(UISwitch()) {
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
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
    private let iconsStackView = withObject(UIStackView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
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
        remoteFeatureView.isHidden = true
        restartNeededView.isHidden = true
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
        restartNeededView.isHidden = !feature.requiresRestart
        restartNeededView.tintColor = .systemGray
        nameLabel.textColor = feature.color
        descriptionLabel.text = feature.featureDescription
        descriptionLabel.isHidden = feature.featureDescription.isEmpty
        switchControl.tintColor = feature.color
        switchControl.onTintColor = feature.color
        switchControl.isOn = feature.enabled
        stateLabel.text = feature.stateDescription
        stateLabel.textColor = feature.color
        remoteFeatureView.isHidden = feature.isLocal
        remoteFeatureView.tintColor = .systemGray
        iconsStackView.isHidden = [restartNeededView.isHidden, remoteFeatureView.isHidden].allSatisfy { $0 }
        contentView.layoutIfNeeded()
    }
    
    private func setupUI() {
        contentView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(switchControl)
        contentStackView.addArrangedSubview(verticalStackView)
//        contentStackView.addArrangedSubview(stateLabel)
        contentStackView.addArrangedSubview(iconsStackView)
        
        iconsStackView.addArrangedSubview(remoteFeatureView)
        iconsStackView.addArrangedSubview(restartNeededView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            remoteFeatureView.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
    }
}
