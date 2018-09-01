//
//  GetToken.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-31.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import KeychainAccess

func getToken() -> String {
    let keychain = Keychain(service: "com.rickybooks.rickybooks")
    return keychain["token"]!
}
