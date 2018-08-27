//
//  BuyViewController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-04.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import Kingfisher

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

class BuyViewController: UITableViewController {
    private var textbooks = [Textbook]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getTextbooksReq(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
        getTextbooksReq((Any).self)
    }
    
    @objc private func getTextbooksReq(_ sender: Any) {
        let getTextbooks = GetTextbooks()
        getTextbooks.req(withCompletion: {
            self.textbooks = getTextbooks.getData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        })
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "BuyToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "BuyToDetails") {
            if let detailsVC = segue.destination as? DetailsViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let textbook = textbooks[indexPath.row]
                    if let cell = self.tableView.cellForRow(at: indexPath) as? TextbookTableViewCell {
                        detailsVC.detailsImageData = cell.textbookImageView.image!
                    }
                    detailsVC.detailsTitleText = textbook.textbook_title
                    detailsVC.detailsAuthorText = textbook.textbook_author
                    detailsVC.detailsEditionText = textbook.textbook_edition
                    detailsVC.detailsConditionText = textbook.textbook_condition
                    detailsVC.detailsTypeText = textbook.textbook_type
                    detailsVC.detailsCoursecodeText = textbook.textbook_coursecode
                    detailsVC.detailsPriceText = "$ " + textbook.textbook_price
                    detailsVC.detailsTimestampText = textbook.created_at
                    detailsVC.detailsSellerText = textbook.user.name
                }
            }
        }
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
