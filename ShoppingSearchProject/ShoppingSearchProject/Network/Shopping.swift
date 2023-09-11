//
//  Shopping.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/08.
//

import Foundation

// MARK: - Shopping
struct Shopping: Codable {
    var total, start, display: Int
    var items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let lprice, mallName, productID: String
   

    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, mallName
        case productID = "productId"
    }
}

