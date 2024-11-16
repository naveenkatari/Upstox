//
//  CryptoListViewModelTests.swift
//  UpstoxTests
//
//  Created by Naveen.Katari on 14/11/24.
//

import XCTest

@testable import Upstox

import XCTest
@testable import Upstox // Replace with your actual module name

// Mock network service conforming to the CryptoCoinsFetchable protocol
class MockNetworkService: CryptoCoinsFetchable {
    var shouldReturnError = false
    var mockCoins: [CryptoCoin] = [
        CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
        CryptoCoin(name: "Ethereum", symbol: "ETH", type: "coin", isActive: true, isNew: true),
        CryptoCoin(name: "Ripple", symbol: "XRP", type: "token", isActive: false, isNew: false)
    ]
    
    func fetchCryptoCoins(completion: @escaping (Result<[CryptoCoin], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        } else {
            completion(.success(mockCoins))
        }
    }
}

class MockCryptoListViewModelDelegate: CryptoListViewModelDelegate {
    var didUpdateCryptoListCalled = false
    var didFailWithErrorCalled = false
    var error: Error?

    func didUpdateCryptoList() {
        didUpdateCryptoListCalled = true
    }
    
    func didFailWithError(_ error: Error) {
        didFailWithErrorCalled = true
        self.error = error
    }
}

class CryptoListViewModelTests: XCTestCase  {
    var viewModel: CryptoListViewModel!
    var mockNetworkService: MockNetworkService!
    var mockDelegate: MockCryptoListViewModelDelegate!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockDelegate = MockCryptoListViewModelDelegate()
        viewModel = CryptoListViewModel(networkService: mockNetworkService)
        viewModel.delegate = mockDelegate
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testFetchCoinsSuccess() {
        viewModel.fetchCoins()
        
        XCTAssertTrue(mockDelegate.didUpdateCryptoListCalled, "Delegate should be notified when coins are successfully fetched.")
        XCTAssertEqual(viewModel.filteredCoins.count, 3, "Expected filtered coin count to be 3 after a successful fetch.")
    }

    func testFetchCoinsFailure() {
        mockNetworkService.shouldReturnError = true
        viewModel.fetchCoins()
        
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled, "Delegate should be notified of a failure in coin fetching.")
        XCTAssertTrue(viewModel.filteredCoins.isEmpty, "Filtered coins list should be empty if fetch fails.")
    }

    func testActiveCoinsFilter() {
        viewModel.fetchCoins()
        viewModel.toggleFilter(.activeCoins)
        
        XCTAssertTrue(viewModel.isFilterActiveOnly, "Active coins filter should be enabled after toggling.")
        XCTAssertEqual(viewModel.filteredCoins.count, 2, "Only active coins should remain in the filtered list.")
        XCTAssertTrue(viewModel.filteredCoins.allSatisfy { $0.isActive }, "All filtered coins should match the active filter condition.")
    }

    func testInactiveCoinsFilter() {
        viewModel.fetchCoins()
        viewModel.toggleFilter(.inactiveCoins)
        
        XCTAssertTrue(viewModel.isFilterInactiveOnly, "Inactive coins filter should be enabled after toggling.")
        XCTAssertEqual(viewModel.filteredCoins.count, 1, "Only inactive coins should remain in the filtered list.")
        XCTAssertTrue(viewModel.filteredCoins.allSatisfy { !$0.isActive }, "All filtered coins should match the inactive filter condition.")
    }

    func testNewCoinsFilter() {
        viewModel.fetchCoins()
        viewModel.toggleFilter(.newCoins)
        
        XCTAssertTrue(viewModel.isFilterNewOnly, "New coins filter should be enabled after toggling.")
        XCTAssertEqual(viewModel.filteredCoins.count, 1, "Only new coins should remain in the filtered list.")
        XCTAssertTrue(viewModel.filteredCoins.allSatisfy { $0.isNew }, "All filtered coins should match the new coins filter condition.")
    }

    func testOnlyTokensFilter() {
        viewModel.fetchCoins()
        viewModel.toggleFilter(.onlyTokens)
        
        XCTAssertTrue(viewModel.isFilterTokensOnly, "Tokens-only filter should be enabled after toggling.")
        XCTAssertEqual(viewModel.filteredCoins.count, 1, "Only tokens should remain in the filtered list.")
        XCTAssertTrue(viewModel.filteredCoins.allSatisfy { $0.type == "token" }, "All filtered coins should match the tokens-only filter condition.")
    }

    func testOnlyCoinsFilter() {
        viewModel.fetchCoins()
        viewModel.toggleFilter(.onlyCoins)
        
        XCTAssertTrue(viewModel.isFilterCoinsOnly, "Coins-only filter should be enabled after toggling.")
        XCTAssertEqual(viewModel.filteredCoins.count, 2, "Only coins should remain in the filtered list.")
        XCTAssertTrue(viewModel.filteredCoins.allSatisfy { $0.type == "coin" }, "All filtered coins should match the coins-only filter condition.")
    }

    func testSearchCoins() {
        viewModel.fetchCoins()
        viewModel.searchCoins(query: "Bit")
        
        XCTAssertEqual(viewModel.filteredCoins.count, 1, "Search query 'Bit' should return exactly one result.")
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin", "The search result should include Bitcoin when querying 'Bit'.")
    }

    func testSearchWithEmptyQuery() {
        viewModel.fetchCoins()
        viewModel.searchCoins(query: "")
        
        XCTAssertEqual(viewModel.filteredCoins.count, 3, "An empty search query should return the full list of coins.")
    }
}

