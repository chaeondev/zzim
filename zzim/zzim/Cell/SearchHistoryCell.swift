//
//  SearchHistoryCell.swift
//  zzim
//
//  Created by Chaewon on 2/24/24.
//

import UIKit
import SnapKit

final class SearchHistoryCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "clock.arrow.circlepath")
        view.tintColor = UIColor(resource: .point)
        return view
    }()
    
    private lazy var historyLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15)
        view.textColor = .label
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setHierarchy()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(historyLabel)
    }
    
    private func setConstraints() {
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalTo(20)
        }
        
        historyLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(_ text: String) {
        historyLabel.text = text
    }
}
