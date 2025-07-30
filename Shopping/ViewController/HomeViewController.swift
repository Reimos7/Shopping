//
//  HomeViewController.swift
//  Shopping
//
//  Created by Reimos on 7/25/25.
//

import UIKit
import SnapKit
import Alamofire

final class HomeViewController: BaseViewController {
    // HomeView 가져오기
    let homeView = HomeView()
  
    var list: Shopping = Shopping(total: 0, display: 0, start: 0, items: [])
    
    // 밑 바탕의 뷰를 교체함
    // rootview를 만드는 역할
    // loadView는 super를 호출하지 않는다.
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "영캠러의 쇼핑쇼핑"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        //print(NetworkError.badRequest.networkErrorTitle)
        //let testError = NetworkError.conflict
        //showErrorAlert(error: testError)
        //homeView.setupSearchBar()
        
        //let id = Bundle.main.infoDictionary?[X-Naver-Client-Id: X-Naver-Client-Secret]
//        let id = Bundle.main.object(forInfoDictionaryKey: "X-Naver-Client-Id") as? String
//        let pwd = Bundle.main.object(forInfoDictionaryKey: <#T##String#>)
//        print(id)
        homeView.searchBar.delegate = self
    }
    
    // MARK: - 키워드 검색을 통한 네이버 쇼핑 API 호출
    private func callRequest(keyword: String) {
        NetworkManager.shared.callRequest(keyword: keyword) { [weak self] result in
            // ui는 메인쓰레드에서 ㄱ
            DispatchQueue.main.async {
                // <Shopping, Error>
                switch result {
                case .success(let value):
                    let shoppingListVC = ShoppingListViewController()
                    print(#function, "네트워킹 검색")
                    shoppingListVC.navigationTitle = keyword
                    shoppingListVC.list = value
                    // 서치바 검색창 비워주기 -> push 후 다시 돌아오면 사용자가 검색어를 바로 입력할 수 있게 해줌
                    //self.homeView.searchBar.text = ""
                    // VC Extension - push 적용
                    self?.transitionVC(shoppingListVC, style: .push)
                    //self.transitionVC(shoppingListVC, style: .present)
                    //self.navigationController?.pushViewController(shoppingListVC, animated: true)
                    
                case .failure(let error):
                    print(error)
                    
                    if let networkError = error as? NetworkError {
                        self?.showErrorAlert(error: networkError)
                        print(error.localizedDescription)
                    } else {
                        self?.showAlert(title: "에러", message: "에러입니다", preferredStyle: .alert)
                        print(error.localizedDescription)
                    }
                }
            }
        }

    }
   
    
    override func configureView() {
        //배경을 다크모드 라이트모드 대응
        view.backgroundColor = .systemBackground
        // 네비게이션바 색상 다크모드 대응
        navigationController?.navigationBar.tintColor = .label
        // 네비게이션 백버튼 지우기 < 만 보이게
        navigationItem.backButtonTitle = ""
        
        setDarkModeSwitch()
    }
    
    // MARK: - ios17+ 다크모드 변경 감지traitCollectionDidChange 대신 사용
    private func setDarkModeSwitch() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            if self.traitCollection.userInterfaceStyle == .light {
                // 라이트 모드
                print("----------라이트모드----------")
                //self.homeImage.image = UIImage(named: "shoppingPerson")
                self.homeView.homeImage.image = UIImage(named: "shoppingPerson")
            } else {
                // 다크 모드
                print("----------다크모드----------")
                self.homeView.homeImage.image = UIImage(named: "shoppingPerson")
            }
        })
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        
        guard let searchText = searchBar.text else {return}
        
        // 공백 제거
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 공백이거나 2글자 미만인 경우 alert 실행
        if trimmedSearchText.isEmpty || trimmedSearchText.count < 2 {
            showAlert(title: "검색 오류", message: "공백이거나 2글자 미만입니다.\n2글자 이상 입력 부탁드립니다.", preferredStyle: .alert)
            return
        }
        // 2글자 이상 입력시 화면 전환
        callRequest(keyword: trimmedSearchText)
        
       // if searchText.count >= 2 {
           // callRequest(keyword: searchText)
//            let shoppingList = ShoppingListViewController()
//            shoppingList.navigationTitle = searchText
//            shoppingList.list = list
//            
//            navigationController?.pushViewController(shoppingList, animated: true)
//            
           
       // }
        
    }
    
}
