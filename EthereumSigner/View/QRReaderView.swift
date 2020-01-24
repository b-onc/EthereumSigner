//
//  QRReaderView.swift
//  EthereumSigner
//
//  Created by Bahadir Oncel on 23.01.2020.
//  Copyright © 2020 Piyuv OU. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRReaderViewDelegate: class {
    func qrReaderView(_ qrReaderView: QRReaderView, detected string: String)
    func didFailToSetup(qrReaderView: QRReaderView)
}

class QRReaderView: UIView {
    weak var delegate: QRReaderViewDelegate?
    
    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var qrCodeFrameView = UIView()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Could not find capture device!")
            delegate?.didFailToSetup(qrReaderView: self)
            return
        }
         
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession.addInput(input as AVCaptureInput)
        } catch {
            print(error)
            delegate?.didFailToSetup(qrReaderView: self)
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = layer.bounds
        layer.addSublayer(videoPreviewLayer)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        addSubview(qrCodeFrameView)
        bringSubviewToFront(qrCodeFrameView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        videoPreviewLayer?.frame = layer.bounds
    }
}

extension QRReaderView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.isEmpty {
            qrCodeFrameView.frame = CGRect.zero
            return
        }
            
        // Get the metadata object.
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            return
        }
            
        if metadataObj.type == AVMetadataObject.ObjectType.qr, let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) as? AVMetadataMachineReadableCodeObject {
            // If the found metadata is equal to the QR code metadata then set the bounds
            qrCodeFrameView.frame = barCodeObject.bounds;
            if let string = metadataObj.stringValue {
                delegate?.qrReaderView(self, detected: string)
            }
        }
    }
}
