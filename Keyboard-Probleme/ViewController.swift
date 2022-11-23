//
//  ViewController.swift
//  Keyboard-Probleme
//
//  Created by Michael Hornung on 23.11.22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var textfield1: UITextField!
    @IBOutlet weak var textfield3: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var online: UIView!
    
    override func viewDidLoad() {
        
        
        
        textfield.delegate = self
        textfield1.delegate = self
        textfield1.keyboardType = .numbersAndPunctuation
        textfield3.delegate = self
        textView.delegate = self
        
        textView.inputAccessoryView = createToolbar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.dismissKeyboard()
    }
    
    
    @IBAction func onlineChange(_ sender: Any) {
        
        if textfield.text == textfield1.text{
            online.backgroundColor = UIColor.green
        } else{
            online.backgroundColor = UIColor.red
        }
    }
    
    //    keyboard overlaps view
    
    @objc func keyboardWillShow(notification: NSNotification){
        if self.view.frame.origin.y == 0 && (textfield3.isFirstResponder){
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            
        }
    }
    
    
    //    textfield dismiss on return
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    //    touch outside and dismiss
    
    
    @objc func dismissKeyboardTouchOutside(){
        view.endEditing(true)
    }
    
    func dismissKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //    toolbar for textView
    
    @objc func donePressed(){
        textView.endEditing(true)
    }
    @objc func trashPressed(){
        textView.text = ""
    }
    @objc func copyPressed(){
        UIPasteboard.general.string = textView.text
    }
    @objc func pastePressed(){
        if let myString = UIPasteboard.general.string {
            textView.insertText(myString)
        }
    }
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: #selector(trashPressed))
        let copyButton = UIBarButtonItem(image:UIImage(systemName: "doc.on.doc"), style: .plain,  target: nil, action: #selector(copyPressed))
        let pasteButton = UIBarButtonItem(image:UIImage(systemName: "doc.on.clipboard"), style: .plain, target: nil, action: #selector(pastePressed))
        
        toolbar.setItems([doneButton, trashButton, copyButton, pasteButton], animated: true)
        
        
        return toolbar
    }

}

