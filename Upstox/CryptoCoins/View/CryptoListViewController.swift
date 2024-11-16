//
//  CryptoCoinsViewController.swift
//  Upstox
//
//  Created by Naveen.Katari on 12/11/24.
//
import UIKit

class CryptoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CryptoListViewModelDelegate {
    
    private var viewModel: CryptoListViewModel!
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let filterBarView = FilterBarView(filters: ["Active Coins", "Inactive Coins", "Only Tokens", "Only Coins", "New Coins"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavbar()
        let config = CryptoServiceConfig()
        let networkService = NetworkService(config: config)
        viewModel = CryptoListViewModel(networkService: networkService)
        viewModel.delegate = self
        viewModel.fetchCoins()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        searchBar.delegate = self
        searchBar.placeholder = "Search coins"
        searchBar.tintColor = .black
        searchBar.barTintColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.backgroundImage = UIImage()
        navigationItem.titleView = searchBar
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CryptoCoinCell.self, forCellReuseIdentifier: "CryptoCoinCell")
        view.addSubview(tableView)
        
        filterBarView.delegate = self
        view.addSubview(filterBarView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        filterBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: filterBarView.topAnchor)
        ])
    }
    
    private func setupNavbar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ColorConstants.navBarColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - CryptoListViewModelDelegate
    
    func didUpdateCryptoList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCoinCell", for: indexPath) as! CryptoCoinCell
        let coin = viewModel.filteredCoins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
    
    // MARK: - SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCoins(query: searchText)
    }
}

extension CryptoListViewController: FilterBarDelegate {
    func didSelectFilter(at index: Int) {
            guard let filter = FilterType(rawValue: index) else { return }
            viewModel.toggleFilter(filter)
            tableView.reloadData()
    }
}
