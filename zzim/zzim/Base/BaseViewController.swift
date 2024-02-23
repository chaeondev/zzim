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
    
    func showAlertMessage(title: String, message: String, button: String = "확인", handler: (() -> Void)? = nil ) { //매개변수 기본값
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: button, style: .default) { _ in
            handler?()
        }
        
        alert.addAction(button)
        
        present(alert, animated: true)
    }
    
}
