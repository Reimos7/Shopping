//
//  ShoppingListCollectionViewCell.swift
//  Shopping
//
//  Created by Reimos on 7/25/25.
//

import UIKit
import Kingfisher

final class ShoppingListCollectionViewCell: UICollectionViewCell {
    private let shoppingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let mallNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.textAlignment = .left
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    private let likeButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        return button
    }()
    
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
        
        // 고차함수 방식으로
        [shoppingImage, mallNameLabel, titleLabel, priceLabel, likeButtonView, likeButton].forEach {
            contentView.addSubview($0)
        }
        
        //        contentView.addSubview(shoppingImage)
        //        contentView.addSubview(mallNameLabel)
        //        contentView.addSubview(titleLabel)
        //        contentView.addSubview(priceLabel)
        //
        //        contentView.addSubview(likeButtonView)
        //        contentView.addSubview(likeButton)
        
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
            make.bottom.lessThanOrEqualTo(contentView.safeAreaLayoutGuide).offset(-2)
        }
        
        likeButtonView.snp.makeConstraints { make in
            make.trailing.equalTo(shoppingImage.snp.trailing).inset(10)
            make.bottom.equalTo(shoppingImage.snp.bottom).inset(10)
            make.size.equalTo(32)
        }
        
        likeButton.snp.makeConstraints { make in
            make.edges.equalTo(likeButtonView)
        }
        
    }
    
    func configure(url imageUrl: String, mallName: String, title: String, price: String) {
        guard let url = URL(string: imageUrl),
              !imageUrl.isEmpty else {
            shoppingImage.image = UIImage(systemName: "xmark")
            return
        }
        
        shoppingImage.kf.setImage(with: url)
        mallNameLabel.text = mallName
        titleLabel.text = title
        
        let intPrice = Int(price) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let decimalPrice = numberFormatter.string(for: intPrice) ?? price
        priceLabel.text = decimalPrice
        
    }
    
    func configureView() {
        setLikeButton()
    }
    
    // 좋아요 버튼 설정
    private func setLikeButton() {
        likeButtonView.backgroundColor = .white
        // 정원 만들기
        likeButtonView.layer.cornerRadius = 16
        
        likeButton.tintColor = .black
        // 처음엔 전부 false 처리
        updateLikeButtonUI(isLiked: false)
        
        likeButton.addTarget(self, action: #selector(tappedLikeButton), for: .touchUpInside)
    }
    
    
    // MARK: - 좋아요 버튼 클릭
    @objc
    func tappedLikeButton() {
        print(#function)
        likeButton.isSelected.toggle()
        updateLikeButtonUI(isLiked: likeButton.isSelected)
        
        // TODO: - userDefaults
        if likeButton.isSelected {
            print("좋아요")
            
        } else {
            print("좋아요 해제")
        }
        
    }
    
    // 버튼 이미지 변경
    private func updateLikeButtonUI(isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
