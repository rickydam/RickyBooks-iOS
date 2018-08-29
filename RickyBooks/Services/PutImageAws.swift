//
//  PutImageAws.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-28.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit

func putImageAws(signedPutUrlString: String, chosenImageExtension: String.SubSequence, chosenImageData: UIImage) {
    guard let signedPutUrl = URL(string: signedPutUrlString) else {
        print("Error creating the signed PUT url")
        return
    }
    var request = URLRequest(url: signedPutUrl)
    request.httpMethod = "PUT"
    
    var imageData: Data?
    if(chosenImageExtension == "jpeg") {
        if let jpegData = UIImageJPEGRepresentation(chosenImageData, 0.6) {
            imageData = jpegData
        }
        else {
            print("Error creating the JPEG")
        }
    }
    else if(chosenImageExtension == "png") {
        if let pngData = UIImagePNGRepresentation(chosenImageData) {
            imageData = pngData
        }
        else {
            print("Error creating the PNG")
        }
    }
    else {
        print("Unknown image file type")
    }
    request.httpBody = imageData
    
    let requestTask = URLSession.shared.dataTask(with: request) {(data, error, response) in
        print("Successfully posted image to AWS")
    }
    requestTask.resume()
}
