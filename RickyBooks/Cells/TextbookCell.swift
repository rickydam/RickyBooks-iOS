//
//  TextbookCell.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-29.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

class TextbookCell: UITableViewCell {
    @IBOutlet weak var textbookImageView: UIImageView!
    @IBOutlet weak var textbookTitleLabel: UILabel!
    @IBOutlet weak var textbookAuthorLabel: UILabel!
    @IBOutlet weak var textbookEditionLabel: UILabel!
    @IBOutlet weak var textbookConditionLabel: UILabel!
    @IBOutlet weak var textbookTypeLabel: UILabel!
    @IBOutlet weak var textbookCoursecodeLabel: UILabel!
    @IBOutlet weak var textbookPriceLabel: UILabel!
    @IBOutlet weak var textbookTimestampLabel: UILabel!
    @IBOutlet weak var textbookSellerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
