//
//  CryptoServiceConfig.swift
//  Upstox
//
//  Created by Naveen.Katari on 12/11/24.
//

import Foundation

struct CryptoServiceConfig: NetworkConfigurable {
    let baseURL = URL(string: "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/")!
    let method: HTTPMethod = .get
    let headers: [String: String]? = nil
    let body: Data? = nil
}
