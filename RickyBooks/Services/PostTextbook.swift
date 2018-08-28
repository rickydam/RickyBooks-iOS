//
//  PostTextbook.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-28.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import KeychainAccess

class PostTextbook {
    private var textbookId = String()
    
    func req(sellViewController: SellViewController, titleInput: String, authorInput: String, editionInput: String, conditionInput: String, typeInput: String, coursecodeInput: String, priceInput: String, withCompletion completion: @escaping (() -> Void)) {
        let endpoint = "https://rickybooks.herokuapp.com/textbooks"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let keychain = Keychain(service: "com.rickybooks.rickybooks")
        request.setValue("Token token=" + keychain["token"]!, forHTTPHeaderField: "Authorization")
        let textbookDictionary: [String: Any] = [
            "user_id": keychain["user_id"]!,
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
            guard let data = data else {
                print("Error with the data received")
                return
            }
            do {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                if(statusCode == 200) {
                    var hasImage = Bool()
                    DispatchQueue.main.sync {
                        createAlert(title: "Success!", message: "Your textbook has been successfully posted!")
                        sellViewController.clearAll(sellViewController)
                        if(sellViewController.chosenImage.image != nil) {
                            hasImage = true
                        }
                    }
                    if(hasImage) {
                        self.textbookId = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
                        completion()
                    }
                }
                else if(statusCode == 422) {
                    let errors = try JSONDecoder().decode(PostTextbookErrors.self, from: data)
                    var errorMessage = ""
                    
                    let titleError = errors.data.textbook_title
                    if(titleError != nil) {
                        if(titleError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Title"
                        }
                    }
                    
                    let authorError = errors.data.textbook_author
                    if(authorError != nil) {
                        if(authorError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Author"
                        }
                    }
                    
                    let editionError = errors.data.textbook_edition
                    if(editionError != nil) {
                        if(editionError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Edition"
                        }
                    }
                    
                    let conditionError = errors.data.textbook_condition
                    if(conditionError != nil) {
                        if(conditionError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Condition"
                        }
                    }
                    
                    let typeError = errors.data.textbook_type
                    if(typeError != nil) {
                        if(typeError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Type"
                        }
                    }
                    
                    let coursecodeError = errors.data.textbook_coursecode
                    if(coursecodeError != nil) {
                        if(coursecodeError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Coursecode"
                        }
                    }
                    
                    let priceError = errors.data.textbook_price
                    if(priceError != nil) {
                        if(priceError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Price"
                        }
                    }
                    
                    let alert = UIAlertController(title: "Hmm.. you forgot something!", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        action in switch action.style {
                        case .default:
                            print("Default")
                        case .cancel:
                            print("Cancel")
                        case .destructive:
                            print("Destructive")
                        }
                    }))
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = NSTextAlignment.left
                    let leftAlignedMessage = NSMutableAttributedString(
                        string: errorMessage,
                        attributes: [
                            NSAttributedStringKey.paragraphStyle: paragraphStyle,
                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)
                        ]
                    )
                    alert.setValue(leftAlignedMessage, forKey: "attributedMessage")
                    
                    DispatchQueue.main.sync {
                        sellViewController.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    print("Error with the response")
                }
            } catch let jsonError {
                print("Error with the JSONDecoder", jsonError)
            }
        }
        requestTask.resume()
    }
    
    func getData() -> String {
        return textbookId
    }
}
