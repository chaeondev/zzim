//
//  ProductCollectionViewCell.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/07.
//

import UIKit

class ProductCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let view = PhotoImageView(frame: .zero)
        view.backgroundColor = .blue
        return view
    }()
    
    let likeButton = {
        let view = RoundButton(frame: .zero)
        view.backgroundColor = .white
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .black
        return view
    }()
    
    let mallNameLabel = {
        let view = UILabel()
        view.text = "[월드캠핑카]"
        view.textColor = .secondaryLabel
        view.font = .systemFont(ofSize: 13, weight: .semibold)
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.text = "스타리아 2층 캠핑카"
        view.textColor = .label
        view.font = .boldSystemFont(ofSize: 14)
        view.numberOfLines = 2
        return view
    }()
    
    let priceLabel = {
        let view = UILabel()
        view.text = "19,000,000"
        view.textColor = .label
        view.font = .systemFont(ofSize: 17, weight: .heavy)
        return view
    }()
    
    override func configure() {
        contentView.addSubview(imageView)
        imageView.addSubview(likeButton)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func setConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.imageView.snp.width)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(self.likeButton.snp.width)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(6)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(6)
            make.height.lessThanOrEqualToSuperview().multipliedBy(0.15)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(6)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }
}
