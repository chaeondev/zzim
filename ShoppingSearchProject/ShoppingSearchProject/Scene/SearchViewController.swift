//
//  SearchViewController.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/07.
//

import UIKit

class SearchViewController: BaseViewController {
    
    // MARK: access control, lazy property 고려하기 -> ARC에 영향?
    private lazy var searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력해주세요"
        view.showsCancelButton = true
        view.delegate = self
        return view
    }()
    
    let sortByAccuracyButton = {
        let view = SortButton()
        view.setTitle("정확도", for: .normal)
        return view
    }()
    let sortByDateButton = {
        let view = SortButton()
        view.setTitle("날짜순", for: .normal)
        return view
    }()
    let sortByHighPrice = {
        let view = SortButton()
        view.setTitle("가격높은순", for: .normal)
        return view
    }()
    let sortByLowPrice = {
        let view = SortButton()
        view.setTitle("가격낮은순", for: .normal)
        return view
    }()
    
    // MARK: 스크롤 시 안보이게 구현 고려하기 -> reusableheader 사용?
    private lazy var stackView = {
        let view = UIStackView(arrangedSubviews: [sortByAccuracyButton, sortByDateButton, sortByHighPrice, sortByLowPrice])
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 6
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.collectionViewLayout = collectionViewLayout()
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "쇼핑 검색"
        
    }
    
    override func configure() {
        super.configure()
        
        [searchBar, stackView, collectionView].forEach {
            view.addSubview($0)
        }
        [sortByAccuracyButton, sortByDateButton, sortByHighPrice, sortByLowPrice].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.width.equalToSuperview().multipliedBy(0.65)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        let size = UIScreen.main.bounds.width - (spacing * 3)
        let width = size / 2
        let height = width * 1.5
        layout.itemSize = CGSize(width: width, height: height)
        
        return layout
    }
    
    
    
}

extension SearchViewController: UISearchBarDelegate {
    
}

