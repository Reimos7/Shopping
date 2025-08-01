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
                    let statusCode = response.response?.statusCode ?? 0
                    // NetWorkError Enum
                    let networkError = NetworkError(rawValue: statusCode) ?? .unknown
                    
                    completion(.failure(networkError))
            }
        }
    }
    
    // MARK: - 키워드 검색을 통한 네이버 쇼핑 API 호출
    func filteredCallRequest(keyword: String, sort: SortOption, start: Int ,completion: @escaping (Result<Shopping, Error>) -> Void) {
        print(#function, "API 호출~~~~~~~~~~~~~~~")
       
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "openapi.naver.com"
        components.path = "/v1/search/shop.json"
        
        components.queryItems = [
            URLQueryItem(name: "query", value: keyword),
            URLQueryItem(name: "display", value: "30"),
            URLQueryItem(name: "sort", value: "\(sort)"),
            URLQueryItem(name: "start", value: "\(start)")
        ]
        
        guard let url = components.url else {
            print("url 에러")
            return
        }
 
        print(url)
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
        // 기본적으로 MainThread에서 실행됨
            .responseDecodable(of: Shopping.self) { response in
                
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                    
                case .failure(let error):
                    let statusCode = response.response?.statusCode ?? 0
                    // NetWorkError Enum
                    let networkError = NetworkError(rawValue: statusCode) ?? .unknown
                    
                    completion(.failure(networkError))
                
            }
        }
    }
}
