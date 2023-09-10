//
//  ProductCollectionViewCell.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/07.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: BaseCollectionViewCell {
    
    var searchData: Item?
    
    var likeRecord: FavoriteProduct?
    
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
    
    let repository = FavoriteProductRepository()
    
    var completionHandler : (() -> Void)?

    override func configure() {
        contentView.addSubview(imageView)
        // ???: ImageView에 likeButton을 넣으면 addTarget 작동 안함 왜..?
        contentView.addSubview(likeButton)
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
            make.bottom.equalTo(imageView.snp.bottom).inset(8)
            make.trailing.equalTo(imageView.snp.trailing).inset(8)
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
    
    func configureSearchViewCell() {
        
        guard let data = searchData else { return }
        imageView.kf.setImage(with: URL(string: data.image))
        // MARK: 검색어 일치하는 타이틀 <b>태그 감싸지는거 text처리하기
        let sample = data.title.replacingOccurrences(of: "<b>", with: "")
        let title = sample.replacingOccurrences(of: "</b>", with: "")
        titleLabel.text = title
        mallNameLabel.text = data.mallName
        // MARK: 가격 data formatter
        priceLabel.text = Int(data.lprice)?.AddCommaToNumberString()
        likeButton.addTarget(self, action: #selector(likeButtonClickedInSearch), for: .touchUpInside)
        
    }
    
    func configureLikesViewCell() {
        guard let record = likeRecord else { return }
        imageView.kf.setImage(with: URL(string: record.image))
        let sample = record.title.replacingOccurrences(of: "<b>", with: "")
        let title = sample.replacingOccurrences(of: "</b>", with: "")
        titleLabel.text = title
        mallNameLabel.text = record.mallName
        priceLabel.text = Int(record.price)?.AddCommaToNumberString()
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonClickedInLikes), for: .touchUpInside)
    }
    
    // MARK: 체크하기
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: likesView일때 고려해서 다시만들기 -> isEmpty부분 조건 추가하기
    @objc func likeButtonClickedInSearch() {
        
        guard let data = searchData else { return }
        
        let isEmpty =  self.repository.checkDataIsEmpty(data: data)
        
        if isEmpty {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.repository.createItem(data)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            self.repository.deleteItem(data)
        }
 
    }
    
    @objc func likeButtonClickedInLikes() {
        guard let record = likeRecord else { return }
        
        self.repository.deleteRecord(record)
        completionHandler?()
    }
}
