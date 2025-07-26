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
    
    var list: Shopping = Shopping(total: 0, items: [])
    
    // TODO: - decimal , 적용하기
    let resultLabel = {
        let label = UILabel()
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
        st.distribution = .fillProportionally  // 분배를 어떻게 할래? fillEqually = 높이 간격을 동일하게 채움
        st.alignment = .center   // 스택뷰 정렬에서는 완전히 채우는 fill이 있다
        // st.backgroundColor = .red
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
        shoppingListCollectionView.reloadData()
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
            make.top.equalTo(resultLabel.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.height.equalTo(40)
            //make.width.equalTo(200)
        }
        
        shoppingListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterButtonStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        shoppingListCollectionView.register(ShoppingListCollectionViewCell.self, forCellWithReuseIdentifier: CellConfiguration.shoppingCell.identifier)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let total = list.total
        guard let totalResult = numberFormatter.string(for: total) else {return}
        resultLabel.text = "\(totalResult) 개의 검색 결과"
        
        setupButtons()
        
    }
    
    
    private func setupButtons() {
        let buttonTitle = ["정확도", "날짜순", "가격높은순", "가격낮은순"]
        //let sender = 0..<buttonTitle.count
        
        var buttons: [UIButton] = []
        
        for i in 0..<buttonTitle.count {
            let button = {
                let button = UIButton()
                button.setTitle(buttonTitle[i], for: .normal)
                button.titleLabel?.font = .boldSystemFont(ofSize: 17)
                button.setTitleColor(.black, for: .normal)
                button.layer.cornerRadius = 10
                button.layer.borderWidth = 1
                button.tag = i
                //button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                buttons.append(button)
                print("================================================")
                print(button.tag)
                return button
            }()
            
            
            // button.tag = i
            filterButtonStackView.addArrangedSubview(button)
            
            button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        }
        // print("--=============================================")
        //print(buttons)
        //createButtons(buttons: buttons)
        
    }
    
    @objc
    func tappedButton(sender: UIButton) {
        print(#function, sender.tag)
        
        switch sender.tag {
        case 0:
            print("정확도")
        case 1:
            print("날짜순")
        case 2:
            print("가격 높은순")
        case 3:
            print("가격 낮은순")
        default:
            print("hh")
        }
        
    }
    
    //    private func createButtons(buttons: [UIButton]) {
    //        let backgroundView = UIView()
    //        
    //        let butonView =  {
    //            let view = UIView()
    //            view.layer.cornerRadius = 10
    //            return view
    //        }()
    //        
    //        let buttons = {
    //            
    //        }
    //    }
    
}


// MARK: - UICollectionViewDataSource
extension ShoppingListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellConfiguration.shoppingCell.identifier, for: indexPath) as! ShoppingListCollectionViewCell
        
        let item = list.items[indexPath.item]
        
        cell.mallNameLabel.text = item.mallName
        cell.titleLabel.text = item.title
        cell.priceLabel.text = item.lprice
        cell.configure(url: item.image)
        
        return cell
    }
    
    
}


// MARK: - UICollectionViewDelegate
extension ShoppingListViewController: UICollectionViewDelegate {
    
}
