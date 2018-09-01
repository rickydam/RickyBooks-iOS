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
    
    override func viewWillAppear(_ animated: Bool) {
        getUserTextbooksReq((Any).self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTextbooksTableView.delegate = self
        userTextbooksTableView.dataSource = self
        userTextbooksTableView.layer.borderColor = UIColor.black.cgColor
        userTextbooksTableView.layer.borderWidth = 1.0
        userTextbooksTableView.register(UINib(nibName: "TextbookCellNib", bundle: nil), forCellReuseIdentifier: "TextbookCell")
        
        setRefreshControl()
        setSettingsButton()
        setDeleteButton()
        
        getUserTextbooksReq((Any).self)
    }
    
    @objc private func getUserTextbooksReq(_ sender: Any) {
        let getUserTextbooks = GetUserTextbooks()
        getUserTextbooks.req(withCompletion: {
            self.userTextbooks = getUserTextbooks.getData()
            DispatchQueue.main.sync {
                self.userTextbooksTableView.reloadData()
                self.userTextbooksTableView.refreshControl?.endRefreshing()
            }
        })
    }
    
    @objc private func deletePressed(_ sender: Any) {
        if(!self.userTextbooksTableView.isEditing) {
            self.userTextbooksTableView.setEditing(true, animated: true)
            self.userTextbooksTableView.refreshControl = nil
            self.navigationItem.leftBarButtonItem = nil
            setCancelButton()
            self.navigationController?.navigationBar.backgroundColor = UIColor.darkGray
            self.navigationItem.title = "Delete textbooks!"
        }
    }
    
    @objc private func cancelPressed(_ sender: Any) {
        self.userTextbooksTableView.setEditing(false, animated: true)
        setRefreshControl()
        setSettingsButton()
        setDeleteButton()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationItem.title = "Profile"
    }
    
    func setDeleteButton() {
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePressed(_:)))
        self.navigationItem.rightBarButtonItem = deleteButton
    }
    
    func setCancelButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelPressed(_:)))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func setSettingsButton() {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "Settings"), style: .done, target: self, action: #selector(settingsPressed(_:)))
        self.navigationItem.leftBarButtonItem = settingsButton
    }
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getUserTextbooksReq(_:)), for: .valueChanged)
        userTextbooksTableView.refreshControl = refreshControl
    }
    
    @objc private func settingsPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: {
            action in
            self.logoutPressed()
        }))
        alert.addAction(UIAlertAction(title: "Delete Account", style: .destructive, handler: {
            action in
            print("Delete account")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            print("Cancel settings")
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func logoutPressed() {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ProfileToSell", sender: self)
        userTextbooksTableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ProfileToSell") {
            if let sellVC = segue.destination as? SellViewController {
                sellVC.navigationItem.title = "Edit textbook!"
                sellVC.editTextbookMode = true
                if let indexPath = self.userTextbooksTableView.indexPathForSelectedRow {
                    let textbook = userTextbooks[indexPath.row]
                    sellVC.editTextbookIdText = String(textbook.id)
                    if let cell = self.userTextbooksTableView.cellForRow(at: indexPath) as? TextbookCell {
                        if(textbook.images.count > 0) {
                            sellVC.editImageData = cell.textbookImageView.image!
                        }
                        else {
                            sellVC.editImageData = nil
                        }
                    }
                    sellVC.editTitleText = textbook.textbook_title
                    sellVC.editAuthorText = textbook.textbook_author
                    sellVC.editEditionText = textbook.textbook_edition
                    sellVC.editConditionText = textbook.textbook_condition
                    sellVC.editTypeText = textbook.textbook_type
                    sellVC.editCoursecodeText = textbook.textbook_coursecode
                    sellVC.editPriceText = textbook.textbook_price
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        deleteTextbook(textbookId: String(userTextbooks[indexPath.row].id), withCompletion: {(isSuccessful) -> Void in
            if(isSuccessful) {
                self.userTextbooks.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.userTextbooksTableView.reloadData()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.cancelPressed((Any).self)
                    createAlert(title: "Oh no! Server problem!", message: "Seems like we are unable to reach the server at the moment.\n\nPlease try again later.")
                }
            }
        })
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
