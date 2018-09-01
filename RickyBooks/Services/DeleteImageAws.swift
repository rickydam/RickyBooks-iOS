//
//  DeleteImageAws.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-31.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

func deleteImageAws(signedDeleteUrlString: String) {
    guard let signedDeleteUrl = URL(string: signedDeleteUrlString) else {
        print("Error creating the signed DELETE url")
        return
    }
    var request = URLRequest(url: signedDeleteUrl)
    request.httpMethod = "DELETE"
    
    let requestTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
        print("Successfully deleted image from AWS")
    }
    requestTask.resume()
}
