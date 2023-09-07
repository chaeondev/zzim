//
//  RoundButton.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/08.
//

import UIKit

final class RoundButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    func configureView() {
        clipsToBounds = true
    }
}
