//
//  UserDefaultsManager.swift
//  zzim
//
//  Created by Chaewon on 2/24/24.
//

import Foundation

enum UserDefaultsManager {
    
    enum Key: String {
        case searchHistory
    }
    
    static var searchHistory: [String] {
        get {
            UserDefaults.standard.object(forKey: Key.searchHistory.rawValue) as? [String] ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Key.searchHistory.rawValue)
        }
    }
}
