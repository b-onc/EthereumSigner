//
//  Signature.swift
//  EthereumSigner
//
//  Created by Bahadir Oncel on 23.01.2020.
//  Copyright © 2020 Piyuv OU. All rights reserved.
//

import Foundation
import Web3

struct Signature: Codable {
    let v: UInt
    let r: Bytes
    let s: Bytes
}
