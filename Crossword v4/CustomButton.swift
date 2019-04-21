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
    var hint2: String = ""
    var pressed: Int = 0
    var pressedBool: Bool = false
    var correctAnswer: Bool = false
    
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
