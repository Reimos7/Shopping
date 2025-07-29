//
//  ShoppingListViewController.swift
//  Shopping
//
//  Created by Reimos on 7/25/25.
//

import UIKit
import SnapKit
import Alamofire

final class ShoppingListViewController: BaseViewController {
    
    let shoppingListView = ShoppingListView()
    
    var currenSortButton: SortOption = .sim
    
    var list: Shopping = Shopping(total: 0, display: 0, start: 0,items: [])
    // 가로 스크롤
    var horizontalList: Shopping = Shopping(total: 0, display: 0, start: 0,items: [])
    
    var start = 1
    
    var navigationTitle = ""
    
    override func loadView() {
        self.view = shoppingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = navigationTitle
        
        configureCollectionView(sectionInsets: 10, minimumSpacing: 10, cellCount: 2, itemSpacing: 10, lineSpacing: 10, scrollDirectoin: .vertical)
        
        // 수평 스크롤 컬렉션뷰 하나 더 만들어서, 추천 쇼핑 상품 목록 만들어보기
        configureHorizontalCollectionView()
        
        shoppingListView.shoppingListCollectionView.dataSource = self
        shoppingListView.shoppingListCollectionView.delegate = self
        
        shoppingListView.shoppingListHorizontalCollectionView.dataSource = self
        shoppingListView.shoppingListHorizontalCollectionView.delegate = self
        
        callRequestHorizontalCell(keyword: "TensorFlow")
    }
    
    // 가로 스크롤 컬렉션뷰 셀
    private func configureHorizontalCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        let cellWidth: CGFloat = 80
        let cellHeight: CGFloat = 100
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        
        shoppingListView.shoppingListHorizontalCollectionView.collectionViewLayout = layout
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
        
