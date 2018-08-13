//
//  AuthorizeViewController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-07.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import KeychainAccess

struct RegisterErrors: Decodable {
    var name: Array<String>?
    var email: Array<String>?
    var password: Array<String>?
    var password_confirmation: Array<String>?
}

struct UserData: Decodable {
    var token: String
    var user_id: Int
    var name: String
}

class AuthorizeViewController: UIViewController {
    @IBOutlet weak var registerLoginSegment: UISegmentedControl!
    
    @IBOutlet weak var registerNameField: UITextField!
    @IBOutlet weak var registerEmailField: UITextField!
    @IBOutlet weak var registerPasswordField: UITextField!
    @IBOutlet weak var registerConfirmPasswordField: UITextField!
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    @IBOutlet weak var registerSubmitButton: UIButton!
    @IBOutlet weak var loginSubmitButton: UIButton!

    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var loginView: UIView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch registerLoginSegment.selectedSegmentIndex {
        case 0:
            registerView.isHidden = false
            loginView.isHidden = true
        case 1:
            registerView.isHidden = true
            loginView.isHidden = false
        default:
            print("Error with the SegmentedControl.")
        }
    }
    
    @IBAction func registerSubmitPressed(_ sender: Any) {
        let nameInput = registerNameField.text!
        let emailInput = registerEmailField.text!
        let passwordInput = registerPasswordField.text!
        let confirmPasswordInput = registerConfirmPasswordField.text!

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

        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                print("Error with the data received")
                return
            }
            do {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                if(statusCode == 200) {
                    let userData = try JSONDecoder().decode(UserData.self, from: data)
                    DispatchQueue.main.async {
                        self.successfulAuthorization(userData: userData)
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

                    let alert = UIAlertController(title: "Uh oh... we got problems!", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
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
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    print("Error with the response.")
                }
            } catch let jsonError {
                print("Error with JSONDdecoder", jsonError)
            }
        }.resume()
    }
    
    @IBAction func loginSubmitPressed(_ sender: Any) {
        let emailInput = loginEmailField.text!
        let passwordInput = loginPasswordField.text!

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

        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                print("Error with the data received")
                return
            }
            do {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                if(statusCode == 200) {
                    let userData = try JSONDecoder().decode(UserData.self, from: data)
                    DispatchQueue.main.async {
                        self.successfulAuthorization(userData: userData)
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
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    print("Error with the response.")
                }
            } catch let jsonError {
                print("Error with JSONDecoder", jsonError)
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        registerLoginSegment.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], for: .normal)
        
        registerNameField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        registerNameField.layer.borderWidth = 1.0
        registerEmailField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        registerEmailField.layer.borderWidth = 1.0
        registerPasswordField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        registerPasswordField.layer.borderWidth = 1.0
        registerConfirmPasswordField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        registerConfirmPasswordField.layer.borderWidth = 1.0
        
        loginEmailField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        loginEmailField.layer.borderWidth = 1.0
        loginPasswordField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        loginPasswordField.layer.borderWidth = 1.0
        
        registerSubmitButton.layer.cornerRadius = 5
        loginSubmitButton.layer.cornerRadius = 5
    }
    
    func successfulAuthorization(userData: UserData) {
        let keychain = Keychain(service: "com.rickybooks.rickybooks")
        keychain["token"] = userData.token
        keychain["user_id"] = String(userData.user_id)
        keychain["name"] = userData.name
        
        var viewControllers = self.tabBarController?.viewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let messagesVC = storyboard.instantiateViewController(withIdentifier: "Messages")
        messagesVC.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(named: "Messages"), tag: 2)
        viewControllers![2] = messagesVC
        
        let sellVC = storyboard.instantiateViewController(withIdentifier: "Sell")
        sellVC.tabBarItem = UITabBarItem(title: "Sell", image: UIImage(named: "Sell"), tag: 3)
        viewControllers![3] = sellVC
        
        let profileVC = storyboard.instantiateViewController(withIdentifier: "Profile")
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "Profile"), tag: 4)
        viewControllers![4] = profileVC
        
        self.tabBarController?.setViewControllers(viewControllers, animated: false)
    }
    
    @objc private func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
