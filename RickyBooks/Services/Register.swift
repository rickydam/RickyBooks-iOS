//
//  Register.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-27.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

func register(tabBarController: UITabBarController, nameInput: String, emailInput: String, passwordInput: String, confirmPasswordInput: String) {
    let endpoint = "https://rickybooks.herokuapp.com/users"
    var request = URLRequest(url: URL(string: endpoint)!)
    request.httpMethod = "POST"
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    let registerDictionary: [String: Any] = [
        "user": [
            "name": nameInput,
            "email": emailInput,
            "password": passwordInput,
            "password_confirmation": confirmPasswordInput
        ]
    ]
    guard let userObj = try? JSONSerialization.data(withJSONObject: registerDictionary, options: []) else {
        print("Error with userObj JSONSerialization")
        return
    }
    request.httpBody = userObj
    
    let requestTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
        guard let data = data else {
            print("Error with the data received")
            return
        }
        do {
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if(statusCode == 200) {
                let userData = try JSONDecoder().decode(UserData.self, from: data)
                DispatchQueue.main.sync {
                    successfulAuthorization(tabBarController: tabBarController, userData: userData)
                }
            }
            else if(statusCode == 422) {
                let errors = try JSONDecoder().decode(RegisterErrors.self, from: data)
                var errorMessage = ""
                
                let nameError = errors.name
                if(nameError != nil) {
                    if(nameError![0] == "can't be blank") {
                        if(errorMessage != "") {
                            errorMessage += "\n"
                        }
                        errorMessage += "Missing: Name"
                    }
                }
                
                let emailError = errors.email
                if(emailError != nil) {
                    for entry in emailError! {
                        if(entry == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Email"
                        }
                        if(entry == "is invalid") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Invalid: Email"
                        }
                        if(entry == "has already been taken") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Taken: Email"
                        }
                    }
                }
                
                let passwordError = errors.password
                if(passwordError != nil) {
                    if(passwordError![0] == "can't be blank") {
                        if(errorMessage != "") {
                            errorMessage += "\n"
                        }
                        errorMessage += "Missing: Password"
                    }
                }
                
                let passwordConfirmationError = errors.password_confirmation
                if(passwordConfirmationError != nil) {
                    if(passwordConfirmationError![0] == "doesn't match Password") {
                        if(errorMessage != "") {
                            errorMessage += "\n"
                        }
                        errorMessage += "Mismatch: Password"
                    }
                }
                
                createAlert(title: "Uh oh... we got problems!", message: errorMessage)
            }
            else {
                print("Error with the response")
            }
        } catch let jsonError {
            print("Error with JSONDecoder", jsonError)
        }
    }
    requestTask.resume()
}
