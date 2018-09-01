//
//  GetSignedPutUrl.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-28.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import KeychainAccess

class GetSignedPutUrl {
    private var signedPutUrl: String?
    
    func req(textbookId: String, chosenImageExtension: String.SubSequence, withCompletion completion: @escaping ((_ isSuccessful: Bool) -> Void)) {
        let endpoint = getBaseUrl() + "/aws/" + textbookId + "/" + chosenImageExtension
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "GET"
        let keychain = Keychain(service: "com.rickybooks.rickybooks")
        request.setValue("Token token=" + keychain["token"]!, forHTTPHeaderField: "Authorization")
        
        let requestTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                print("Error with the data received")
                return
            }
            let rawUrlData = String(data: data, encoding: String.Encoding.utf8)!
            let fixedUrlData = (rawUrlData.replacingOccurrences(of: "\\u0026", with: "&")).replacingOccurrences(of: "\"", with: "")
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if(statusCode == 200) {
                self.signedPutUrl = fixedUrlData
                completion(true)
            }
            else {
                self.signedPutUrl = nil
                completion(false)
            }
        }
        requestTask.resume()
    }
    
    func getData() -> String {
        return signedPutUrl!
    }
}
