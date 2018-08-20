//
//  DetailsViewController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-17.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var detailsAuthorLabel: UILabel!
    @IBOutlet weak var detailsEditionLabel: UILabel!
    @IBOutlet weak var detailsConditionLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsCoursecodeLabel: UILabel!
    @IBOutlet weak var detailsPriceLabel: UILabel!
    @IBOutlet weak var detailsTimestampLabel: UILabel!
    @IBOutlet weak var detailsSellerLabel: UILabel!
    
    var detailsImageData: UIImage = UIImage()
    var detailsTitleText: String = ""
    var detailsAuthorText: String = ""
    var detailsEditionText: String = ""
    var detailsConditionText: String = ""
    var detailsTypeText: String = ""
    var detailsCoursecodeText: String = ""
    var detailsPriceText: String = ""
    var detailsTimestampText: String = ""
    var detailsSellerText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        
        let messageButton = UIBarButtonItem(title: "Message", style: .done, target: self, action: #selector(sendMessage(_:)))
        self.navigationItem.rightBarButtonItem = messageButton
    }
    
    @objc private func sendMessage(_ sender: Any) {
        // Do the message sending stuff!
    }
    
    func initData() {
        detailsImageView.image = detailsImageData
        detailsTitleLabel.text = detailsTitleText
        detailsAuthorLabel.text = detailsAuthorText
        detailsEditionLabel.text = detailsEditionText
        detailsConditionLabel.text = detailsConditionText
        detailsTypeLabel.text = detailsTypeText
        detailsCoursecodeLabel.text = detailsCoursecodeText
        detailsPriceLabel.text = detailsPriceText
        detailsTimestampLabel.text = detailsTimestampText
        detailsSellerLabel.text = detailsSellerText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
