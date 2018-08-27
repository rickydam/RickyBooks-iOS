//
//  SuccessfulAuthorization.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-27.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import KeychainAccess

func successfulAuthorization(tabBarController: UITabBarController, userData: UserData) {
    let keychain = Keychain(service: "com.rickybooks.rickybooks")
    keychain["token"] = userData.token
    keychain["user_id"] = String(userData.user_id)
    keychain["name"] = userData.name
    
    var viewControllers = tabBarController.viewControllers
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
    
    tabBarController.setViewControllers(viewControllers, animated: false)
}
