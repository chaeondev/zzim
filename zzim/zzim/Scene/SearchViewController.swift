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
        view.tintColor = .label
        view.showsCancelButton = true
        view.delegate = self
        return view
    }()

    private lazy var sortByAccuracyButton = {
        let view = SortButton()
        view.sortMethod = .sim
        view.setTitle("정확도", for: .normal)
        view.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        return view
    }()
    private lazy var sortByDateButton = {
        let view = SortButton()
        view.sortMethod = .date
        view.setTitle("날짜순", for: .normal)
        view.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        return view
    }()
    private lazy var sortByHighPriceButton = {
        let view = SortButton()
        view.sortMethod = .dsc
        view.setTitle("가격높은순", for: .normal)
        view.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        return view
    }()
    private lazy var sortByLowPriceButton = {
        let view = SortButton()
        view.sortMethod = .asc
        view.setTitle("가격낮은순", for: .normal)
        view.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        return view
    }()
    
    // MARK: pagination 하다가 위로 올라가는 거 구현하기
    private lazy var stackView = {
        let view = UIStackView(arrangedSubviews: [sortByAccuracyButton, sortByDateButton, sortByHighPriceButton, sortByLowPriceButton])
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
    
    private lazy var historyTableView = {
        let view = UITableView(frame: .zero)
        view.register(SearchHistoryCell.self, forCellReuseIdentifier: SearchHistoryCell.description())
        view.isHidden = true
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        return view
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
    var page = 1
    var productList: Shopping = Shopping(total: 0, start: 0, display: 0, items: [])
    var startLocation: Int = 1
    
    var selectedButton: SortButton?
    
    //검색 기록
    var historyList: [String] = []
    var searchWord: String = ""
    
    let repository = FavoriteProductRepository()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaultsManager.searchHistory = []

        setNavigation()
        
        tabBarController?.tabBar.tintColor = UIColor(resource: .point)
        tabBarController?.tabBar.backgroundColor = .systemBackground
        
        repository.checkRealmFileURL()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tapGesture.cancelsTouchesInView = false
        collectionView.reloadData()
        
        loadHistory()
    }
    
    override func configure() {
        super.configure()
        
        [searchBar, stackView, collectionView, historyTableView].forEach {
            view.addSubview($0)
        }
        [sortByAccuracyButton, sortByDateButton, sortByHighPriceButton, sortByLowPriceButton].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addGestureRecognizer(tapGesture)
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
        
        historyTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setNavigation() {
        navigationItem.title = "쇼핑 검색"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(resource: .point)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
                } errorHandler: { error in
                    self.showAlertMessage(title: "네트워크 통신 오류", message: "다시 시도해주세요")
                }
            }
        }
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryCell.description(), for: indexPath) as? SearchHistoryCell else { return UITableViewCell() }
        
        let data = historyList[indexPath.row]
        
        cell.configureCell(data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.deleteHistory(index: indexPath.row)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        historyTableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        historyTableView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if selectedButton == nil {
            selectButton(button: sortByAccuracyButton)
        }
        
        guard let selectedButton else { return }
        
        // MARK: 위 구문 어떻게 고치고 싶다...
        
        startLocation = 1
        guard let query = searchBar.text else { return } // MARK: guard 예외처리
        saveHistory(query)
        
        APIService.shared.searchProduct(query: query, start: startLocation, sort: selectedButton.sortMethod!) { data in
            self.productList = data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        } errorHandler: { error in
            self.showAlertMessage(title: "네트워크 통신 오류", message: "다시 시도해주세요")
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

// 검색어 없을 때 정렬기능 버튼 클릭 막기 -> 정렬버튼 후 검색도 허용되게 만들기 -> 해결!!

// 정렬 기능 구현
extension SearchViewController {
    
    //add target sortButton action 통합
    @objc func sortButtonClicked(_ sender: SortButton) {
        selectButton(button: sender)
        startLocation = 1
        if let query = searchBar.text, searchBar.text != "" {
            APIService.shared.searchProduct(query: query, start: startLocation, sort: sender.sortMethod ?? .sim) { data in
                self.productList = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
            } errorHandler: { error in
                self.showAlertMessage(title: "네트워크 통신 오류", message: "다시 시도해주세요")
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

// MARK: 검색 기록 관련 메서드
extension SearchViewController {
    
    func loadHistory() {
        historyList = UserDefaultsManager.searchHistory.reversed()
        historyTableView.reloadData()
    }
    
    func saveHistory(_ word: String) {
        var newList = UserDefaultsManager.searchHistory
        newList.removeAll { $0 == word }
        newList.append(word)
        UserDefaultsManager.searchHistory = newList
        self.loadHistory()
    }
    
    func deleteHistory(index: Int) {
        var newList: [String] = UserDefaultsManager.searchHistory.reversed()
        newList.remove(at: index)
        UserDefaultsManager.searchHistory = newList.reversed()
        self.loadHistory()
    }
}

