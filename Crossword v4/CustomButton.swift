//
//  CustomButton.swift
//  CrosswordKeyboard
//
//  Created by Kelsey Yim on 4/6/19.
//  Copyright © 2019 Kelsey Yim. All rights reserved.
//

import UIKit

@IBDesignable class KelseyButton : UIButton {
    var mytag: (Int, Int) = (0,0)
    var btnX: Int = 0
    var btnY: Int = 0
    var word: String = ""
    var secondWord: String = ""
    var thirdWord: String = ""
    var hint: String = ""
    var pressed: Int = 0
    var pressedBool: Bool = false
    
    @IBInspectable var cornerRadius: CGFloat = 0{   //repace 0 with any number to programmatically force TILES to be round
        didSet{
            updateCorners(value: cornerRadius)
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet { layer.borderColor = borderColor.cgColor; }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth; }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        sharedInit()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        sharedInit()
    }
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    func updateCorners(value: CGFloat){
        layer.cornerRadius = value
    }
    
    func sharedInit(){
        updateCorners(value: cornerRadius)
    }
    
}
