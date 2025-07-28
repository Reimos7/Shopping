//
//  NetworkManager.swift
//  Shopping
//
//  Created by Reimos on 7/29/25.
//

// 네트워크 로직을 싱글패턴을 활용해 NetworkManager 로 분리해보기
import Foundation
import Alamofire

class NetworkManager {
    // 싱글톤으로
    static let shared = NetworkManager()
    
    // 외부에서 만들지 못하게 하기
    private init() {
        print("")
    }
    
    // 성공 -> Shopping , 실패 -> Error
    func callRequest(keyword: String, completion: @escaping (Result<Shopping, Error>) -> Void) {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "openapi.naver.com"
        components.path = "/v1/search/shop.json"
        
        components.queryItems = [
            URLQueryItem(name: "query", value: keyword),
            URLQueryItem(name: "display", value: "30")
        ]
        
        guard let url = components.url else {
            print("url 에러")
            return
        }
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Shopping.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                  
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

//{
//   
//    
//   
////        var url = APIKey.shoppingURL
////        url += keyword
////        url += "&display=30"
//    
//    
//    
//    AF.request(url, method: .get, headers: header)
//        .validate(statusCode: 200..<300)
//        // 기본적으로 MainThread에서 실행됨
//        .responseDecodable(of: Shopping.self) { response in
//            switch response.result {
//            case .success(let value):
//                print("sucess", value)
//                // 지금실행하는 코드가 main인지
//                print(Thread.isMainThread)
//                // ui는 main
//                // DispatchQueue.main 없어도 됨
//                DispatchQueue.main.async {
//                    let shoppingListVC = ShoppingListViewController()
//                    shoppingListVC.navigationTitle = keyword
//                    shoppingListVC.list = value
//                    // 서치바 검색창 비워주기 -> push 후 다시 돌아오면 사용자가 검색어를 바로 입력할 수 있게 해줌
//                    self.homeView.searchBar.text = ""
//                    // VC Extension - push 적용
//                    self.transitionVC(shoppingListVC, style: .push)
//                    //self.transitionVC(shoppingListVC, style: .present)
//                    //self.navigationController?.pushViewController(shoppingListVC, animated: true)
//                }
//
//                
//            case .failure(let error):
//                print("error", error)
//                // TODO: - LocalizedError 사용해서 처리하기
//            }
//                    
//        }
//    
//    
//}
