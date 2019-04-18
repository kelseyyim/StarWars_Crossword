//
//  KeyboardViewController.swift
//  CrosswordKeyboard
//
//  Created by Kelsey Yim on 4/4/19.
//  Copyright © 2019 Kelsey Yim. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    var keyboardView: UIView!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKeyboard()
    }
    func loadKeyboard(){
        let keyboardNib = UINib(nibName: "CWKeyboard", bundle: nil)
        keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as? UIView
        view.addSubview(keyboardView)
        view.backgroundColor = keyboardView.backgroundColor
    }
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    @IBAction func keyPressed(_ sender: UIButton){
        print("you are typing")
        
    }

}
