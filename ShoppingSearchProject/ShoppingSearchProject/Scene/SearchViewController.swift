//
//  SearchViewController.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/07.
//

import UIKit
import Kingfisher

class SearchViewController: BaseViewController {
    
    // MARK: access control, lazy property 고려하기 -> ARC에 영향?
    private lazy var searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력해주세요"
        view.showsCancelButton = true
        view.delegate = self
        return view
    }()

    private lazy var sortByAccuracyButton = {
        let view = SortButton()
        view.setTitle("정확도", for: .normal)
        view.addTarget(self, action: #selector(accuracyButtonClicked), for: .touchUpInside)
        return view
    }()
    private lazy var sortByDateButton = {
        let view = SortButton()
        view.setTitle("날짜순", for: .normal)
        view.addTarget(self, action: #selector(dateButtonClicked), for: .touchUpInside)
        return view
    }()
    private lazy var sortByHighPrice = {
        let view = SortButton()
        view.setTitle("가격높은순", for: .normal)
        view.addTarget(self, action: #selector(highPriceButtonClicked), for: .touchUpInside)
        return view
    }()
    private lazy var sortByLowPrice = {
        let view = SortButton()
        view.setTitle("가격낮은순", for: .normal)
        view.addTarget(self, action: #selector(lowPriceButtonClicked), for: .touchUpInside)
        return view
    }()
    
    // MARK: 스크롤 시 안보이게 구현 고려하기 -> reusableheader 사용?
    // MARK: pagination 하다가 위로 올라가는 거 구현하기
    private lazy var stackView = {
        let view = UIStackView(arrangedSubviews: [sortByAccuracyButton, sortByDateButton, sortByHighPrice, sortByLowPrice])
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 6
        return view
    }()
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
        view.collectionViewLayout = collectionViewLayout()
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    var page = 1
    var productList: Shopping = Shopping(lastBuildDate: "", total: 0, start: 0, display: 0, items: [])
    var startLocation: Int = 1
    
    var selectedButton: SortButton?
    
    let repository = FavoriteProductRepository()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "쇼핑 검색"
        repository.checkRealmFileURL()
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
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

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        
        let data = productList.items[indexPath.row]
        cell.data = data
        cell.configureCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailWebViewController()
        vc.data = productList.items[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Pagination
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // MARK: lastPage float로 바꿔서 +1 구현..? 마지막 제품까지 보여주려면 구현하기, start의 최댓값은..? -> 이부분 다시 생각해보기
        // MARK: prefetching 조건 다시한번 체크하기 - 아이템이 별로 없을때는?
        let lastStartLocation = productList.total < 1000 ? productList.total - 30 : 1000 // start의 최댓값 1000
        
        for indexPath in indexPaths {
            if productList.items.count - 1 == indexPath.item && productList.start < lastStartLocation {
                startLocation += 30
                APIService.shared.searchProduct(query: searchBar.text!, start: startLocation, sort: .sim) { data in
                    self.productList.items.append(contentsOf: data.items)
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: 구현하기
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        selectButton(button: sortByAccuracyButton)
        startLocation = 1
        guard let query = searchBar.text else { return } // MARK: guard 예외처리
        APIService.shared.searchProduct(query: query, start: startLocation, sort: .sim) { data in
            self.productList = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        productList.items.removeAll()
        searchBar.text = nil
        collectionView.reloadData()
        view.endEditing(true)
    }
    
}

// 검색어 없을 때 정렬기능 버튼 클릭 막기
// 정렬 기능 구현
extension SearchViewController {
    @objc func accuracyButtonClicked(_ sender: SortButton) {
        selectButton(button: sender)
        startLocation = 1
        guard let query = searchBar.text else { return }
        APIService.shared.searchProduct(query: query, start: startLocation, sort: .sim) { data in
            self.productList = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
    @objc func dateButtonClicked(_ sender: SortButton) {
        selectButton(button: sender)
        startLocation = 1
        guard let query = searchBar.text else { return }
        APIService.shared.searchProduct(query: query, start: startLocation, sort: .date) { data in
            self.productList = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }

    }
    
    @objc func highPriceButtonClicked(_ sender: SortButton) {
        selectButton(button: sender)
        startLocation = 1
        guard let query = searchBar.text else { return }
        APIService.shared.searchProduct(query: query, start: startLocation, sort: .dsc) { data in
            self.productList = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }

    }
    
    @objc func lowPriceButtonClicked(_ sender: SortButton) {
        selectButton(button: sender)
        startLocation = 1
        guard let query = searchBar.text else { return }
        APIService.shared.searchProduct(query: query, start: startLocation, sort: .asc) { data in
            self.productList = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
    func selectButton(button: SortButton) {
        button.isSelected = true
        
        if let previousButton = selectedButton {
            previousButton.isSelected = false
        }
        
        selectedButton = button
    }
}

// 비행기모드 API 오류 해결 -> 이후 인터넷 연결했을때
// 영어 검색 대소문자 구별 없애기
