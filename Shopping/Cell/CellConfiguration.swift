//
//  Cell.swift
//  Shopping
//
//  Created by Reimos on 7/25/25.
//

import Foundation

enum CellConfiguration {
    case shoppingCell
    
    var nibName: String {
        switch self {
        case .shoppingCell:
            return "ShoppingListCollectionViewCell"
        }
    }
    
    var identifier: String {
        switch self {
        case .shoppingCell:
            return "ShoppingListCollectionViewCell"
        }
    }
}
