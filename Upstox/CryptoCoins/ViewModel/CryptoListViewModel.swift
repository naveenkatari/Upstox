//
//  CryptoListViewModel.swift
//  Upstox
//
//  Created by Naveen.Katari on 12/11/24.
//

import Foundation

protocol CryptoListViewModelDelegate: AnyObject {
    func didUpdateCryptoList()
    func didFailWithError(_ error: Error)
}

enum FilterType: Int {
    case activeCoins = 0
    case inactiveCoins
    case onlyTokens
    case onlyCoins
    case newCoins
}

class CryptoListViewModel {
    private var allCoins: [CryptoCoin] = []
    private(set) var filteredCoins: [CryptoCoin] = []
    
    weak var delegate: CryptoListViewModelDelegate?
    
    // Filter properties
    var isFilterActiveOnly = false
    var isFilterInactiveOnly = false
    var isFilterNewOnly = false
    var isFilterTokensOnly = false
    var isFilterCoinsOnly = false
    var selectedType: String?
    
    private let networkService: CryptoCoinsFetchable
    
    init(networkService: CryptoCoinsFetchable) {
        self.networkService = networkService
    }
    
    func fetchCoins() {
        networkService.fetchCryptoCoins { [weak self] result in
            switch result {
            case .success(let coins):
                self?.allCoins = coins
                self?.applyFilters()
                self?.delegate?.didUpdateCryptoList()
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
            }
        }
    }
    
    func applyFilters() {
        filteredCoins = allCoins.filter { coin in
            let matchesActive = !isFilterActiveOnly || coin.isActive
            let matchesInactive = !isFilterInactiveOnly || !coin.isActive
            let matchesNew = !isFilterNewOnly || coin.isNew
            let matchesTokensOnly = !isFilterTokensOnly || coin.type == "token"
            let matchesCoinsOnly = !isFilterCoinsOnly || coin.type == "coin"
            return matchesActive && matchesInactive && matchesNew && matchesTokensOnly && matchesCoinsOnly
        }
    }
    
    func toggleFilter(_ filter: FilterType) {
        switch filter {
        case .activeCoins:
            isFilterActiveOnly.toggle()
            isFilterInactiveOnly = false
        case .inactiveCoins:
            isFilterInactiveOnly.toggle()
            isFilterActiveOnly = false
        case .onlyTokens:
            isFilterTokensOnly.toggle()
            isFilterCoinsOnly = false
        case .onlyCoins:
            isFilterCoinsOnly.toggle()
            isFilterTokensOnly = false
        case .newCoins:
            isFilterNewOnly.toggle()
        }
        applyFilters()
    }
    
    func searchCoins(query: String) {
            if query.isEmpty {
                applyFilters()
            } else {
                filteredCoins = allCoins.filter { coin in
                    (coin.name.lowercased().contains(query.lowercased()) ||
                     coin.symbol.lowercased().contains(query.lowercased())) &&
                    (isFilterActiveOnly == false || coin.isActive) &&
                    (isFilterNewOnly == false || coin.isNew) &&
                    (selectedType == nil || coin.type == selectedType)
                }
            }
            delegate?.didUpdateCryptoList()
        }
}
