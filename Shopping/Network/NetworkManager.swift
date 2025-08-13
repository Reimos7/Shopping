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
    private init() {}
    
    func callRequest<T: Decodable>(api: SearchRouter, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString),
                   headers: api.headers
        )
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
          
        }
    }
    
//    // 성공 -> Shopping , 실패 -> Error
//    func callRequest(keyword: String, completion: @escaping (Result<Shopping, Error>) -> Void) {
//        var components = URLComponents()
//        
//        components.scheme = "https"
//        components.host = "openapi.naver.com"
//        components.path = "/v1/search/shop.json"
//        
//        components.queryItems = [
//            URLQueryItem(name: "query", value: keyword),
//            URLQueryItem(name: "display", value: "30")
//        ]
//        
//        guard let url = components.url else {
//            print("url 에러")
//            return
//        }
//        
//        let header: HTTPHeaders = [
//            "X-Naver-Client-Id": APIKey.clientID,
//            "X-Naver-Client-Secret": APIKey.clientSecret
//        ]
//        
//        AF.request(url, method: .get, headers: header)
//            .validate(statusCode: 200..<300)
//            .responseDecodable(of: Shopping.self) { response in
//                switch response.result {
//                case .success(let value):
//                    completion(.success(value))
//                  
//                case .failure(let error):
//                    let statusCode = response.response?.statusCode ?? 0
//                    // NetWorkError Enum
//                    let networkError = NetworkError(rawValue: statusCode) ?? .unknown
//                    
//                    completion(.failure(networkError))
//            }
//        }
//    }
    
//    func searchShopping(keyword: String, competionHandler: @escaping (Shopping, Error) -> Void) {
//        NetworkManager.shared.callRequest(keyword: keyword) { [weak self] result in
//            // ui는 메인쓰레드에서 ㄱ
//            DispatchQueue.main.async {
//                // <Shopping, Error>
//                switch result {
//                case .success(let value):
//                    let shoppingListVC = ShoppingListViewController()
//                    print(#function, "네트워킹 검색")
//                    shoppingListVC.navigationTitle = keyword
//                    shoppingListVC.list = value
//                    
//                    
//                    
//                    // 서치바 검색창 비워주기 -> push 후 다시 돌아오면 사용자가 검색어를 바로 입력할 수 있게 해줌
//                    //self.homeView.searchBar.text = ""
//                    // VC Extension - push 적용
//                    //self?.transitionVC(shoppingListVC, style: .push)
//                    //self.transitionVC(shoppingListVC, style: .present)
//                    //self.navigationController?.pushViewController(shoppingListVC, animated: true)
//                    
//                case .failure(let error):
//                    print(error)
//                    
//                    if let networkError = error as? NetworkError {
//                       // self?.showErrorAlert(error: networkError)
//                        print(error.localizedDescription)
//                    } else {
//                        //self?.showAlert(title: "에러", message: "에러입니다", preferredStyle: .alert)
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//
//    }
    
//    // MARK: - 키워드 검색을 통한 네이버 쇼핑 API 호출
//    func filteredCallRequest(keyword: String, sort: SortOption, start: Int ,completion: @escaping (Result<Shopping, Error>) -> Void) {
//        print(#function, "API 호출~~~~~~~~~~~~~~~")
//       
//        
//        var components = URLComponents()
//        
//        components.scheme = "https"
//        components.host = "openapi.naver.com"
//        components.path = "/v1/search/shop.json"
//        
//        components.queryItems = [
//            URLQueryItem(name: "query", value: keyword),
//            URLQueryItem(name: "display", value: "30"),
//            URLQueryItem(name: "sort", value: "\(sort)"),
//            URLQueryItem(name: "start", value: "\(start)")
//        ]
//        
//        guard let url = components.url else {
//            print("url 에러")
//            return
//        }
// 
//        print(url)
//        
//        let header: HTTPHeaders = [
//            "X-Naver-Client-Id": APIKey.clientID,
//            "X-Naver-Client-Secret": APIKey.clientSecret
//        ]
//        
//        AF.request(url, method: .get, headers: header)
//            .validate(statusCode: 200..<300)
//        // 기본적으로 MainThread에서 실행됨
//            .responseDecodable(of: Shopping.self) { response in
//                
//                switch response.result {
//                case .success(let value):
//                    completion(.success(value))
//                    
//                case .failure(let error):
//                    let statusCode = response.response?.statusCode ?? 0
//                    // NetWorkError Enum
//                    let networkError = NetworkError(rawValue: statusCode) ?? .unknown
//                    
//                    completion(.failure(networkError))
//                
//            }
//        }
//    }
}
