//
//  FilterViewCell.swift
//  Upstox
//
//  Created by Naveen.Katari on 12/11/24.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    private var checkmarkWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.clipsToBounds = true
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        contentView.addSubview(titleLabel)
        
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = .systemGray
        checkmarkImageView.isHidden = true
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkmarkImageView)
        
        contentView.backgroundColor = ColorConstants.backgroundGray
        checkmarkWidthConstraint = checkmarkImageView.widthAnchor.constraint(equalToConstant: 16)

        NSLayoutConstraint.activate([
            checkmarkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkWidthConstraint,
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        checkmarkImageView.isHidden = !isSelected
        checkmarkWidthConstraint.constant = isSelected ? 16 : 0
        contentView.backgroundColor = isSelected ? ColorConstants.selectedGray : ColorConstants.unSelectedGray
    }
}
