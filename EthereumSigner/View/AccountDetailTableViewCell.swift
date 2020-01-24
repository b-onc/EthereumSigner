//
//  AccountDetailTableViewCell.swift
//  EthereumSigner
//
//  Created by Bahadir Oncel on 22.01.2020.
//  Copyright © 2020 Piyuv OU. All rights reserved.
//

import UIKit

class AccountDetailTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: self)
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    private func setupUI() {
        titleLabel.textColor = .systemGray
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .right
        stackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.textColor = .label
        subtitleLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.textAlignment = .right
        subtitleLabel.lineBreakMode = .byTruncatingMiddle
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.spacing = 12
        stackView.axis = .vertical
        stackView.alignment = .trailing
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(12)
            make.bottom.trailing.equalToSuperview().offset(-12)
        }
    }
}
