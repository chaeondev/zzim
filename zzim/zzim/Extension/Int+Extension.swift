//
//  Int+Extension.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/10.
//

import Foundation

extension Int {
    func addCommaToNumberString() -> String?  {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if let numberToString = numberFormatter.string(from: NSNumber(value: self)) {
            return numberToString
        } else {
            return nil
        }
    }
}
