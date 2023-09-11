//
//  LikesViewController.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/07.
//

import UIKit
import RealmSwift

class LikesViewController: BaseViewController {
    
    private lazy var searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력해주세요"
        view.showsCancelButton = true
        view.delegate = self
        return view
    }()
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        view.collectionViewLayout = collectionViewLayout()
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
    var products: Results<FavoriteProduct>?
    var searchList: [FavoriteProduct] = []
    
    let repository = FavoriteProductRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "좋아요 목록"
        products = repository.fetch()
        searchList.removeAll()
        products!.forEach { searchList.append($0) }
        
        
    }
    
    // 이부분 고치기 -> 아마해결..
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tapGesture.cancelsTouchesInView = false
        collectionView.reloadData()
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addGestureRecognizer(tapGesture)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LikesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //guard let products = products else { return 0 }
        return searchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        
        let product = searchList[indexPath.row]
        cell.data = Item(title: product.title, link: "", image: product.image, lprice: product.price, hprice: "", mallName: product.mallName, productID: product.id, productType: "", brand: "", maker: "")
        cell.configureCell()
        cell.completionHandler = {
            self.searchList.removeAll()
            self.products!.forEach { self.searchList.append($0) }
            collectionView.reloadData()
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let products = products else { return }
        let product = products[indexPath.row]
        let vc = DetailWebViewController()
        
        vc.data = Item(title: product.title, link: "", image: product.image, lprice: product.price, hprice: "", mallName: product.mallName, productID: product.id, productType: "", brand: "", maker: "")
        
        navigationController?.pushViewController(vc, animated: true)
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

extension LikesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            searchQuery(text: text)
        }
        if searchBar.text == "" {
            searchList.removeAll()
            products!.forEach { searchList.append($0) }
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        searchQuery(text: text)
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let products = products else { return }
        searchList.removeAll()
        products.forEach { searchList.append($0) }
        searchBar.text = ""
        collectionView.reloadData()
    }
    
    func searchQuery(text: String) {
        searchList.removeAll()
        guard let products = products else { return }
        for item in products {
            if item.title.contains(text) {
                searchList.append(item)
            }
        }
        collectionView.reloadData()
    }
    
    
}

// 스크롤 안될시 화면 탭할때 키보드 내리기
// 상세화면 갔다가 돌아왔을때 검색어 화면 유지
