//
//  ShoppingListViewModel.swift
//  Shopping
//
//  Created by Reimos on 8/12/25.
//

import Foundation

final class ShoppingListViewModel {
    // Home에서 입력한 내용을 받아서 네비게이션 타이틀이랑 정렬 버튼 네트워크 호출할때 사용하기
    //var inputTitle: Observable<String> = Observable("")
    
    var input: Input
    var output: Output
    
    struct Input {
        // viewDidLoad 생명주기 트리거
        var viewDidLoadTrigger: Observable<Void> = Observable(())
        // 정렬 버튼 클릭
       // var sortButtonTapped: Observable<Void> = Observable(())
    }
    
    struct Output {
        // 기본 정확도로 설정
        var currentSortButton: Observable<SortOption> = Observable(.sim)
        
        // 쇼핑 리스트 보내줄거 - 네트워크 통신 성공한 경우 보내줌
        var shoppingList: Observable<Shopping> = Observable(Shopping(total: 0, display: 0, start: 0,items: []))
        
        // 쇼핑리스트 horizontal
        var shoppingListHorizontal: Observable<Shopping> = Observable(Shopping(total: 0, display: 0, start: 0, items: []))
        
    }
    
    // 페이지네이션
    var start = 1
    
    init() {
        input = Input()
        output = Output()
        
        input.viewDidLoadTrigger.bind { _ in
            self.callReqeustHorizontal(keyword: "apple", sort: .sim)
        }
        
//        input.sortButtonTapped.bind { _ in
//            self.changeFilterButton(keyword: "" , sort: .sim)
//        }
    }
    
    
    // MARK: - 정렬 버튼 변경될때
    func changeFilterButton(keyword: String, sort: SortOption) {
        output.currentSortButton.value = sort
        // 1부터 다시 ㄱ
        start = 1
        // 호출
        callReqeust(keyword: keyword, sort: sort)
    }
    
    // MARK: - 키워드랑 정렬에 맞게 api 호출
    private func callReqeust(keyword: String, sort: SortOption) {
        NetworkManager.shared.callRequest(api: .sortOption(keyword: keyword, sort: sort, start: 1), type: Shopping.self) { result in
            switch result {
            case .success(let shoppingList):
                self.output.shoppingList.value = shoppingList
            case .failure(let failure):
                print(failure)
            }
            //    private func callRequsetShopping(keyword: String, sort: SortOption) {
            //        NetworkManager.shared.filteredCallRequest(keyword: keyword, sort: sort, start: start) { result in
            //            switch result {
            //            case .success(let shoppingList):
            //                self.shoppingList.value = shoppingList
            //            case .failure(let failure):
            //                print(failure)
            //            }
            //        }
            //    }
        }
    }
    
    private func callReqeustHorizontal(keyword: String, sort: SortOption) {
        NetworkManager.shared.callRequest(api: .sortOption(keyword: keyword, sort: sort, start: 1), type: Shopping.self) { result in
            switch result {
            case .success(let shoppingList):
                self.output.shoppingListHorizontal.value = shoppingList
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}
