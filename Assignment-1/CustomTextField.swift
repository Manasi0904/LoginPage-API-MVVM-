//
//  CustomTextField.swift
//  Assignment-1
//
//  Created by Kumari Mansi on 26/12/24.
//
import Foundation
import UIKit

protocol CustomTextFieldDelegate: AnyObject {
    func textFieldDidDelete(textField: CustomTextField)
}

class CustomTextField: UITextField {

    weak var textFieldDelegate: CustomTextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        textFieldDelegate?.textFieldDidDelete(textField: self)
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        rect.size.height = 25
        rect.origin.y = 10
        return rect
    }
}
