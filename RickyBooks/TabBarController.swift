//
//  TabBarController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-10.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import KeychainAccess

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "Home")
        let buyVC = storyboard.instantiateViewController(withIdentifier: "Buy")
        var messagesVC = UIViewController()
        var sellVC = UIViewController()
        var profileVC = UIViewController()
        
        let keychain = Keychain(service: "com.rickybooks.rickybooks")
        if (keychain["token"] == nil) {
            messagesVC = storyboard.instantiateViewController(withIdentifier: "Authorize")
            sellVC = storyboard.instantiateViewController(withIdentifier: "Authorize")
            profileVC = storyboard.instantiateViewController(withIdentifier: "Authorize")
        }
        else {
            messagesVC = storyboard.instantiateViewController(withIdentifier: "Messages")
            sellVC = storyboard.instantiateViewController(withIdentifier: "Sell")
            profileVC = storyboard.instantiateViewController(withIdentifier: "Profile")
        }
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "Home"), tag: 0)
        buyVC.tabBarItem = UITabBarItem(title: "Buy", image: UIImage(named: "Buy"), tag: 1)
        messagesVC.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(named: "Messages"), tag: 2)
        sellVC.tabBarItem = UITabBarItem(title: "Sell", image: UIImage(named: "Sell"), tag: 3)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "Profile"), tag: 4)
        
        let tabBarList = [homeVC, buyVC, messagesVC, sellVC, profileVC]
        viewControllers = tabBarList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
