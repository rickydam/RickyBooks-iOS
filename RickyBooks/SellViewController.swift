//
//  SellViewController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-02.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import KeychainAccess

struct PostTextbookErrors: Decodable {
    var status: String?
    var message: String?
    var data: PostTextbookErrorsData
}

struct PostTextbookErrorsData: Decodable {
    var textbook_title: Array<String>?
    var textbook_author: Array<String>?
    var textbook_edition: Array<String>?
    var textbook_condition: Array<String>?
    var textbook_type: Array<String>?
    var textbook_coursecode: Array<String>?
    var textbook_price: Array<String>?
}

class SellViewController: UIViewController {
    @IBOutlet weak var textbookTitleField: UITextField!
    @IBOutlet weak var textbookAuthorField: UITextField!
    @IBOutlet weak var textbookEditionField: UITextField!
    @IBOutlet weak var textbookConditionField: UITextField!
    @IBOutlet weak var textbookTypeField: UITextField!
    @IBOutlet weak var textbookCoursecodeField: UITextField!
    @IBOutlet weak var textbookPriceField: UITextField!
    
    var editionList: [String] = [String]()
    var conditionList: [String] = [String]()
    var typeList: [String] = [String]()
    
    let editionPicker = UIPickerView()
    let conditionPicker = UIPickerView()
    let typePicker = UIPickerView()
    
    @IBOutlet weak var sellSubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clearAllButton = UIBarButtonItem(title: "Clear All", style: .done, target: self, action: #selector(clearAll(_:)))
        self.navigationItem.rightBarButtonItem = clearAllButton

        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        styleElements()
        createLists()
        createPickers()
        createToolbars()
    }
    
