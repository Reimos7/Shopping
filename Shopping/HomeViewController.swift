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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "영캠러의 쇼핑쇼핑"
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
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        searchBar.delegate = self
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
