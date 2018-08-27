//
//  UserData.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-27.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

struct UserData: Decodable {
    var token: String
    var user_id: Int
    var name: String
}
