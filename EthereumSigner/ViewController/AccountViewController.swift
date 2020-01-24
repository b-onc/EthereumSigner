//
//  AccountViewController.swift
//  EthereumSigner
//
//  Created by Bahadir Oncel on 22.01.2020.
//  Copyright © 2020 Piyuv OU. All rights reserved.
//

import UIKit
import SnapKit

class AccountViewController: UIViewController {
    private let user: User
    
    private let tableView = UITableView()
    private let buttonsStackView = UIStackView()
    private let signButton = UIButton(type: .system)
    private let verifyButton = UIButton(type: .system)
    
    lazy var infoData: [(String, String)] = {
        [("Address", user.address), ("Balance", "Loading..")]
    }()
    
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
        
        title = "Account"
        
        tableView.dataSource = self
        tableView.register(AccountDetailTableViewCell.self, forCellReuseIdentifier: String(describing: AccountDetailTableViewCell.reuseIdentifier))
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        view.addSubview(tableView)
        
        signButton.setTitle("Sign", for: .normal)
        signButton.addTarget(self, action: #selector(signTapped), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(signButton)
        
        verifyButton.setTitle("Verify", for: .normal)
        verifyButton.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(verifyButton)
        
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 24
        view.addSubview(buttonsStackView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        buttonsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        user.balance { [weak self] (result) in
            do {
                let value = try result.get()
                self?.infoData = [("Address", self?.user.address ?? "Error"), ("Balance", "\(value) Ether")]
            } catch {
                self?.infoData = [("Error trying to get account balance", "Please restart the app")]
                print(error)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func signTapped() {
        let signingViewController = SigningViewController(user: user)
        navigationController?.pushViewController(signingViewController, animated: true)
    }
    
    @objc private func verifyTapped() {
        let verificationViewController = VerificationViewController(user: user)
        navigationController?.pushViewController(verificationViewController, animated: true)
    }
}

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountDetailTableViewCell.reuseIdentifier) as? AccountDetailTableViewCell else {
            fatalError("\(#file): tableView is not correctly setup!")
        }
        
        cell.configure(title: infoData[indexPath.row].0, subtitle: infoData[indexPath.row].1)
        
        return cell
    }
}
