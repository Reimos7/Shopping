//
//  HomeViewModel.swift
//  Shopping
//
//  Created by Reimos on 8/12/25.
//

import Foundation

final class HomeViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        // VC에서 받아옴
        var text: Observable<String> = Observable("")
    }
    
    struct Output {
        // alert를 보내줄거
        var errorAlert: Observable<String> = Observable("")
        
        // 쇼핑 리스트 보내줄거 - 네트워크 통신 성공한 경우 보내줌
        var shoppingList: Observable<Shopping?> = Observable(nil)
    }
    
    init() {
        
        input = Input()
        output = Output()
        
        transform()
    }
    
    private func transform() {
        input.text.bind {  _ in
            print("-----------inputText 변경됨----------")
            // 공백 제거
            let trimmedSearchText = self.input.text.value.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // 공백이거나 2글자 미만인 경우 alert 실행
            if trimmedSearchText.isEmpty || trimmedSearchText.count < 2 {
                self.output.errorAlert.value = "공백이거나 2글자 미만입니다.\n2글자 이상 입력 부탁드립니다."
                return
            }
            // 2글자 이상 입력시 화면 전환
            self.callReqeust(keyword: trimmedSearchText)
            
        }
    }
    
    
    // MARK: - 키워드 검색을 통한 네이버 쇼핑 API 호출
    private func callReqeust(keyword: String) {
        NetworkManager.shared.callRequest(api: .sortOption(keyword: keyword, sort: .sim, start: 1), type: Shopping.self) { result in
            switch result {
            case .success(let shoppingList):
                self.output.shoppingList.value = shoppingList
            case .failure(let failure):
                print(failure)
            }
            
            
            
            //        NetworkManager.shared.callRequest(keyword: keyword) { result in
            //            switch result {
            //            case .success(let shoppingList):
            //                // 쇼핑리스트
            //                self.output.shoppingList.value = shoppingList
            //            case .failure(let failure):
            //                print(failure)
            //            }
            //        }
        }
    }
}
