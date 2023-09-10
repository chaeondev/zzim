//
//  FavoriteProductRepository.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/10.
//

import Foundation
import RealmSwift

protocol FavoriteProductRepositoryType: AnyObject {
    func createItem(_ item: FavoriteProductTable)
    func fetch() -> Results<FavoriteProductTable>
    func updateItem(_ item: FavoriteProductTable)
    func deleteItem(_ item: FavoriteProductTable)
}

class FavoriteProductRepository: FavoriteProductRepositoryType {
        
    private let realm = try! Realm()
    

    func createItem(_ item: FavoriteProductTable) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error) // mark: error 체크하기
        }
    }
    
    func fetch() -> RealmSwift.Results<FavoriteProductTable> {
        let data = realm.objects(FavoriteProductTable.self).sorted(byKeyPath: "savedDate", ascending: false)
        return data
    }
    
    func updateItem(_ item: FavoriteProductTable) {
        do {
            try realm.write {
                realm.create(FavoriteProductTable.self, value: ["id": item.id, "like": item.like] as [String : Any], update: .modified)
            }
        } catch {
            print("") // MARK: NSLog, error 구현하기
        }
    }
    
    func deleteItem(_ item: FavoriteProductTable) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
   
}

// MARK: 이미지 저장 파일에? 아니면 매번 API 통신할지 고민해보기
