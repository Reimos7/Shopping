//
//  ShoppingListView.swift
//  Shopping
//
//  Created by Reimos on 7/28/25.
//

import UIKit

// MARK: - ShoppingListVC 사용
class ShoppingListView: BaseView {
    
    // ActivityIndicator
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        // 애니메이션 중(빙글빙글 돌아가게)에만 보여지게 할 것인지
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let resultLabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .left
        return label
    }()
    
    
    // MARK: - 스택뷰 내부에 필터 버튼 4개
    lazy var filterButtonStackView: UIStackView = {
        // arrangedSubviews 생성자의 스택뷰에 올리고 싶은걸 올리기
        let st = UIStackView()
        //let st = UIStackView(arrangedSubviews: [membershipButton,paymentButton,cuponButton])
        st.spacing = 8 // 스택뷰 내부의 간격을 18만큼 띄어주기
        st.axis = .horizontal // 스택뷰의 축 vertical = 세로, horizontal = 가로
        st.distribution = .fillProportionally  // 분배를 어떻게 할래? fillEqually = 높이 간격을 동일하게 채움
        st.alignment = .center   // 스택뷰 정렬에서는 완전히 채우는 fill이 있다
        // st.backgroundColor = .red
        return st
    }()
    
    lazy var shoppingListCollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        //collectionView.backgroundColor = .yellow
        return collectionView
    }()
    
    // 수평 스크롤 컬렉션뷰 하나 더 만들어서, 추천 쇼핑 상품 목록 만들어보기
    lazy var shoppingListHorizontalCollectionView = {
        let collectionView = UICollectionView(frame: .zero,
        collectionViewLayout: UICollectionViewLayout())
        return collectionView
        
    }()

    override func configureHierarchy() {
        [resultLabel, filterButtonStackView, shoppingListCollectionView, activityIndicator, shoppingListHorizontalCollectionView].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        
        filterButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(80)
            make.height.equalTo(40)
            //make.width.equalTo(200)
        }
        
        shoppingListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterButtonStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(100)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        shoppingListHorizontalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(shoppingListCollectionView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }

}
