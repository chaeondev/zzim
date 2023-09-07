//
//  SortButton.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/07.
//

import UIKit

final class SortButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitleColor(.label, for: .normal)
        tintColor = .label
        layer.cornerRadius = Constants.Design.cornerRadius
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1
        clipsToBounds = true

    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

