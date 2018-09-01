//
//  DeleteImageDb.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-31.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

func deleteImageDb(textbookId: String, withCompletion completion: @escaping ((_ isSuccessful: Bool) -> Void)) {
    let endpoint = getBaseUrl() + "/delete_image/" + textbookId
    var request = URLRequest(url: URL(string: endpoint)!)
    request.httpMethod = "DELETE"
    request.setValue("Token token=" + getToken(), forHTTPHeaderField: "Authorization")
    
    let requestTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        if(statusCode == 204) {
            completion(true)
        }
        else {
            print("Error with deleteImageDb")
            completion(false)
        }
    }
    requestTask.resume()
}
