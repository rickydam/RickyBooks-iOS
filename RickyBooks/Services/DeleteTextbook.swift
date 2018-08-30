//
//  DeleteTextbook.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-30.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import KeychainAccess

func deleteTextbook(textbookId: String, withCompletion completion: @escaping ((_ isSuccessful: Bool) -> Void)) {
    let endpoint = getBaseUrl() + "/textbooks/" + textbookId
    var request = URLRequest(url: URL(string: endpoint)!)
    request.httpMethod = "DELETE"
    let keychain = Keychain(service: "com.rickybooks.rickybooks")
    request.setValue("Token token=" + keychain["token"]!, forHTTPHeaderField: "Authorization")
    
    let requestTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
        do {
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if(statusCode == 200) {
                completion(true)
            }
            else {
                print("Error with deleteTextbook")
                completion(false)
            }
        }
    }
    requestTask.resume()
}
