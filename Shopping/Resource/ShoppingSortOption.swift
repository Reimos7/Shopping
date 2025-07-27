//
//  ShoppingSortOption.swift
//  Shopping
//
//  Created by Reimos on 7/28/25.
//

import Foundation

// MARK: - 필터 정렬 버튼을 위한 Enum
enum SortOption: Int {
    case sim    // 정확순
    case date   // 날짜순
    case dsc    // 가격 높은순
    case asc    // 가격 낮은순
    
    var sortOption: String {
        switch self {
        case .sim:
            return "sim"
        case .date:
            return "date"
        case .dsc:
            return "dsc"
        case .asc:
            return "asc"
        }
    }
}
