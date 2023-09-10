//
//  RealmModel.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/10.
//

import Foundation
import RealmSwift

class FavoriteProductTable: Object {
    @Persisted(primaryKey: true) var ID: String
    @Persisted var title: String
    @Persisted var mallName: String
    @Persisted var price: String
    @Persisted var like: Bool
    
    convenience init(ID: String, title: String, mallName: String, price: String, like: Bool) {
        self.init()
        
        self.ID = ID
        self.title = title
        self.mallName = mallName
        self.price = price
        self.like = false
    }
}
