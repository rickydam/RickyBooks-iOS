//
//  EditTextbook.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-30.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import KeychainAccess

func editTextbook(textbookId: String, titleInput: String, authorInput: String, editionInput: String, conditionInput: String, typeInput: String, coursecodeInput: String, priceInput: String, withCompletion completion: @escaping ((_ isSuccessful: Bool) -> Void)) {
    let endpoint = getBaseUrl() + "/textbooks/" + textbookId
    var request = URLRequest(url: URL(string: endpoint)!)
    request.httpMethod = "PUT"
    let keychain = Keychain(service: "com.rickybooks.rickybooks")
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("Token token=" + keychain["token"]!, forHTTPHeaderField: "Authorization")
    let textbookDictionary: [String: Any] = [
        "textbook_title": titleInput,
        "textbook_author": authorInput,
        "textbook_edition": editionInput,
        "textbook_condition": conditionInput,
        "textbook_type": typeInput,
        "textbook_coursecode": coursecodeInput,
        "textbook_price": priceInput
    ]
    guard let textbookObj = try? JSONSerialization.data(withJSONObject: textbookDictionary, options: []) else {
        print("Error with the textbookObj JSONSerialization")
        return
    }
    request.httpBody = textbookObj
    
    let requestTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        if(statusCode == 204) {
            completion(true)
        }
        else {
            print("Error with EditTextbook.")
            completion(false)
        }
    }
    requestTask.resume()
}
