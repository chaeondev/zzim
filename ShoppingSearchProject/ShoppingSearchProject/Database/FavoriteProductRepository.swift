//
//  FavoriteProductRepository.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/10.
//

import Foundation
import RealmSwift

protocol FavoriteProductRepositoryType: AnyObject {
    func createItem(_ item: Item)
    func fetch() -> Results<FavoriteProduct>
    func deleteItem(_ item: Item)
}

class FavoriteProductRepository: FavoriteProductRepositoryType {
        
    private let realm = try! Realm()
    
    func checkRealmFileURL() {
        print(realm.configuration.fileURL ?? "Can't find file URL")
    }
    

    func createItem(_ item: Item) {
        let product = FavoriteProduct(id: item.productID, title: item.title, mallName: item.mallName, price: item.lprice, like: true, savedDate: Date())
        
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
    
    func deleteItem(_ item: Item) {
        guard let product = (fetch().where {
            $0.id == item.productID
        }.first) else { return }
        
        do {
            try realm.write {
                realm.delete(product)
            }
        } catch {
            print(error)
        }
    }
    
    func checkDataIsEmpty(data: Item) -> Bool {
        let checkSavedData = fetch().where {
            $0.id == data.productID
        }
        
        return checkSavedData.isEmpty
    }
   
}

// MARK: 이미지 저장 파일에? 아니면 매번 API 통신할지 고민해보기
