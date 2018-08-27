//
//  GetTextbooks.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-27.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

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
