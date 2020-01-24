//
//  SigningViewController.swift
//  EthereumSigner
//
//  Created by Bahadir Oncel on 22.01.2020.
//  Copyright © 2020 Piyuv OU. All rights reserved.
//

import UIKit
import SnapKit

class SigningViewController: UIViewController {
    private let user: User
    
    private let messageField = UITextField()
    private let signButton = UIButton(type: .system)
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Signing"
        
        messageField.placeholder = "Your message"
        messageField.delegate = self
        messageField.backgroundColor = .systemGray6
        messageField.borderStyle = .roundedRect
        view.addSubview(messageField)
        
        signButton.setTitle("Sign message", for: .normal)
        signButton.addTarget(self, action: #selector(signTapped), for: .touchUpInside)
        view.addSubview(signButton)
        
        messageField.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
        
        signButton.snp.makeConstraints { (make) in
            make.top.equalTo(messageField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func signTapped() {
        guard let message = messageField.text, message.count != 0 else {
            messageField.shake()
            return
        }
        let signatureViewController = SignatureViewController(user: user, message: message)
        navigationController?.pushViewController(signatureViewController, animated: true)
    }
}

extension SigningViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return (textField.text?.count ?? 0) != 0
    }
}
