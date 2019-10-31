//
//  KeychainAccessible.swift
//  ToDo
//
//  Created by Cesar Paiva on 23/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import Foundation

protocol KeychainAccessible {
    func setPassword(_ password: String, account: String)
    func deletePasswordForAccount(_ account: String)
    func passwordForAccount(_ account: String) -> String?
}
