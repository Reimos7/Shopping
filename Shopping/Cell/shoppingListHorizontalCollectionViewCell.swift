//
//  shoppingListHorizontalCollectionViewCell.swift
//  Shopping
//
//  Created by Reimos on 7/29/25.
//

import UIKit
import Kingfisher

final class shoppingListHorizontalCollectionViewCell: BaseCollectionViewCell {
    
    private let shoppingHorizontalImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let shoppingHorizontalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    override func configureHierarchy() {
        [shoppingHorizontalImage, shoppingHorizontalLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        shoppingHorizontalImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(shoppingHorizontalImage.snp.width)
        }
        shoppingHorizontalLabel.snp.makeConstraints { make in
            make.top.equalTo(shoppingHorizontalImage.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-2)
        }
    }

    func configure(url imageUrl: String, name: String) {
        guard let url = URL(string: imageUrl),
              !imageUrl.isEmpty else {
            shoppingHorizontalImage.image = UIImage(systemName: "xmark")
            return
        }
        
        shoppingHorizontalImage.kf.setImage(with: url)
        shoppingHorizontalLabel.text = name.strippingHTML()
              
    }
}
