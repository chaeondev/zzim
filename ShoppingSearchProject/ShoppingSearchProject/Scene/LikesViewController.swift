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
    
    let repository = FavoriteProductRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "좋아요 목록"
        products = repository.fetch()
    }
    
    // 이부분 고치기 -> 아마해결..->아닌듯 ->fetchFilter로 해결!!
    // 검색어 입력결과가 다른 뷰컨 갔다가 돌아와도 유지되어야함
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
        guard let products = products else { return 0 }
        return products.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        if let products {
            let product = products[indexPath.row]
            cell.data = Item(title: product.title, link: "", image: product.image, lprice: product.price, mallName: product.mallName, productID: product.id)
            cell.configureCell()
            cell.completionHandler = {
                collectionView.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let products else { return }
        let product = products[indexPath.row]
        let vc = DetailWebViewController()
        
        vc.data = Item(title: product.title, link: "", image: product.image, lprice: product.price, mallName: product.mallName, productID: product.id)
        
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
            products = repository.fetchFilter(text: text)
            collectionView.reloadData()
        }
        if searchBar.text == "" {
            products = repository.fetch()
            collectionView.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        products = repository.fetchFilter(text: text)
        collectionView.reloadData()
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        products = repository.fetch()
        searchBar.text = ""
        collectionView.reloadData()
    }

}
