//
//  HomeView.swift
//  Shopping
//
//  Created by Reimos on 7/28/25.
//

import UIKit

// MARK: - HomeVC 사용
class HomeView: BaseView {
    
    let searchBar = UISearchBar()
    
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
    
    override func configureHierarchy() {
        [searchBar, homeImage, homeImageLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        homeImage.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(100)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(homeImage.snp.width)
        }
        
        homeImageLabel.snp.makeConstraints { make in
            make.top.equalTo(homeImage.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(100)
            make.height.equalTo(30)
        }
        
    }
    
    override func configureView() {
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그등 "
       
        searchBar.backgroundColor = .systemBackground
        searchBar.tintColor = .label
    }
}
