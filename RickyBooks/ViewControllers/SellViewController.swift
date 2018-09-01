//
//  SellViewController.swift
//  RickyBooks
//
//  Created by Ricky Dam on 2018-08-02.
//  Copyright © 2018 RickyBooks. All rights reserved.
//

import UIKit
import KeychainAccess

class SellViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
    @IBOutlet weak var chooseImageButton: UIButton!
    
    var chosenImageExtension: String.SubSequence!
    var chosenImageData: UIImage!
    @IBOutlet weak var chosenImage: UIImageView!
    @IBOutlet weak var chosenImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var editTextbookMode = Bool()
    var editTextbookIdText = String()
    var editImageData: UIImage?
    var editTitleText =  String()
    var editAuthorText = String()
    var editEditionText = String()
    var editConditionText = String()
    var editTypeText = String()
    var editCoursecodeText = String()
    var editPriceText = String()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if(editTextbookMode) {
            if(editImageData != nil) {
                setImage(imageData: editImageData!)
            }
            textbookTitleField.text = editTitleText
            textbookAuthorField.text = editAuthorText
            textbookEditionField.text = editEditionText
            textbookConditionField.text = editConditionText
            textbookTypeField.text = editTypeText
            textbookCoursecodeField.text = editCoursecodeText
            textbookPriceField.text = editPriceText
        }
    }
    
    @objc private func keyboardWillShow(_ sender: NSNotification) {
        scrollViewBottomConstraint.constant = 170
    }
    
    @objc private func keyboardWillHide(_ sender: NSNotification) {
        scrollViewBottomConstraint.constant = 0
    }
    
    @IBAction func onChooseImagePressed(_ sender: UIButton) {
        if(chooseImageButton.titleLabel?.text == "Choose Image") {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        else if(chooseImageButton.titleLabel?.text == "Delete Image") {
            clearImageData()
        }
        else {
            print("Error with choosing or deleting the image.")
        }
    }
    
    func clearImage() {
        chosenImage.frame.size.height = 0
        chosenImageHeightConstraint.constant = 0
        chooseImageButton.setTitle("Choose Image", for: .normal)
        chooseImageButton.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    }
    
    func clearImageData() {
        clearImage()
        self.chosenImageData = nil
        self.chosenImageExtension = nil
    }
    
    func setImage(imageData: UIImage) {
        chosenImage.frame.size.height = 150
        chosenImageHeightConstraint.constant = 150
        chosenImage.contentMode = .scaleAspectFit
        chosenImage.image = imageData
        chosenImageData = imageData
        chooseImageButton.setTitle("Delete Image", for: .normal)
        chooseImageButton.backgroundColor = UIColor(red: 190/255, green: 38/255, blue: 37/255, alpha: 1)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageData = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setImage(imageData: imageData)
            if let imgUrl = info[UIImagePickerControllerImageURL] as? URL {
                let imgName = imgUrl.lastPathComponent
                let index = imgName.index(imgName.index(of: ".")!, offsetBy: 1)
                chosenImageExtension = imgName[index...]
            }
        }
    }
    
    @IBAction func onSubmitPressed(_ sender: UIButton) {
        postTextbook()
    }
    
    func postTextbook() {
        let titleInput = textbookTitleField.text!
        let authorInput = textbookAuthorField.text!
        let editionInput = textbookEditionField.text!
        let conditionInput = textbookConditionField.text!
        let typeInput = textbookTypeField.text!
        let coursecodeInput = textbookCoursecodeField.text!
        let priceInput = textbookPriceField.text!
        
        let postTextbook = PostTextbook()
        postTextbook.req(sellViewController: self, titleInput: titleInput, authorInput: authorInput, editionInput: editionInput, conditionInput: conditionInput, typeInput: typeInput, coursecodeInput: coursecodeInput, priceInput: priceInput, withCompletion: {
            var textbookId: String?
            textbookId = postTextbook.getData()
            if textbookId != nil {
                let getSignedPutUrl = GetSignedPutUrl()
                getSignedPutUrl.req(textbookId: textbookId!, chosenImageExtension: self.chosenImageExtension, withCompletion: {
                    let signedPutUrl = getSignedPutUrl.getData()
                    putImageAws(signedPutUrlString: signedPutUrl, chosenImageExtension: self.chosenImageExtension, chosenImageData: self.chosenImageData)
                    DispatchQueue.main.async {
                        self.clearImageData()
                    }
                })
            }
        })
    }
    
    @IBAction func courseTextChange(_ sender: Any) {
        enforceMaxLength(textField: textbookCoursecodeField, maxLength: 8)
    }
    
    @IBAction func priceTextChange(_ sender: Any) {
        enforceMaxLength(textField: textbookPriceField, maxLength: 3)
    }
    
    @objc func clearAll(_ sender: Any) {
        textbookTitleField.text = ""
        textbookAuthorField.text = ""
        textbookEditionField.text = ""
        textbookConditionField.text = ""
        textbookTypeField.text = ""
        textbookCoursecodeField.text = ""
        textbookPriceField.text = ""
        clearImage()
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
        chooseImageButton.layer.cornerRadius = 5
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
