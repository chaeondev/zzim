//
//  RealmModel.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/10.
//

import Foundation
import RealmSwift

class FavoriteProductTable: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var mallName: String
    @Persisted var image: String
    @Persisted var price: String
    @Persisted var like: Bool
    @Persisted var savedDate: Date
    
    convenience init(id: String, title: String, mallName: String, price: String, like: Bool) {
        self.init()
        
        self.id = id
        self.title = title
        self.mallName = mallName
        self.image = image
        self.price = price
        self.like = false
        self.savedDate = savedDate
    }
}