        shoppingListView.shoppingListCollectionView.collectionViewLayout = layout
    }
    
    override func configureView() {
        shoppingListView.shoppingListCollectionView.register(ShoppingListCollectionViewCell.self, forCellWithReuseIdentifier: CellConfiguration.shoppingListCell.identifier)
        shoppingListView.shoppingListHorizontalCollectionView.register(shoppingListHorizontalCollectionViewCell.self, forCellWithReuseIdentifier: CellConfiguration.shoppingHorizontalCell.identifier)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let total = list.total
        guard let totalResult = numberFormatter.string(for: total) else {return}
        shoppingListView.resultLabel.text = "\(totalResult) 개의 검색 결과"
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
            
            
            shoppingListView.filterButtonStackView.addArrangedSubview(button)
            
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
            for buttons in self.shoppingListView.filterButtonStackView.arrangedSubviews {
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
        for buttons in shoppingListView.filterButtonStackView.arrangedSubviews {
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
        
        // 다른 검색어로 바꾸면 리셋이 아니라 계속 append 있음 ... 새로운 정렬버튼이 클릭 되면 지우기
        // 그리고 start도 다시 1부터로 변경하기
        list.items.removeAll()
        start = 1
        
        
        // 실제 클릭한 버튼만 다크모드 대응해서 색상 적용
        tappedButtonSwitchColor(button: sender)
        
        // 버튼의 tag 값을 기반으로 SortOption enum으로 변환
        let sortOption = SortOption(rawValue: sender.tag) ?? .sim
        
        switch sortOption {
        case .sim:
            //tappedButtonSwitchColor(button: sender)
            filteredCallRequest(keyword: navigationTitle, sort: .sim)
            //print(sortOption)
            currenSortButton = sortOption
            print("정확도")
        case .date:
            //tappedButtonSwitchColor(button: sender)
            filteredCallRequest(keyword: navigationTitle, sort: .date)
            currenSortButton = sortOption
            print("날짜순")
        case .dsc:
            //tappedButtonSwitchColor(button: sender)
            filteredCallRequest(keyword: navigationTitle, sort: .dsc)
            currenSortButton = sortOption
            print("가격 높은순")
        case .asc:
            //tappedButtonSwitchColor(button: sender)
            filteredCallRequest(keyword: navigationTitle, sort: .asc)
            currenSortButton = sortOption
            print("가격 낮은순")
        }
    }
    
    
    
    // TODO: - URLComponents 적용
    // MARK: - 키워드 검색을 통한 네이버 쇼핑 API 호출
    private func filteredCallRequest(keyword: String, sort: SortOption) {
        print(#function, "API 호출~~~~~~~~~~~~~~~")
        // ActivityIndicator 시작
        shoppingListView.activityIndicator.startAnimating()
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "openapi.naver.com"
        components.path = "/v1/search/shop.json"
        
        components.queryItems = [
            URLQueryItem(name: "query", value: keyword),
            URLQueryItem(name: "display", value: "30"),
            URLQueryItem(name: "sort", value: "\(sort)"),
            URLQueryItem(name: "start", value: "\(start)")
        ]
        
        guard let url = components.url else {
            print("url 에러")
            return
        }
        
        //        var url = APIKey.shoppingURL
        //        url += keyword
        //        url += "&display=30"
        //        url += "&sort=\(sort)"
        //        url += "&start=\(start)"
        
        print(url)
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
        // 기본적으로 MainThread에서 실행됨
            .responseDecodable(of: Shopping.self) { response in
                
                // ActivityIndicator 멈추기
                self.shoppingListView.activityIndicator.stopAnimating ()
                
                switch response.result {
                case .success(let value):
                    // print("sucess", value)
                    // 지금실행하는 코드가 main인지
                    print(Thread.isMainThread)
                    
                    self.list.items.append(contentsOf: value.items)
                    self.list.total = value.total
                    self.shoppingListView.shoppingListCollectionView.reloadData()
                    
                    
                    // start 가 1이면, 컬렉션뷰 리로드를 한 다음에 스크롤을 최상단으로 올려줌
                    if self.start == 1 {
                        self.shoppingListView.shoppingListCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    }
                    
                case .failure(let error):
                    print("error", error)
                    if let statusCode = response.response?.statusCode,
                       statusCode == 429 {
                        print("-------------------------429-------------------------------")
                        self.showAlert(title: "요청 제한", message: "요청이 너무 많아요\n 잠시 후 다시 시도해주세요.", preferredStyle: .alert)
                    }
                }
            }
    }
    
    private func callRequestHorizontalCell(keyword: String) {
        NetworkManager.shared.callRequest(keyword: keyword) { [weak self] result in
            print(#function)
            // <Shopping, Error>
            switch result {
            case .success(let value):
                
                self?.horizontalList.items.append(contentsOf: value.items)
                self?.horizontalList.total = value.total
                self?.shoppingListView.shoppingListHorizontalCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
                
            }
            
        }
        
    }
}

// MARK: - UICollectionViewDataSource
extension ShoppingListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == shoppingListView.shoppingListCollectionView {
            return list.items.count
        } else if collectionView == shoppingListView.shoppingListHorizontalCollectionView {
            
            return horizontalList.items.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == shoppingListView.shoppingListCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellConfiguration.shoppingListCell.identifier, for: indexPath) as! ShoppingListCollectionViewCell
            
            let item = list.items[indexPath.item]
            
            cell.configure(url: item.image, mallName: item.mallName, title: item.title, price: item.lprice)
            return cell
            
        } else if collectionView == shoppingListView.shoppingListHorizontalCollectionView {
            // 가로 스크롤
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellConfiguration.shoppingHorizontalCell.identifier, for: indexPath) as! shoppingListHorizontalCollectionViewCell
            
            let item = horizontalList.items[indexPath.item]
            cell.configure(url: item.image, name: item.title)
            
            return cell
        }
        
        return UICollectionViewCell()
        
        
        
        
    }
    
    
}


// MARK: - UICollectionViewDelegate
extension ShoppingListViewController: UICollectionViewDelegate {
    // Pagenation
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 메인 컬렉션뷰
        if collectionView == shoppingListView.shoppingListCollectionView {
            //
            if indexPath.item == (list.items.count - 5) && list.items.count < list.total {
                print(#function, indexPath.item)
                //start += 30
                filteredCallRequest(keyword: navigationTitle, sort: currenSortButton)
            } else if list.items.count >= list.total {
                print("====================마지막페이지=============================")
            }
        } else if collectionView == shoppingListView.shoppingListHorizontalCollectionView {
            print("shoppingListHorizontalCollectionView 페이지네이션")
            if indexPath.item == (horizontalList.items.count - 3) && horizontalList.items.count < horizontalList.total{
                print("shoppingListHorizontalCollectionView 페이지네이션 실행")
                callRequestHorizontalCell(keyword: "TensorFlow")
            } else if list.items.count >= list.total {
                print("========================블루베리 마지막페이지=============================")
            }
        }
    }
}
