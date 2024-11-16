//
//  CryptoCoinCell.swift
//  Upstox
//
//  Created by Naveen.Katari on 12/11/24.
//

import UIKit

class CryptoCoinCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let symbolLabel = UILabel()
    let statusImageView = UIImageView()
    let newImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        symbolLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        symbolLabel.textColor = .gray
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(symbolLabel)
        
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusImageView)
        
        newImageView.image = UIImage(named: "coin_new")
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        newImageView.isHidden = true
        contentView.addSubview(newImageView)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            symbolLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            symbolLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            statusImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 24),
            statusImageView.heightAnchor.constraint(equalToConstant: 24),
            
            newImageView.widthAnchor.constraint(equalToConstant: 12),
            newImageView.heightAnchor.constraint(equalToConstant: 12),
            newImageView.trailingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 6),
            newImageView.topAnchor.constraint(equalTo: statusImageView.topAnchor, constant: -6)
        ])
    }
    
    func configure(with coin: CryptoCoin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
                if !coin.isActive {
            statusImageView.image = UIImage(named: "crypto_inactive")
            statusImageView.tintColor = .systemGray
        } else if coin.type == "coin" {
            statusImageView.image = UIImage(named: "crypto_coin")
            statusImageView.tintColor = .systemYellow
        } else if coin.type == "token" {
            statusImageView.image = UIImage(named: "crypto_token")
            statusImageView.tintColor = .systemYellow
        }
        
        newImageView.isHidden = !coin.isNew
    }
}
