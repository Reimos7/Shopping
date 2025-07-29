//
//  Shopping.swift
//  Shopping
//
//  Created by Reimos on 7/26/25.
//

import Foundation

struct Shopping: Decodable {
    var total: Int
    let display: Int
    let start: Int
    var items: [ShoppingData]
}

struct ShoppingData: Decodable {
    let image: String
    let mallName: String
    let title: String
    let lprice: String
    
    var titleForCell: String {
        return title.replacingOccurrences(of: "<b>", with: "")
        .replacingOccurrences(of: "</b>", with: "")
    }
}
