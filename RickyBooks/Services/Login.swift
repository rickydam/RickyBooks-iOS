//
//  Login.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-27.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

func login(tabBarController: UITabBarController, emailInput: String, passwordInput: String) {
    let endpoint = "https://rickybooks.herokuapp.com/login"
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
                let alert = UIAlertController(title: "Typo! Try again!", message: "Invalid email/password combination", preferredStyle: UIAlertControllerStyle.alert)
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
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
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
