//
//  PostTextbookErrorsData.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-28.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

struct PostTextbookErrorsData: Decodable {
    var textbook_title: Array<String>?
    var textbook_author: Array<String>?
    var textbook_edition: Array<String>?
    var textbook_condition: Array<String>?
    var textbook_type: Array<String>?
    var textbook_coursecode: Array<String>?
    var textbook_price: Array<String>?
}
