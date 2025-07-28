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
    
    var navigationTitle = ""
    
    private let resultLabel = {
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
        // TODO: - 특정 문자열 제거하는 함수 사용해서 보여주기
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        //collectionView.backgroundColor = .yellow
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
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
    private func configureCollectionView(sectionInsets: CGFloat, minimumSpacing: CGFloat, cellCount: CGFloat, itemSpacing: Int, lineSpacing: CGFloat, scrollDirectoin: UICollectionView.ScrollDirection) {
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
        
        [resultLabel, filterButtonStackView, shoppingListCollectionView].forEach {
            view.addSubview($0)
        }
//        view.addSubview(resultLabel)
//        view.addSubview(filterButtonStackView)
//        view.addSubview(shoppingListCollectionView)
        
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
        shoppingListCollectionView.register(ShoppingListCollectionViewCell.self, forCellWithReuseIdentifier: CellConfiguration.shoppingCell.identifier)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let total = list.total
        guard let totalResult = numberFormatter.string(for: total) else {return}
        resultLabel.text = "\(totalResult) 개의 검색 결과"
        // 다크모드 대응
        view.backgroundColor = .systemBackground
        
        setupButtons()
        
        setDarkModeSwitch()
        
    }
   
    
    private func setupButtons() {
        let buttonTitle = ["정확도", "날짜순", "가격높은순", "가격낮은순"]
       
        
        var buttons: [UIButton] = []
        
        for i in 0..<buttonTitle.count {
            let button = {
                let button = UIButton()
                button.setTitle(buttonTitle[i], for: .normal)
                button.titleLabel?.font = .boldSystemFont(ofSize: 17)
                button.setTitleColor(.label, for: .normal)
                button.layer.cornerRadius = 10
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.label.cgColor
                
                button.tag = i
                //button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                buttons.append(button)
                print("================================================")
                print(button.tag)
                //updateButtonBorderColor(button: button)
                return button
            }()
            
            
            filterButtonStackView.addArrangedSubview(button)
            
            button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        }
        
        
    }
        
    // MARK: - 환경이 바뀌면 자동 호출됨 - 다크모드 라이트모드 자동 적용 ios17부터 deprecated... 사용 X
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        if previousTraitCollection != nil {
//            
//            // 다크모드 라이트모드 변경후 수행 할 코드
////            if previousTraitCollection?.userInterfaceStyle == .dark {
////                // 다크모드 상태
////                
////            } else {
////                // 다트모드 상태
////            }
//            
//            // 스택뷰에 있는 버튼들에 다크모드 대응을 함
//            for buttons in filterButtonStackView.arrangedSubviews {
//                // buttons view -> button으로 타입 캐스팅 해서, red <-> 다크모드 대응
//                guard let button = buttons as? UIButton else {
//                    // 못하면 red
//                    buttons.layer.borderColor = UIColor.red.cgColor
//                    return
//                }
//                // 다크 모드 대응 함수로 처리
//                updateButtonBorderColor(button: button)
//            }
//        }
//    }
    
    
    // MARK: - ios17+ 다크모드 변경 감지 traitCollectionDidChange 대신 사용
    private func setDarkModeSwitch() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            if self.traitCollection.userInterfaceStyle == .light {
                // 라이트 모드
                print("----------라이트모드----------")
            } else {
                // 다크 모드
                print("----------다크모드----------")
            }
            
            // 스택뷰에 있는 버튼들에 다크모드 대응을 함
            for buttons in self.filterButtonStackView.arrangedSubviews {
                // buttons view -> button으로 타입 캐스팅 , red <-> 다크모드 대응
                guard let button = buttons as? UIButton else {
                    // 못하면 red
                    buttons.layer.borderColor = UIColor.red.cgColor
                    return
                }
                // 다크 모드 대응 함수로 처리
                self.updateButtonBorderColor(button: button)
            }
        })
    }
   

    
    // 버튼 테두리 색상 업데이트 함수
    // borderColor는 .label이 적용 안되니까 이렇게 ...
    private func updateButtonBorderColor(button: UIButton) {
        // 지금 뷰컨이 다크모드
        if traitCollection.userInterfaceStyle == .dark {
            button.layer.borderColor = UIColor.white.cgColor
        // 지금 뷰컨이 라이트모드
        } else {
            button.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    private func tappedButtonSwitchColor(button: UIButton) {
        if traitCollection.userInterfaceStyle == .dark {
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
        } else {
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
        }
    }
    
    // MARK: - 정렬 버튼 클릭
    @objc
    func tappedButton(sender: UIButton) {
        print(#function, sender.tag)
        
        print("1")
        if sender.isSelected {
            print("이미 선택했던 버튼입니다.")
            print("2")
            return
        }
        print("3")
        
        // 4개 버튼 모두 색상 초기화
        for buttons in filterButtonStackView.arrangedSubviews {
            print("4")
            guard let button = buttons as? UIButton else {
                buttons.layer.borderColor = UIColor.red.cgColor
                return
            }
            
            // clear 해도 배경색이 다크모드 대응이라 좋음
            button.backgroundColor = .clear
            button.setTitleColor(.label, for: .normal)
            // 전부 false로
            button.isSelected = false
            updateButtonBorderColor(button: button)
            
        }
        
    
        
        sender.isSelected = true
        
        
        // 실제 클릭한 버튼만 다크모드 대응해서 색상 적용
        tappedButtonSwitchColor(button: sender)
        
        // 버튼의 tag 값을 기반으로 SortOption enum으로 변환
        let sortOption = SortOption(rawValue: sender.tag) ?? .sim
        
        switch sortOption {
        case .sim:
            //tappedButtonSwitchColor(button: sender)
            filteredCallRequest(keyword: navigationTitle, sort: .sim)
            print("정확도")
        case .date:
            //tappedButtonSwitchColor(button: sender)
            filteredCallRequest(keyword: navigationTitle, sort: .date)
            print("날짜순")
        case .dsc:
            //tappedButtonSwitchColor(button: sender)
            filteredCallRequest(keyword: navigationTitle, sort: .dsc)
            print("가격 높은순")
        case .asc:
            //tappedButtonSwitchColor(button: sender)
            filteredCallRequest(keyword: navigationTitle, sort: .asc)
            print("가격 낮은순")
        }
    }
    
   
    
    // TODO: - URLComponents 적용
    // MARK: - 키워드 검색을 통한 네이버 쇼핑 API 호출
    private func filteredCallRequest(keyword: String, sort: SortOption) {
        var url = APIKey.shoppingURL
        url += keyword
        url += "&display=100"
        url += "&sort=\(sort)"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            // 기본적으로 MainThread에서 실행됨
            .responseDecodable(of: Shopping.self) { response in
                switch response.result {
                case .success(let value):
                   // print("sucess", value)
                    // 지금실행하는 코드가 main인지
                    print(Thread.isMainThread)
                    
                    self.list = value
                    self.shoppingListCollectionView.reloadData()
   
                case .failure(let error):
                    print("error", error)
            }
        }
    }
}


// MARK: - UICollectionViewDataSource
extension ShoppingListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellConfiguration.shoppingCell.identifier, for: indexPath) as! ShoppingListCollectionViewCell
        
        let item = list.items[indexPath.item]
    
        cell.configure(url: item.image, mallName: item.mallName, title: item.title, price: item.lprice)
        
        
        return cell
    }
    
    
}


// MARK: - UICollectionViewDelegate
extension ShoppingListViewController: UICollectionViewDelegate {
    // Pagenation
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
}
