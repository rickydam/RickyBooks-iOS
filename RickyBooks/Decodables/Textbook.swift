//
//  Textbook.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-27.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

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
