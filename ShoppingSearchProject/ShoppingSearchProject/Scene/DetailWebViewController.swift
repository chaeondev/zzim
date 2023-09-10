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
    var productTitle: String = ""
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sample = productTitle.replacingOccurrences(of: "<b>", with: "")
        let title = sample.replacingOccurrences(of: "</b>", with: "")
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .label
        guard let productURL = URL(string: "https://msearch.shopping.naver.com/product/\(id)") else { return }
        let productRequest = URLRequest(url: productURL)
        webView.load(productRequest)
        
    }
    
    override func configure() {
        super.configure()
        
        view.addSubview(webView)
        
        
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
