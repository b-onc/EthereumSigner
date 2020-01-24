//
//  SetupViewController.swift
//  EthereumSigner
//
//  Created by Bahadir Oncel on 22.01.2020.
//  Copyright © 2020 Piyuv OU. All rights reserved.
//

import UIKit
import SnapKit

class SetupViewController: UIViewController {
    private let privateKeyField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Setup"
        
        privateKeyField.placeholder = "Private key"
        privateKeyField.delegate = self
        privateKeyField.backgroundColor = .systemGray6
        privateKeyField.borderStyle = .roundedRect
        view.addSubview(privateKeyField)
        
        privateKeyField.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
    }
}

extension SetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let input = textField.text, input.count != 0 else {
            textField.shake()
            return false
        }
        guard let user = User(privateKey: input) else {
            textField.shake()
            return false
        }
        let accountViewController = AccountViewController(user: user)
        navigationController?.setViewControllers([accountViewController], animated: true)
        return true
    }
}

