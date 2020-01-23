//
//  User.swift
//  EthereumSigner
//
//  Created by Bahadir Oncel on 22.01.2020.
//  Copyright © 2020 Piyuv OU. All rights reserved.
//

import Foundation
import Web3

class User {
    lazy var address = ethereumPrivateKey.address.hex(eip55: false)
    
    private let ethereumPrivateKey: EthereumPrivateKey
    
    private let web3 = Web3(rpcURL: Config.rinkebyEndpoint)
    
    init?(privateKey: String) {
        do {
            ethereumPrivateKey = try EthereumPrivateKey(hexPrivateKey: privateKey)
        } catch {
            print(error)
            return nil
        }
    }
    
    func balance(_ completion: @escaping (Result<Double, Error>) -> ()) {
        web3.eth.getBalance(address: ethereumPrivateKey.address, block: .latest) { (response) in
            if let error = response.error {
                completion(.failure(error))
            } else if let result = response.result {
                completion(.success(Double(result.quantity)/pow(10, 18)))
            } else {
                completion(.failure(NSError(domain: "No result!", code: -1, userInfo: [:])))
            }
        }
    }
    
    func sign(message: String) -> String {
        do {
            let result = try ethereumPrivateKey.sign(message: message.makeBytes())
            let signature = Signature(v: result.v, r: result.r, s: result.s)
            return try JSONEncoder().encode(signature).base64EncodedString()
        } catch {
            print(error)
            return ""
        }
    }
    
    func verify(message: String, signature: Signature) -> Bool {
        return (try? ethereumPrivateKey.publicKey.verifySignature(message: message.makeBytes(), v: signature.v, r: .init(signature.r), s: .init(signature.s))) ?? false
    }
}
