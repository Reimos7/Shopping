//
//  HomeViewController.swift
//  Shopping
//
//  Created by Reimos on 7/25/25.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    /*
     UISearchBar 에 글자를 입력 후 키보드 Return 을 클릭하면 화면 전환이 됩
    니다.
    단, 2글ㅈ화면 전환 시, 입력한 단
    자 이상 입력한 경우에만 화면 전환이 됩니다.
    어를 값 전달을 통해 검색 결과 화면으로 전달해주세요
     */
    
    let searchBar = UISearchBar()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "영캠러의 쇼핑쇼핑"
        configureHierarchy()
        configureLayout()
        configureView()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그등 "
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
            let shoppingList = ShoppingListViewController()
            shoppingList.navigationTitle = searchText
            navigationController?.pushViewController(shoppingList, animated: true)
        }
        
    }
    
}
