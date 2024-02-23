//
//  String+Extension.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/11.
//

import Foundation

extension String {
    func deleteTag() -> String {
        let sample = replacingOccurrences(of: "<b>", with: "")
        return sample.replacingOccurrences(of: "</b>", with: "")
    }
}
