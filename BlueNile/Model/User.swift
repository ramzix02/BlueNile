//
//  User.swift
//  BlueNile
//
//  Created by Ahmed Ramzy on 7/15/20.
//  Copyright © 2020 Ahmed Ramzy. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    let status: Int?
    let message: String?
    let data: Data?
}

struct Data: Codable {
    let user: User?
}

struct User: Codable{
    let id: Int?
    let name: String?
    let email: String?
    let phone: String?
    let authorization: String?
    let address: String?
    let ring_sizes: String?
    let necklace_sizes: String?
}
