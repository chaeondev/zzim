//
//  BaseViewController.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/07.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        
    }
    
    func showAlertMessage(title: String, button: String = "확인", handler: (() -> Void)? = nil ) { //매개변수 기본값
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let button = UIAlertAction(title: button, style: .default) { _ in
            handler?()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(button)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
}
