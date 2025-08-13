//
//  SearchRouter.swift
//  Shopping
//
//  Created by Reimos on 8/13/25.
//

import Foundation
import Alamofire

enum SearchRouter {
    case sortOption(keyword: String, sort: SortOption, start: Int)
//    case sim(keyword: String, sort: SortOption, start: Int)
//    case date(keyword: String, sort: SortOption, start: Int)
//    case dsc(keyword: String, sort: SortOption, start: Int)
//    case asc(keyword: String, sort: SortOption, start: Int)
    
    var baseURL: String {
        return "https://openapi.naver.com/v1/search/shop.json"
    }
    
    var endpoint: URL {
        switch self {
//        case .sim(let keyword, let sort, let start):
//            return URL(string: baseURL)!
//        case .date(let keyword, let sort, let start):
//            return URL(string: baseURL)!
//        case .dsc(let keyword, let sort, let start):
//            return URL(string: baseURL)!
//        case .asc(let keyword, let sort, let start):
//            return URL(string: baseURL)!
        case .sortOption(keyword: let keyword, sort: let sort, start: let start):
            return URL(string: baseURL)!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters {
        switch self {
//        case .sim(let keyword, let sort, let start):
//            return["query": keyword,"display": "30", "sort": sort.sortOption, "start": start ]
//        case .date(let keyword, let sort, let start):
//            return["query": keyword,"display": "30", "sort": sort.sortOption, "start": start ]
//        case .dsc(let keyword, let sort, let start):
//            return["query": keyword,"display": "30", "sort": sort.sortOption, "start": start ]
//        case .asc(let keyword, let sort, let start):
//            return["query": keyword,"display": "30", "sort": sort.sortOption, "start": start ]
        case .sortOption(keyword: let keyword, sort: let sort, start: let start):
            return["query": keyword,"display": "30", "sort": sort.sortOption, "start": start ]
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "X-Naver-Client-Id": APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
    }
}
