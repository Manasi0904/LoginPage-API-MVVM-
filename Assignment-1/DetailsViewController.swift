//
//  DetailsViewController.swift
//  Assignment-1
//
//  Created by Kumari Mansi on 26/12/24.
//




import UIKit

class DetailsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var selectUIView: UIView!
    @IBOutlet var enterDetailsTextField: UITextField!
    @IBOutlet var nameUiView: UIView!
    @IBOutlet var selectTextField: UITextField!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var userEmailTextField: UITextField!
    @IBOutlet var userMobileNumberTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var writeToLabel: UILabel!
    @IBOutlet var mostQueriesLabel: UILabel!
    @IBOutlet var faqLabel: UILabel!
    @IBOutlet var submitButton: UIButton!
    
    let viewModel = LoginViewModel()
   
    let pickerData = [
                   "General Enquiries",
                   "Billing and Payments",
                    "Product or Service Enquiries",
                    "Complaints and Feedback",
                  "Legal and Compliance",
                   "Others",
                  "Contact Us",
        ]
    var selectedPickerValue: String?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    func setupUI() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        selectTextField.inputView = pickerView
        
        writeToLabel.font = UIFont(name: "Circe-Bold", size: 16)
        mostQueriesLabel.font = UIFont(name: "Circe Regular", size: 15)
        faqLabel.font = UIFont(name: "Circe Regular", size: 14)
        mobileLabel.font = UIFont(name: "Circe Regular", size: 14)
        selectTextField.font = UIFont(name: "Circe Regular", size: 14)
        nameLabel.font = UIFont(name: "Circe Regular", size: 12)
        userNameTextField.font = UIFont(name: "Circe Regular", size: 15)
        userMobileNumberTextField.font = UIFont(name: "Circe Regular", size: 15)
        userEmailTextField.font = UIFont(name: "Circe Regular", size: 15)
        submitButton?.titleLabel?.font = UIFont(name: "Circe Regular", size: 14)
        
        submitButton.layer.cornerRadius = 5
        faqLabel.layer.cornerRadius = 5
        
        selectUIView.layer.borderWidth = 0.8
        selectUIView.layer.borderColor = UIColor.platinum.cgColor
        
        enterDetailsTextField.layer.cornerRadius = 8
        enterDetailsTextField.layer.borderWidth = 1
        enterDetailsTextField.layer.borderColor = UIColor.platinum.cgColor
        
        nameUiView.layer.cornerRadius = 12
        nameUiView.layer.borderWidth = 1
        nameUiView.layer.borderColor = UIColor.platinum.cgColor
        
        userEmailTextField.delegate = self
        userMobileNumberTextField.delegate = self
        userNameTextField.delegate = self
       
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectTextField.text = pickerData[row]
        selectedPickerValue = pickerData[row]
        updateSubmitButtonState()
    }
    
    func updateSubmitButtonState() {
        
        let name = userNameTextField.text ?? ""
        let isNameValid = name.count >= 4 && name.count <= 40
        let allowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
        let characterSet = CharacterSet(charactersIn: name)
        if !allowedCharacterSet.isSuperset(of: characterSet) {
    }
        
        
        let isPhoneValid: Bool = {
            guard let phoneText = userMobileNumberTextField.text else { return false }
            let phoneWithoutPrefix = phoneText.replacingOccurrences(of: "+91 ", with: "")
            return phoneWithoutPrefix.count == 10 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phoneWithoutPrefix))
        }()
        
        
        let isEmailValid = isValidEmail(userEmailTextField.text ?? "")
        let isPickerValid = selectedPickerValue != nil
        
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[a-zA-Z]+[0-9]*@[a-zA-Z]+\\.[a-z]{2,64}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userMobileNumberTextField {
            let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            
            var currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if !currentText.hasPrefix("+91 ") && updatedText.count == 4 {
                
                textField.text = "+91 "
                return false
            }
            
            return updatedText.count <= 14
        }
        
        return true
    }
    
    
  
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
        
        @IBAction func submitButtonTapped(_ sender: UIButton) {
            guard let email = userEmailTextField.text,
                  let name = userNameTextField.text,
                  let phoneNumber = userMobileNumberTextField.text,
                  let description = enterDetailsTextField.text,
                  let selectedCategory = selectedPickerValue else {
                print("Please fill in all fields")
                return
            }
            
            let enquiryRequest = EnquiryRequest(
                email: email,
                name: name,
                phoneNumber: phoneNumber,
                categoryType: selectedCategory,
                description: description
            )
            
            viewModel.submitEnquiry(request: enquiryRequest) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        let alert = UIAlertController(title: "Success", message: "Enquiry submitted successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    case .failure(let error):
                        debugPrint(error)
                        let alert = UIAlertController(title: "Error", message: "Failed to submit enquiry: \(error.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
        
        
