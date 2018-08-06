//
//  BuyTableViewController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-04.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import Kingfisher

struct Textbook: Decodable {
    var id: Int
    var textbook_title: String
    var textbook_author: String
    var textbook_edition: String
    var textbook_condition: String
    var textbook_type: String
    var textbook_coursecode: String
    var textbook_price: String
    var created_at: String
    var user_id: Int
    var user: User
    var images: [Image]
}

struct User: Decodable {
    var name: String
}

struct Image: Decodable {
    var url: String
}

class TextbookTableViewCell: UITableViewCell {
    @IBOutlet weak var textbookTitleLabel: UILabel!
    @IBOutlet weak var textbookAuthorLabel: UILabel!
    @IBOutlet weak var textbookEditionLabel: UILabel!
    @IBOutlet weak var textbookConditionLabel: UILabel!
    @IBOutlet weak var textbookTypeLabel: UILabel!
    @IBOutlet weak var textbookCoursecodeLabel: UILabel!
    @IBOutlet weak var textbookPriceLabel: UILabel!
    @IBOutlet weak var textbookTimestampLabel: UILabel!
    @IBOutlet weak var textbookSellerLabel: UILabel!
    @IBOutlet weak var textbookImageView: UIImageView!
}

class BuyTableViewController: UITableViewController {
    private var textbooks = [Textbook]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getTextbooks(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
        getTextbooks((Any).self)
    }
    
    @objc private func getTextbooks(_ sender: Any) {
        let urlString = "https://rickybooks.herokuapp.com/textbooks"
        guard let url = URL(string: urlString) else {
            print("Error creating the URL")
            return
        }
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                print("Error with the data received")
                return
            }
            do {
                self.textbooks = try JSONDecoder().decode([Textbook].self, from: data)
            } catch let jsonError {
                print("Error with JSONDecoder", jsonError)
            }
            DispatchQueue.main.sync {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textbooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextbookCell", for: indexPath) as! TextbookTableViewCell
        
        let textbook = textbooks[indexPath.row]
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
