//
//  SignatureViewController.swift
//  EthereumSigner
//
//  Created by Bahadir Oncel on 22.01.2020.
//  Copyright © 2020 Piyuv OU. All rights reserved.
//

import UIKit
import SnapKit

class SignatureViewController: UIViewController {
    private let user: User
    private let message: String
    
    private let messageLabel = UILabel()
    private let qrImageView = UIImageView()
    
    init(user: User, message: String) {
        self.user = user
        self.message = message
        super.init(nibName: nil, bundle: nil)
        
        messageLabel.text = "Message: \"\(message)\""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Signature"
        
        messageLabel.font = .boldSystemFont(ofSize: 16)
        view.addSubview(messageLabel)

        view.addSubview(qrImageView)
        
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        qrImageView.snp.makeConstraints { (make) in
            make.top.equalTo(messageLabel.snp.bottom).offset(72)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        generateAndSetQRCode()
    }
    
    private func generateAndSetQRCode() {
        let signature = user.sign(message: message)
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            print("error when generating QR code: no CIQRCodeGenerator")
            messageLabel.text = "Error when generating QR Code"
            return
        }
        qrFilter.setValue(signature.data(using: .utf8), forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else {
            print("error when generating QR code: no output Image")
            messageLabel.text = "Error when generating QR Code"
            return
        }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else {
            print("error when generating QR code: no CGImage")
            messageLabel.text = "Error when generating QR Code"
            return
        }
        let processedImage = UIImage(cgImage: cgImage)
        
        qrImageView.image = processedImage
    }
}
