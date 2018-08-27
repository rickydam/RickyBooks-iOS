//
//  GetTextbooks.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-27.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

struct Textbook: Decodable {
    var id: Int
    var textbook_title: String
    var textbook_author: String
    var textbook_edition: String
    var textbook_condition: String
    var textbook_type: String
    var textbook_coursecode: String
    var textbook_price: String
    var created_at: String
    var user_id: Int
    var user: User
    var images: [Image]
}

struct User: Decodable {
    var name: String
}

struct Image: Decodable {
    var url: String
}

class GetTextbooks {
    private var textbooks = [Textbook]()
    
    func req(withCompletion completion: @escaping (() -> Void)) {
        let urlString = "https://rickybooks.herokuapp.com/textbooks"
        guard let url = URL(string: urlString) else {
            print("Error creating the URL")
            return
        }
        let requestTask = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                print("Error with the data received")
                return
            }
            do {
                self.textbooks = try JSONDecoder().decode([Textbook].self, from: data)
                completion()
            } catch let jsonError {
                print("Error with JSONDecoder", jsonError)
            }
        }
        requestTask.resume()
    }
    
    func getData() -> [Textbook] {
        return textbooks
    }
}
