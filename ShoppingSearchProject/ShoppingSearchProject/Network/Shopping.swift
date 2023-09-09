//
//  Shopping.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/08.
//

import Foundation

// MARK: - Shopping
struct Shopping: Codable {
    var lastBuildDate: String
    var total, start, display: Int
    var items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let lprice, hprice, mallName, productID: String
    let productType, brand, maker: String

    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, hprice, mallName
        case productID = "productId"
        case productType, brand, maker
    }
}

