//
//  AuthorizeViewController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-07.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

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

    @objc private func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
