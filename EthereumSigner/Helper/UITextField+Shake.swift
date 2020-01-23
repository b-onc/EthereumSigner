//
//  UITextField+Shake.swift
//  EthereumSigner
//
//  Created by Bahadir Oncel on 23.01.2020.
//  Copyright © 2020 Piyuv OU. All rights reserved.
//

import UIKit

extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y))

        layer.add(animation, forKey: "position")
    }
}
