//
//  NetworkService.swift
//  Upstox
//
//  Created by Naveen.Katari on 12/11/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol CryptoCoinsFetchable {
    func fetchCryptoCoins(completion: @escaping (Result<[CryptoCoin], Error>) -> Void)
}

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

struct NetworkService: CryptoCoinsFetchable {
    private let config: NetworkConfigurable
    
    init(config: NetworkConfigurable) {
        self.config = config
    }
    
    func fetchCryptoCoins(completion: @escaping (Result<[CryptoCoin], Error>) -> Void) {
        var request = URLRequest(url: config.baseURL)
        request.httpMethod = config.method.rawValue
        request.allHTTPHeaderFields = config.headers
        request.httpBody = config.body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data error", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let coins = try JSONDecoder().decode([CryptoCoin].self, from: data)
                completion(.success(coins))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }.resume()
    }
}

