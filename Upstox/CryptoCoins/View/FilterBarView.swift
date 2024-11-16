//
//  FilterBarView.swift
//  Upstox
//
//  Created by Naveen.Katari on 12/11/24.
//

import UIKit

protocol FilterBarDelegate: AnyObject {
    func didSelectFilter(at index: Int)
}

import UIKit

class FilterBarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var filters: [String]
    private var selectedFilters: Set<Int>
    weak var delegate: FilterBarDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .lightGray
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        return collectionView
    }()
    
    init(filters: [String]) {
        self.filters = filters
        self.selectedFilters = []
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }
        
    override var intrinsicContentSize: CGSize {
        collectionView.layoutIfNeeded()
        let height = collectionView.contentSize.height + 16 // Constant for padding
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    func configureFilters(_ filters: [String]) {
        self.filters = filters
        selectedFilters.removeAll()
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }
        let isSelected = selectedFilters.contains(indexPath.item)
        cell.configure(with: filters[indexPath.item], isSelected: isSelected)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedFilters.contains(indexPath.item) {
            selectedFilters.remove(indexPath.item)
        } else {
            selectedFilters.insert(indexPath.item)
        }
        delegate?.didSelectFilter(at: indexPath.item)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isSelected = selectedFilters.contains(indexPath.item)
        let textWidth = (filters[indexPath.item] as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width
        let checkmarkWidth: CGFloat = isSelected ? 24 : 0
        // Cell height constant 20
        //Padding on both sides 16.
        return CGSize(width: textWidth + checkmarkWidth + 16, height: 20)
    }
}