    @IBAction func onSubmitPressed(_ sender: UIButton) {
        let titleInput = textbookTitleField.text!
        let authorInput = textbookAuthorField.text!
        let editionInput = textbookEditionField.text!
        let conditionInput = textbookConditionField.text!
        let typeInput = textbookTypeField.text!
        let coursecodeInput = textbookCoursecodeField.text!
        let priceInput = textbookPriceField.text!
        
        let endpoint = "https://rickybooks.herokuapp.com/textbooks"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let keychain = Keychain(service: "com.rickybooks.rickybooks")
        request.setValue("Token token=" + keychain["token"]!, forHTTPHeaderField: "Authorization")
        let textbookDictionary: [String: Any] = [
            "user_id": keychain["user_id"]!,
            "textbook_title": titleInput,
            "textbook_author": authorInput,
            "textbook_edition": editionInput,
            "textbook_condition": conditionInput,
            "textbook_type": typeInput,
            "textbook_coursecode": coursecodeInput,
            "textbook_price": priceInput
        ]
        guard let obj = try? JSONSerialization.data(withJSONObject: textbookDictionary, options: []) else {
            print("Error with textbook obj JSONSerialization")
            return
        }
        request.httpBody = obj
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                print("Error with the data received")
                return
            }
            do {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                if(statusCode == 200) {
                    let alert = UIAlertController(title: "Success!", message: "Your textbook has been successfully posted!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        action in switch action.style {
                        case .default:
                            print("Default")
                        case .cancel:
                            print("Cancel")
                        case .destructive:
                            print("Destructive")
                        }
                    }))
                    DispatchQueue.main.async {
                        self.clearAll(self)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else if(statusCode == 422) {
                    let errors = try JSONDecoder().decode(PostTextbookErrors.self, from: data)
                    var errorMessage = ""
                    
                    let titleError = errors.data.textbook_title
                    if(titleError != nil) {
                        if(titleError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Title"
                        }
                    }
                    
                    let authorError = errors.data.textbook_author
                    if(authorError != nil) {
                        if(authorError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Author"
                        }
                    }
                    
                    let editionError = errors.data.textbook_edition
                    if(editionError != nil) {
                        if(editionError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Edition"
                        }
                    }
                    
                    let conditionError = errors.data.textbook_condition
                    if(conditionError != nil) {
                        if(conditionError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Condition"
                        }
                    }
                    
                    let typeError = errors.data.textbook_type
                    if(typeError != nil) {
                        if(typeError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Type"
                        }
                    }
                    
                    let coursecodeError = errors.data.textbook_coursecode
                    if(coursecodeError != nil) {
                        if(coursecodeError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Coursecode"
                        }
                    }
                    
                    let priceError = errors.data.textbook_price
                    if(priceError != nil) {
                        if(priceError![0] == "can't be blank") {
                            if(errorMessage != "") {
                                errorMessage += "\n"
                            }
                            errorMessage += "Missing: Textbook Price"
                        }
                    }
                    
                    let alert = UIAlertController(title: "Hmm.. you forgot something!", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        action in switch action.style {
                        case .default:
                            print("Default")
                        case .cancel:
                            print("Cancel")
                        case .destructive:
                            print("Destructive")
                        }
                    }))
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = NSTextAlignment.left
                    let leftAlignedMessage =  NSMutableAttributedString(
                        string: errorMessage,
                        attributes: [
                            NSAttributedStringKey.paragraphStyle: paragraphStyle,
                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)
                        ]
                    )
                    alert.setValue(leftAlignedMessage, forKey: "attributedMessage")
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    print("Error with the response.")
                }
            } catch let jsonError {
                print("Error with JSONDecoder", jsonError)
            }
        }.resume()
    }
    
    @IBAction func courseTextChange(_ sender: Any) {
        enforceMaxLength(textField: textbookCoursecodeField, maxLength: 8)
    }
    
    @IBAction func priceTextChange(_ sender: Any) {
        enforceMaxLength(textField: textbookPriceField, maxLength: 3)
    }
    
    @objc private func clearAll(_ sender: Any) {
        textbookTitleField.text = ""
        textbookAuthorField.text = ""
        textbookEditionField.text = ""
        textbookConditionField.text = ""
        textbookTypeField.text = ""
        textbookCoursecodeField.text = ""
        textbookPriceField.text = ""
        dismissKeyboard(self)
    }
    
    func createToolbars() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard(_:)))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        textbookEditionField.inputAccessoryView = toolbar
        textbookConditionField.inputAccessoryView = toolbar
        textbookTypeField.inputAccessoryView = toolbar
    }
    
    func createPickers() {
        editionPicker.delegate = self
        conditionPicker.delegate = self
        typePicker.delegate = self
        
        textbookEditionField.inputView = editionPicker
        textbookConditionField.inputView = conditionPicker
        textbookTypeField.inputView = typePicker
    }
    
    func styleElements() {
        textbookTitleField.layer.borderColor = UIColor.black.cgColor
        textbookTitleField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textbookTitleField.layer.borderWidth = 1.0
        
        textbookAuthorField.layer.borderColor = UIColor.black.cgColor
        textbookAuthorField.layer.borderWidth = 1.0
        textbookAuthorField.attributedPlaceholder = NSAttributedString(string: "Author", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        textbookEditionField.layer.borderColor = UIColor.black.cgColor
        textbookEditionField.layer.borderWidth = 1.0
        textbookEditionField.attributedPlaceholder = NSAttributedString(string: "Edition", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textbookEditionField.tintColor = UIColor.clear
        
        textbookConditionField.layer.borderColor = UIColor.black.cgColor
        textbookConditionField.layer.borderWidth = 1.0
        textbookConditionField.attributedPlaceholder = NSAttributedString(string: "Condition", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textbookConditionField.tintColor = UIColor.clear
        
        textbookTypeField.layer.borderColor = UIColor.black.cgColor
        textbookTypeField.layer.borderWidth = 1.0
        textbookTypeField.attributedPlaceholder = NSAttributedString(string: "Type", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textbookTypeField.tintColor = UIColor.clear
        
        textbookCoursecodeField.layer.borderColor = UIColor.black.cgColor
        textbookCoursecodeField.layer.borderWidth = 1.0
        textbookCoursecodeField.attributedPlaceholder = NSAttributedString(string: "Course (Ex: SYSC4504)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        textbookPriceField.layer.borderColor = UIColor.black.cgColor
        textbookPriceField.layer.borderWidth = 1.0
        textbookPriceField.attributedPlaceholder = NSAttributedString(string: "Price (Ex: 100)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        sellSubmitButton.layer.cornerRadius = 5
    }
    
    func createLists() {
        editionList = ["Custom Edition", "Global Edition", "1st Edition", "2nd Edition", "3rd Edition", "4th Edition", "5th Edition", "6th Edition", "7th Edition", "8th Edition", "9th Edition", "10th Edition", "11th Edition", "12th Edition", "13th Edition", "14th Edition", "15th Edition"]
        
        conditionList = ["New", "Like New", "Good", "Okay", "Bad"]
        
        typeList = ["Paperback", "Hardcover", "Looseleaf"]
    }
    
    func enforceMaxLength(textField: UITextField, maxLength: Int) {
        let length = textField.text?.count
        let inputText = textField.text
        if(length! > maxLength) {
            let index = inputText?.index((inputText?.startIndex)!, offsetBy: maxLength)
            textField.text = textField.text?.substring(to: index!)
        }
    }

    @objc private func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SellViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == editionPicker {
            return editionList.count
        }
        else if pickerView == conditionPicker {
            return conditionList.count
        }
        else if pickerView == typePicker {
            return typeList.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == editionPicker {
            return editionList[row]
        }
        else if pickerView == conditionPicker {
            return conditionList[row]
        }
        else if pickerView == typePicker {
            return typeList[row]
        }
        else {
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == editionPicker {
            textbookEditionField.text = editionList[row]
        }
        else if pickerView == conditionPicker {
            textbookConditionField.text = conditionList[row]
        }
        else if pickerView == typePicker {
            textbookTypeField.text = typeList[row]
        }
        else {
            // No action requierd
        }
    }
}
