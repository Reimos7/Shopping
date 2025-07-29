//
//  Cell.swift
//  Shopping
//
//  Created by Reimos on 7/25/25.
//

import Foundation

enum CellConfiguration {
    case shoppingListCell
    case shoppingHorizontalCell
    
    var nibName: String {
        switch self {
        case .shoppingListCell:
            return "ShoppingListCollectionViewCell"
        case .shoppingHorizontalCell:
            return "shoppingListHorizontalCollectionViewCell"
        }
    }
    
    var identifier: String {
        switch self {
        case .shoppingListCell:
            return "ShoppingListCollectionViewCell"
        case .shoppingHorizontalCell:
            return "shoppingListHorizontalCollectionViewCell"
        }
    }
}
