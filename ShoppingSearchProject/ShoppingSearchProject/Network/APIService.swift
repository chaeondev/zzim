//
//  APIService.swift
//  ShoppingSearchProject
//
//  Created by Chaewon on 2023/09/08.
//

import UIKit
import Alamofire

final class APIService {
    static let shared = APIService()

    private let key = APIKey.naver
    
    private init() { }
    
    func searchProduct(query: String, start: Int, sort: Sort, completion: @escaping (Shopping) -> Void, errorHandler: @escaping (AFError) -> Void ) {
    
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "https://openapi.naver.com/v1/search/shop.json?query=\(text)&display=30&start=\(start)&sort=\(sort.rawValue)") else { return }
        print(url)
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "ivZGa3DZkmJrM4pamD81",
            "X-Naver-Client-Secret": key
        ]
    
 
        AF.request(url, headers: header).validate().responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error)
                errorHandler(error)
            }
        }
    }
}

enum Sort: String {
    case sim, date, asc, dsc
}
