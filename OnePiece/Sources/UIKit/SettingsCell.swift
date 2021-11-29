//
//  SettingsCell.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit

enum SettingsCellImage {
    case bundle(String)
    case url(String?)
}

enum SettingsCellAccessoryLabelLevel {
    case high
    case normal
    case low
}
enum SettingsCellAccessoryStatus {
    case none
    case label(String, SettingsCellAccessoryLabelLevel)
    case button(String)
    case imageView(SettingsCellImage)
    case switchControl(Bool)
}

enum SettingsCellElementOptions {
    case icon(String)
    case title(String)
    case subtitle(String)
    case accessoryStatus(SettingsCellAccessoryStatus)
    case indicatorArrowHideStatus(Bool)
    case selectionStyle(UITableViewCell.SelectionStyle)
    case payload(Any?)
}

class SettingsCellModel {
    var icon: String?
    var title: String?
    var subtitle: String?
    var accessoryStatus: SettingsCellAccessoryStatus = .none
    var selectionStyle: UITableViewCell.SelectionStyle = .none
    var isIndicatorArrowHidden: Bool = false
    var payload: Any?
    
    init(icon: String? = nil, title: String? = nil, subtitle: String? = nil, accessoryStatus: SettingsCellAccessoryStatus = .none, isIndicatorArrowHidden: Bool = false, selectionStyle: UITableViewCell.SelectionStyle = .none, payload: Any? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.accessoryStatus = accessoryStatus
        self.isIndicatorArrowHidden = isIndicatorArrowHidden
        self.selectionStyle = selectionStyle
        self.payload = payload
    }
    
    init(_ options: [SettingsCellElementOptions]) {
        for op in options {
            switch op {
            case .icon(let icon): self.icon = icon
            case .title(let title): self.title = title
            case .subtitle(let subtitle): self.subtitle = subtitle
            case .accessoryStatus(let accessoryStatus): self.accessoryStatus = accessoryStatus
            case .indicatorArrowHideStatus(let status): self.isIndicatorArrowHidden = status
            case .selectionStyle(let selectionStyle): self.selectionStyle = selectionStyle
            case .payload(let payload): self.payload = payload
            }
        }
    }
}

