//
//  ShoppingListViewController.swift
//  Shopping
//
//  Created by Reimos on 7/25/25.
//

import UIKit
import SnapKit
import Alamofire

final class ShoppingListViewController: UIViewController {
    
    let list: [DummyProduct] = dummyProducts
    
    // TODO: - decimal , 적용하기
    let resultLabel = {
        let label = UILabel()
        label.text = "9999999개의 검색 결과"
        label.textColor = .systemGreen
        label.textAlignment = .left
        return label
    }()
    
    // TODO: - 스택뷰 내부에 <정확도, 날짜순, 가격높은순, 가격낮은순> 버튼 4개 넣기
    lazy var filterButtonStackView: UIStackView = {
    
       // arrangedSubviews 생성자의 스택뷰에 올리고 싶은걸 올리기
       let st = UIStackView()
       //let st = UIStackView(arrangedSubviews: [membershipButton,paymentButton,cuponButton])
       st.spacing = 8 // 스택뷰 내부의 간격을 18만큼 띄어주기
       st.axis = .horizontal // 스택뷰의 축 vertical = 세로, horizontal = 가로
       st.distribution = .fillEqually  // 분배를 어떻게 할래? fillEqually = 높이 간격을 동일하게 채움
       st.alignment = .fill    // 스택뷰 정렬에서는 완전히 채우는 fill이 있다
           
       return st
       }()
    
    lazy var shoppingListCollectionView = {
        // TODO: - 특정 문자열 제거하는 함수 사용해서 보여주기
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        //collectionView.backgroundColor = .yellow
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    var navigationTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = navigationTitle
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureCollectionView(sectionInsets: 10, minimumSpacing: 10, cellCount: 2, itemSpacing: 10, lineSpacing: 10, scrollDirectoin: .vertical)
    }
    

    // collectionView 세팅 함수
    func configureCollectionView(sectionInsets: CGFloat, minimumSpacing: CGFloat, cellCount: CGFloat, itemSpacing: Int, lineSpacing: CGFloat, scrollDirectoin: UICollectionView.ScrollDirection) {
        let layout = UICollectionViewFlowLayout()
        
        // 너비
        let deviceWidth = UIScreen.main.bounds.width
        
        // 너비
        let cellWidth = deviceWidth - (sectionInsets * 2) - (minimumSpacing * (cellCount - 1))
        
        let imageHeight = cellWidth / cellCount // 1:1
        let totalHeight = imageHeight + 90 // 레이블 높이 여백 
        
        layout.itemSize = CGSize(width: cellWidth / cellCount, height: totalHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        // 셀 사이 간격
        layout.minimumInteritemSpacing = minimumSpacing
        //
        layout.minimumLineSpacing = lineSpacing
        
        layout.scrollDirection = scrollDirectoin
    
        shoppingListCollectionView.collectionViewLayout = layout
    }

}

// MARK: - ViewDesignProtocol
extension ShoppingListViewController: ViewDesignProtocol {
    func configureHierarchy() {
        view.addSubview(resultLabel)
        view.addSubview(filterButtonStackView)
        view.addSubview(shoppingListCollectionView)
        
    }
    
    func configureLayout() {
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
        }
        
        filterButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(2)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
            make.width.equalTo(200)
        }
        
        shoppingListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterButtonStackView.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        shoppingListCollectionView.register(ShoppingListCollectionViewCell.self, forCellWithReuseIdentifier: CellConfiguration.shoppingCell.identifier)
    }
    
    
}


// MARK: - UICollectionViewDataSource
extension ShoppingListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellConfiguration.shoppingCell.identifier, for: indexPath) as! ShoppingListCollectionViewCell
        
        let item = list[indexPath.item]
        
        cell.shoppingImage.image = UIImage(named: item.imageName)
        cell.mallNameLabel.text = item.name
        cell.titleLabel.text = item.description
        cell.priceLabel.text = item.price
        cell.backgroundColor = .red
      
        return cell
    }
    
    
}


// MARK: - UICollectionViewDelegate
extension ShoppingListViewController: UICollectionViewDelegate {
    
}
