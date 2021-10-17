//
//  TextViewPlaceHolder.swift
//  ToDoList
//
//  Created by Ahmed Ahmedov on 17.10.2021.
//

import UIKit

class TextViewPlaceHolder: UITextView {
    
    var placeHolder: String?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        delegate = self
    }
}

// MARK: - UITextViewDelegate
extension TextViewPlaceHolder: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

         else if textView.text == placeHolder && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }

        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        }
    }
}
