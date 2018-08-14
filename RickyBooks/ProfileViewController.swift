//
//  ProfileViewController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-03.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import KeychainAccess

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutPressed(_:)))
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc private func logoutPressed(_ sender: Any) {
        let keychain = Keychain(service: "com.rickybooks.rickybooks")
        keychain["token"] = nil
        keychain["user_id"] = nil
        keychain["name"] = nil
        
        var viewControllers = self.tabBarController?.viewControllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let messagesVC = storyboard.instantiateViewController(withIdentifier: "Authorize")
        messagesVC.tabBarItem = viewControllers![2].tabBarItem
        viewControllers![2] = messagesVC
        
        let sellVC = storyboard.instantiateViewController(withIdentifier: "Authorize")
        sellVC.tabBarItem = viewControllers![3].tabBarItem
        viewControllers![3] = sellVC
        
        let profileVC = storyboard.instantiateViewController(withIdentifier: "Authorize")
        profileVC.tabBarItem = viewControllers![4].tabBarItem
        viewControllers![4] = profileVC
        
        self.tabBarController?.setViewControllers(viewControllers, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
