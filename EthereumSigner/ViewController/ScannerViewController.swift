//
//  ScannerViewController.swift
//  EthereumSigner
//
//  Created by Bahadir Oncel on 22.01.2020.
//  Copyright © 2020 Piyuv OU. All rights reserved.
//

import UIKit
import SnapKit

class ScannerViewController: UIViewController {
    private let user: User
    private let message: String
    
    private let qrReaderView = QRReaderView()
    
    init(user: User, message: String) {
        self.user = user
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "QR Code Scanner"
        
        qrReaderView.delegate = self
        view.addSubview(qrReaderView)
        
        qrReaderView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func displayAlert(with message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default, handler: { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension ScannerViewController: QRReaderViewDelegate {
    func qrReaderView(_ qrReaderView: QRReaderView, detected string: String) {
        guard presentedViewController == nil else { return }
        
        func displayInvalidSignature() {
            displayAlert(with: "Invalid signature")
        }
        func displayValidSignature() {
            displayAlert(with: "Signature is valid")
        }
        
        guard let data = Data(base64Encoded: string) else {
            displayInvalidSignature()
            return
        }
        
        do {
            let signature = try JSONDecoder().decode(Signature.self, from: data)
            if user.verify(message: message, signature: signature) {
                displayValidSignature()
            } else {
                displayInvalidSignature()
            }
        } catch {
            print(error)
            displayInvalidSignature()
        }
    }
}
