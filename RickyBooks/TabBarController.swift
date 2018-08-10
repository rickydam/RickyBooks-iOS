//
//  TabBarController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-10.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "Home")
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "Home"), tag: 0)
        
        let buyVC = storyboard.instantiateViewController(withIdentifier: "Buy")
        buyVC.tabBarItem = UITabBarItem(title: "Buy", image: UIImage(named: "Buy"), tag: 1)
        
        let messagesVC = storyboard.instantiateViewController(withIdentifier: "Messages")
        messagesVC.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(named: "Messages"), tag: 2)
        
        let sellVC = storyboard.instantiateViewController(withIdentifier: "Sell")
        sellVC.tabBarItem = UITabBarItem(title: "Sell", image: UIImage(named: "Sell"), tag: 3)
        
        let profileVC = storyboard.instantiateViewController(withIdentifier: "Profile")
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "Profile"), tag: 4)
        
        let tabBarList = [homeVC, buyVC, messagesVC, sellVC, profileVC]
        viewControllers = tabBarList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
