//
//  AuthViewController.swift
//  Shopping
//
//  Created by Reimos on 7/31/25.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {
    
    lazy var textfield = {
        let textField = UITextField()
        textField.placeholder = "안녕 -> 입력시 UserDefaults로 분기처리 이동됨"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var saveButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(tappedSaveButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textfield)
        view.addSubview(saveButton)
        
        textfield.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(textfield.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.height.equalTo(30)
            
        }
       
    }
    
    @objc
    func tappedSaveButton() {
        print(#function)
        if textfield.text == "안녕" {
            UserDefaults.standard.set(true, forKey: "AuthKey")
            transitionVC(HomeViewController(), style: .push)
        }
        
    
    }
    

   

}
