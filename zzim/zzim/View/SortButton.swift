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
        titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        layer.cornerRadius = Constants.Design.cornerRadius
        layer.borderWidth = 1
        clipsToBounds = true
        setTitleColor(.separator, for: .normal)
        tintColor = .label
        layer.borderColor = UIColor.separator.cgColor
        backgroundColor = .systemBackground

    }
    
    override var isSelected: Bool {
        didSet {
            setTitleColor(.systemBackground, for: .selected)
            tintColor = isSelected ? .systemBackground : UIColor(resource: .point)
            layer.borderColor = isSelected ? UIColor(resource: .point).cgColor : UIColor.separator.cgColor
            backgroundColor = isSelected ? UIColor(resource: .point) : .systemBackground
            setNeedsDisplay()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// TODO: CGColor 다크모드 대응 + Color Enum 효과적..? 고려
