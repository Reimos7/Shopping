//
//  BaseView.swift
//  Shopping
//
//  Created by Reimos on 7/28/25.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    // 원래 버전 대응할때 사용하지만, 앞으로 사용 안할거다 라는건 이렇게 명세하기도 함
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        
    }
}
