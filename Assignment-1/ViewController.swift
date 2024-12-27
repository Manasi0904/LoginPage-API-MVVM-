//
//  ViewController.swift
//  Assignment-1
//
//  Created by Kumari Mansi on 26/12/24.
//



import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var enterDigitLabel: UILabel!
    @IBOutlet weak var enterDigitLabel2: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var stackForEnterDigit: UIStackView!
    @IBOutlet weak var textField1: CustomTextField!
    @IBOutlet weak var textField2: CustomTextField!
    @IBOutlet weak var textField3: CustomTextField!
    @IBOutlet weak var textField4: CustomTextField!
    @IBOutlet weak var keyboardConstraints: NSLayoutConstraint!
    
   
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        initialSetup()
    }
    
  
    func initialSetup() {
        
        loginLabel.font = UIFont(name: "Circe Regular", size: 26)
        enterDigitLabel.font = UIFont(name: "Circe Regular", size: 12)
        enterDigitLabel2.font = UIFont(name: "Circe-Bold", size: 12)
        forgetButton?.titleLabel?.font = UIFont(name: "Circe Regular", size: 12)
        loginButton?.titleLabel?.font = UIFont(name: "Circe Regular", size: 14)
        loginButton.layer.cornerRadius = 5
        loginButton.isUserInteractionEnabled = false
        loginButton.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        mainView.layer.cornerRadius = 30
        mainView.layer.masksToBounds = true
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let forgotText = "Forgot PIN?"
        let attributedString = NSMutableAttributedString(string: forgotText)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: forgotText.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.saddleBrown, range: NSRange(location: 0, length: forgotText.count))
       forgetButton.setAttributedTitle(attributedString, for: .normal)

     
        let textFields = [textField1, textField2, textField3, textField4]
        for (index, textField) in textFields.enumerated() {
            textField?.tag = index + 1
            textField?.layer.borderColor = UIColor.platinum.cgColor
            textField?.layer.borderWidth = 1
            textField?.layer.cornerRadius = 8
            textField?.delegate = self
            textField?.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            tap.numberOfTapsRequired = 1
            self.view.addGestureRecognizer(tap)
        let center: NotificationCenter = NotificationCenter.default
                    center.addObserver(self, selector: #selector(keyboardShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                    center.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                }
                
                @objc func keyboardShown(notification: Notification) {
                   keyboardConstraints.constant = -250
                    view.layoutIfNeeded()

                }
                
        @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
            self.view.endEditing(true)
        }
                @objc func keyboardHidden(notification: Notification) {
                   keyboardConstraints.constant = 0
                    view.layoutIfNeeded()

                }
      
   
    @objc func textDidChange(textField: UITextField) {
        guard let text = textField.text else { return }

        if text.count == 1 {
            if let nextField = view.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else if text.isEmpty {
            if let previousField = view.viewWithTag(textField.tag - 1) as? UITextField {
                previousField.becomeFirstResponder()
            }
        }

        checkFieldsAndEnableSubmit()
    }

    private func checkFieldsAndEnableSubmit() {
        let allFieldsFilled = [textField1, textField2, textField3, textField4].allSatisfy { $0?.text?.count ?? 0 > 0 }
        loginButton?.isUserInteractionEnabled = allFieldsFilled
        loginButton?.backgroundColor = allFieldsFilled ? UIColor.brown : UIColor(white: 0.8, alpha: 1)
    }

  
    @IBAction func loginButton(_ sender: UIButton) {
        
        let pin = "\(textField1.text ?? "")\(textField2.text ?? "")\(textField3.text ?? "")\(textField4.text ?? "")"

        viewModel.verifyLogin(
            pin:  "H1Czb6OyxQWhxKu3mv85zw=="

        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Login successful: \(response.status)")
                       
                        if let confirmPinVC = self?.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") {
                            self?.navigationController?.pushViewController(confirmPinVC, animated: true)
                        }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: characterSet)
    }
}

