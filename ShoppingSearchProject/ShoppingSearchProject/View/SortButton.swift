//
//  SortButton.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/07.
//

import UIKit

final class SortButton: UIButton {
    
    var sortMethod: Sort?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = .systemFont(ofSize: 14)
        layer.cornerRadius = Constants.Design.cornerRadius
        layer.borderWidth = 1
        clipsToBounds = true
        setTitleColor(.label, for: .normal)
        tintColor = .label
        layer.borderColor = UIColor.label.cgColor
        backgroundColor = .systemBackground

    }
    
    override var isSelected: Bool {
        didSet {
            setTitleColor(.systemBackground, for: .selected)
            tintColor = isSelected ? .systemBackground : .label
            layer.borderColor = isSelected ? UIColor.systemBackground.cgColor : UIColor.label.cgColor
            backgroundColor = isSelected ? .label : .systemBackground
            setNeedsDisplay()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// TODO: CGColor 다크모드 대응 + Color Enum 효과적..? 고려
