//
//  Login.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-27.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

func login(tabBarController: UITabBarController, emailInput: String, passwordInput: String) {
    let endpoint = getBaseUrl() + "/login"
    var request = URLRequest(url: URL(string: endpoint)!)
    request.httpMethod = "POST"
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    let loginDictionary: [String: Any] = [
        "email": emailInput,
        "password": passwordInput
    ]
    guard let userObj = try? JSONSerialization.data(withJSONObject: loginDictionary, options: []) else {
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
            else if(statusCode == 401) {
                createAlert(title: "Typo! Try again!", message: "Invalid email/password combination")
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
