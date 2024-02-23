//
//  DetailWebViewController.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/11.
//

import UIKit
import WebKit

class DetailWebViewController: BaseViewController, WKUIDelegate {
    
    var webView = WKWebView()

    var data: Item?
    var product: FavoriteProduct?
    
    let repository = FavoriteProductRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = data else { return }
        navigationItem.title = data.title.deleteTag()
        navigationController?.navigationBar.tintColor = .white
        guard let productURL = URL(string: "https://msearch.shopping.naver.com/product/\(data.productID)") else { return }
        let productRequest = URLRequest(url: productURL)
        webView.load(productRequest)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let data = data else { return }
        let heart = repository.checkDataIsEmpty(id: data.productID) ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: heart, style: .plain, target: self, action: #selector(likeButtonTapped))
    }
    
    @objc func likeButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let data = data else { return }
        if repository.checkDataIsEmpty(id: data.productID) {
            sender.image = UIImage(systemName: "heart.fill")
            let product = FavoriteProduct(id: data.productID, title: data.title, mallName: data.mallName, image: data.image, price: data.lprice, like: true, savedDate: Date())
            self.repository.createItem(product)
        } else {
            sender.image = UIImage(systemName: "heart")
            guard let product = repository.fetch().filter({ $0.id == data.productID }).first else { return }
            self.repository.deleteItem(product)
        }
            
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(webView)
        webView.uiDelegate = self
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

