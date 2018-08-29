//
//  ProfileViewController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-03.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import KeychainAccess

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var userTextbooks = [Textbook]()
    
    @IBOutlet weak var userTextbooksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTextbooksTableView.delegate = self
        userTextbooksTableView.dataSource = self
        userTextbooksTableView.layer.borderColor = UIColor.black.cgColor
        userTextbooksTableView.layer.borderWidth = 1.0
        userTextbooksTableView.register(UINib(nibName: "TextbookCellNib", bundle: nil), forCellReuseIdentifier: "TextbookCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getTextbooksReq(_:)), for: .valueChanged)
        userTextbooksTableView.refreshControl = refreshControl
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutPressed(_:)))
        self.navigationItem.rightBarButtonItem = logoutButton
        
        getTextbooksReq((Any).self)
    }
    
    @objc private func getTextbooksReq(_ sender: Any) {
        let getUserTextbooks = GetUserTextbooks()
        getUserTextbooks.req(withCompletion: {
            self.userTextbooks = getUserTextbooks.getData()
            DispatchQueue.main.sync {
                self.userTextbooksTableView.reloadData()
                self.userTextbooksTableView.refreshControl?.endRefreshing()
            }
        })
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
    
    // Mark: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTextbooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTextbooksTableView.dequeueReusableCell(withIdentifier: "TextbookCell", for: indexPath) as! TextbookCell
        let textbook = userTextbooks[indexPath.row]
        cell.textbookTitleLabel?.text = textbook.textbook_title
        cell.textbookAuthorLabel?.text = textbook.textbook_author
        cell.textbookEditionLabel?.text = textbook.textbook_edition
        cell.textbookConditionLabel?.text = textbook.textbook_condition
        cell.textbookTypeLabel?.text = textbook.textbook_type
        cell.textbookCoursecodeLabel?.text = textbook.textbook_coursecode
        cell.textbookPriceLabel?.text = "$ " + textbook.textbook_price
        cell.textbookTimestampLabel?.text = textbook.created_at
        cell.textbookSellerLabel?.text = textbook.user.name
        if textbook.images.count > 0 {
            let url = URL(string: textbook.images[0].url)
            cell.textbookImageView?.kf.setImage(with: url)
        }
        else {
            cell.textbookImageView?.kf.base.image = UIImage(named: "TextbookPlaceholder")
        }
        return cell
    }
}
