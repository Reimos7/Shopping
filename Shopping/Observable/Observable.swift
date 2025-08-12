//
//  Observable.swift
//  Shopping
//
//  Created by Reimos on 8/12/25.
//

import Foundation

class Observable<T> {
    private var action: ((T) -> Void)?
    
    var value: T {
        didSet {
            print("Observable didSet")
            action?(value)
            
        }
    }
    
    init(_ value: T) {
        self.value = value
        print("Observable Init")
    }
    
    
    // 전달 받은 매개변수가 실행도 되고 didSet에도 넣어줌
    // 즉, 최초 실행되는 구조
    func bind(action: @escaping (T) -> Void) {
        print("Observable bind")
        action(value)
        self.action = action
    }
    
    // 전달 받은 매개변수가 즉시 실행 안됨
    // 매개변수를 즉시 실행하지 않고 담아만 두는 구조이다
    func lazyBind(action: @escaping (T) -> Void) {
        print("Observable bind")
        self.action = action
    }
}
