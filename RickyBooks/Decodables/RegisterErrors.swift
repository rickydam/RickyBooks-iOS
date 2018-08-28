//
//  RegisterErrors.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-27.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

struct RegisterErrors: Decodable {
    var name: Array<String>?
    var email: Array<String>?
    var password: Array<String>?
    var password_confirmation: Array<String>?
}
