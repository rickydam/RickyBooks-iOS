//
//  GetSignedDeleteUrl.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-31.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

class GetSignedDeleteUrl {
    private var signedDeleteUrl: String?
    
    func req(textbookId: String, withCompletion completion: @escaping (_ isSuccessful: Bool) -> Void) {
        let endpoint = getBaseUrl() + "/get_delete_url/" + textbookId
        var request = URLRequest(url: URL(string: endpoint)!)
        request.setValue("Token token=" + getToken(), forHTTPHeaderField: "Authorization")
        
        let requestTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                print("Error with the data received")
                return
            }
            let rawUrlData = String(data: data, encoding: String.Encoding.utf8)!
            let fixedUrlData = (rawUrlData.replacingOccurrences(of: "\\u0026", with: "&")).replacingOccurrences(of: "\"", with: "")
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if(statusCode == 200) {
                self.signedDeleteUrl = fixedUrlData
                completion(true)
            }
            else {
                self.signedDeleteUrl = nil
                completion(false)
            }
        }
        requestTask.resume()
    }
    
    func getData() -> String {
        return signedDeleteUrl!
    }
}
