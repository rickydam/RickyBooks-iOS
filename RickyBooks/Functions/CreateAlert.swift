//
//  CreateAlert.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-27.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

func createAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
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
        appDelegate.window?.rootViewController?.present(alert, animated: false, completion: nil)
    }
}
