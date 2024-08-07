//
//  FavoriteProductRepository.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/10.
//

import Foundation
import RealmSwift

class FavoriteProductRepository {
        
    private let realm = try! Realm()
    
    func checkRealmFileURL() {
        print(realm.configuration.fileURL ?? "Can't find file URL")
    }

    func createItem(_ product: FavoriteProduct) {
        
        
        do {
            try realm.write {
                realm.add(product)
            }
        } catch {
            print(error) // mark: error 체크하기
        }
    }
    
    func fetch() -> RealmSwift.Results<FavoriteProduct> {
        let data = realm.objects(FavoriteProduct.self).sorted(byKeyPath: "savedDate", ascending: false)
        return data
    }
    
    func fetchFilter(text: String) -> Results<FavoriteProduct> {
        let result = realm.objects(FavoriteProduct.self).where {
            $0.title.contains(text)
        }.sorted(byKeyPath: "savedDate", ascending: false)
        return result
    }
    
    func deleteItem(_ product: FavoriteProduct) {
        
        do {
            try realm.write {
                realm.delete(product)
            }
        } catch {
            print(error)
        }
    }
    
    func checkDataIsEmpty(id: String) -> Bool {
        let checkSavedData = fetch().where {
            $0.id == id
        }
        
        return checkSavedData.isEmpty
    }
   
}
