//
//  PostTextbookErrors.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-28.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

struct PostTextbookErrors: Decodable {
    var status: String?
    var message: String?
    var data: PostTextbookErrorsData
}