protocol SettingsCellDelegate: NSObjectProtocol {
    func settingsCell(_ cell: SettingsCell, accessoryButtonDidClicked button: UIButton)
    func settingsCell(_ cell: SettingsCell, accessorySwitchDidChanged accessorySwitch: UISwitch)
}
extension SettingsCellDelegate {
    func settingsCell(_ cell: SettingsCell, accessoryButtonDidClicked button: UIButton) {}
    func settingsCell(_ cell: SettingsCell, accessorySwitchDidChanged accessorySwitch: UISwitch) {}
}
//设置cell样板代码
class SettingsCell: UITableViewCell {
    weak var delegate: SettingsCellDelegate?
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let accessoryLabel = UILabel()
    let accessoryButton = UIButton(type: .system)
    let accessoryImageView = UIImageView()
    let accessorySwitch = UISwitch()
    let indicatorArrow = UIImageView()
    let subStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initializeViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initializeViews()
    }
    
    func initializeViews() {
        selectionStyle = .none
        
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.distribution = .equalSpacing
        mainStackView.alignment = .center
        mainStackView.spacing = 5
        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
        iconImageView.contentMode = .scaleAspectFit
        mainStackView.addArrangedSubview(iconImageView)
        
        subStackView.axis = .vertical
        subStackView.distribution = .equalCentering
        subStackView.alignment = .leading
        subStackView.spacing = 5
        mainStackView.addArrangedSubview(subStackView)
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subStackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.font = .systemFont(ofSize: 14)
        subStackView.addArrangedSubview(subtitleLabel)
        
        accessoryLabel.font = .systemFont(ofSize: 14)
        accessoryLabel.isHidden = true
        contentView.addSubview(accessoryLabel)
        accessoryLabel.translatesAutoresizingMaskIntoConstraints = false
        accessoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
        accessoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        accessoryButton.isHidden = true
        accessoryButton.addTarget(self, action: #selector(accessoryButtonDidClicked(_:)), for: .touchUpInside)
        contentView.addSubview(accessoryButton)
        accessoryButton.translatesAutoresizingMaskIntoConstraints = false
        accessoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
        accessoryButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        accessoryImageView.isHidden = true
        contentView.addSubview(accessoryImageView)
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
        accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        accessorySwitch.isHidden = true
        accessorySwitch.addTarget(self, action: #selector(accessorySwitchDidChanged(_:)), for: .valueChanged)
        contentView.addSubview(accessorySwitch)
        accessorySwitch.translatesAutoresizingMaskIntoConstraints = false
        accessorySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive = true
        accessorySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        indicatorArrow.image = UIImage(named: "common_right_arrow_gray")
        indicatorArrow.isHidden = true
        contentView.addSubview(indicatorArrow)
        indicatorArrow.translatesAutoresizingMaskIntoConstraints = false
        indicatorArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        indicatorArrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.line.addBottom(insets:.init(top: 0, left: 12, bottom: 0, right: 12), lineColor: UIColor.black)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.isHidden = true
        iconImageView.isHidden = true
        subtitleLabel.isHidden = true
        accessoryButton.isHidden = true
        accessoryImageView.isHidden = true
        accessoryLabel.isHidden = true
        accessorySwitch.isHidden = true
        indicatorArrow.isHidden = true
        subStackView.spacing = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accessoryImageView.layer.cornerRadius = accessoryImageView.bounds.size.height/2
        accessoryImageView.layer.masksToBounds = true
    }
    
    func reload(_ cellModel: SettingsCellModel) {
        selectionStyle = cellModel.selectionStyle
        if cellModel.title?.isEmpty == false {
            titleLabel.isHidden = false
            titleLabel.text = cellModel.title
        }
        if cellModel.icon?.isEmpty == false {
            iconImageView.isHidden = false
            iconImageView.image = UIImage(named: cellModel.icon!)
        }
        if cellModel.subtitle?.isEmpty == false {
            subtitleLabel.isHidden = false
            subtitleLabel.text = cellModel.subtitle
        }else {
            subStackView.spacing = 0
        }
        indicatorArrow.isHidden = cellModel.isIndicatorArrowHidden
        refreshAccessoryStatus(cellModel.accessoryStatus)
    }
    
    private func refreshAccessoryStatus(_ status: SettingsCellAccessoryStatus) {
        switch status {
        case let .label(text, level):
            accessoryLabel.isHidden = false
            accessoryLabel.text = text
            switch level {
            case .high:
                accessoryLabel.textColor = UIColor.black
            case .normal:
                accessoryLabel.textColor = UIColor.gray
            case .low:
                accessoryLabel.textColor = UIColor.lightGray
            }
        case .button(let title):
            accessoryButton.isHidden = false
            accessoryButton.setTitle(title, for: .normal)
        case .imageView(let cellImage):
            accessoryImageView.isHidden = false
            switch cellImage {
            case .bundle(let string):
                accessoryImageView.image = UIImage(named: string)
            case .url(let urlString):
                //fixme:load icon
//                accessoryImageView.kf.setImage(with: ImageResource(urlString), placeholder: UIImage(named: "default"))
                print(urlString ?? "")
            }
        case .switchControl(let status):
            accessorySwitch.isHidden = false
            accessorySwitch.isOn = status
        default:
            break
        }
    }

    @objc private func accessoryButtonDidClicked(_ button: UIButton) {
        delegate?.settingsCell(self, accessoryButtonDidClicked: button)
    }
    
    @objc private func accessorySwitchDidChanged(_ switch: UISwitch) {
        delegate?.settingsCell(self, accessorySwitchDidChanged: `switch`)
    }
}
