//
//  ShoppingListCollectionViewCell.swift
//  Shopping
//
//  Created by Reimos on 7/25/25.
//

import UIKit
import Kingfisher

final class ShoppingListCollectionViewCell: UICollectionViewCell {
    let shoppingImage = UIImageView()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShoppingListCollectionViewCell: ViewDesignProtocol {
    func configureHierarchy() {
        contentView.addSubview(shoppingImage)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    func configureLayout() {
        shoppingImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(shoppingImage.snp.width)
            //make.horizontalEdges.top.equalTo(contentView.safeAreaLayoutGuide)
            //make.height.equalTo(shoppingImage.snp.width).multipliedBy(0.5)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(shoppingImage.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(20)
        }
        // TODO: - autodimension 적용하기
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(20)
            make.bottom.lessThanOrEqualTo(contentView.safeAreaLayoutGuide)
        }
        
    }
    
    func configure(url imageUrl: String) {
        let url = URL(string: imageUrl)
        shoppingImage.kf.setImage(with: url)
        
    }
    
    func configureView() {
        shoppingImage.contentMode = .scaleAspectFill
        shoppingImage.clipsToBounds = true
        shoppingImage.layer.cornerRadius = 20
        //shoppingImage.backgroundColor = .yellow
        
        mallNameLabel.text = "ddd"
        mallNameLabel.font = .systemFont(ofSize: 12)
        mallNameLabel.textColor = .darkGray
        mallNameLabel.textAlignment = .left
        
        titleLabel.text = "ssss"
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        
        priceLabel.text = "22222222"
        priceLabel.font = .boldSystemFont(ofSize: 15)
        priceLabel.textAlignment = .left
    }

}
