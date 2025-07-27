//
//  HomeViewController.swift
//  Shopping
//
//  Created by Reimos on 7/25/25.
//

import UIKit
import SnapKit
import Alamofire

final class HomeViewController: UIViewController {
  
    let searchBar = UISearchBar()
    
    var list: Shopping = Shopping(total: 0, items: [])
    
    let homeImage = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(resource: .shoppingPerson)
        return image
    }()
    
    let homeImageLabel = {
        let label = UILabel()
        label.text = "쇼핑하구팡"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "영캠러의 쇼핑쇼핑"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        configureHierarchy()
        configureLayout()
        configureView()
        setupSearchBar()
        
        //let id = Bundle.main.infoDictionary?[X-Naver-Client-Id: X-Naver-Client-Secret]
//        let id = Bundle.main.object(forInfoDictionaryKey: "X-Naver-Client-Id") as? String
//        let pwd = Bundle.main.object(forInfoDictionaryKey: <#T##String#>)
//        print(id)
        
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그등 "
    }
    
    
    // MARK: - 키워드 검색을 통한 네이버 쇼핑 API 호출
    func callRequest(keyword: String) {
        var url = APIKey.shoppingURL
        url += keyword
        url += "&display=100"
        
        
        
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
                    print("sucess", value)
                    // 지금실행하는 코드가 main인지
                    print(Thread.isMainThread)
                    // ui는 main
                    // DispatchQueue.main 없어도 됨
                    DispatchQueue.main.async {
                        let shoppingListVC = ShoppingListViewController()
                        shoppingListVC.navigationTitle = keyword
                        shoppingListVC.list = value
                        self.navigationController?.pushViewController(shoppingListVC, animated: true)
                    }

                    
                case .failure(let error):
                    print("error", error)
                }
                        
            }
        
        
    }


}

extension HomeViewController: ViewDesignProtocol {
    func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(homeImage)
        view.addSubview(homeImageLabel)
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        homeImage.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(100)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(homeImage.snp.width)
        }
        
        homeImageLabel.snp.makeConstraints { make in
            make.top.equalTo(homeImage.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(30)
        }
        
        
    }
    
    func configureView() {
        //배경을 다크모드 라이트모드 대응
        view.backgroundColor = .systemBackground
        // 네비게이션바 색상 다크모드 대응
        navigationController?.navigationBar.tintColor = .label
        // 네비게이션 백버튼 지우기 < 만 보이게
        navigationItem.backButtonTitle = ""
        
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .label
        searchBar.delegate = self
        
        setDarkModeSwitch()
    }
    
    // MARK: - ios17+ 다크모드 변경 감지traitCollectionDidChange 대신 사용
    private func setDarkModeSwitch() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            if self.traitCollection.userInterfaceStyle == .light {
                // 라이트 모드
                print("----------라이트모드----------")
                self.homeImage.image = UIImage(named: "shoppingPerson")
            } else {
                // 다크 모드
                print("----------다크모드----------")
                self.homeImage.image = UIImage(named: "shoppingPerson")
            }
            
            
        })
        
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        
        guard let searchText = searchBar.text,
              !searchText.isEmpty else { return }
        
        // 2글자 이상 입력시 화면 전환
        if searchText.count >= 2 {
            callRequest(keyword: searchText)
//            let shoppingList = ShoppingListViewController()
//            shoppingList.navigationTitle = searchText
//            shoppingList.list = list
//            
//            navigationController?.pushViewController(shoppingList, animated: true)
//            
           
        }
        
    }
    
}
