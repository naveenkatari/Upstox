//
//  CryptoCoin.swift
//  Upstox
//
//  Created by Naveen.Katari on 12/11/24.
//

import Foundation

struct CryptoCoin: Codable {
    let name: String
    let symbol: String
    let type: String
    let isActive: Bool
    let isNew: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, symbol, type
        case isActive = "is_active"
        case isNew = "is_new"
    }
}
