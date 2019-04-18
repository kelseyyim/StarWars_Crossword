//
//  QuestionList.swift
//  Crossword v4
//
//  Created by Kelsey Yim on 4/6/19.
//  Copyright © 2019 Kelsey Yim. All rights reserved.
//

import UIKit
var userChoice: String = "light"    //set default to light :) 
var startGame: Int = 1              //1 for game start, 0 for off

class IntroScreenController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewHeight = Int(self.view.frame.size.height)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "yoda.png")!)
        let darkPlay = UIButton(frame: CGRect(x: Int(view.center.x/2), y: viewHeight/4 , width: 200, height: 100))
        let lightPlay = UIButton(frame: CGRect(x: Int(view.center.x/2), y: viewHeight/2, width: 200, height: 100))
        darkPlay.addTarget(self, action: #selector(self.onPressDark(_:)), for: UIControl.Event.touchUpInside)
        lightPlay.addTarget(self, action: #selector(self.onPressLight(_:)), for: UIControl.Event.touchUpInside)
        darkPlay.setImage(UIImage(named: "darkside"), for: .normal)
        lightPlay.setImage(UIImage(named:"lightside"), for: .normal)
        self.view.addSubview(darkPlay)
        self.view.addSubview(lightPlay)
    }
    
    @objc func onPressLight( _ button : UIButton){
        userChoice = "light"
        performSegue(withIdentifier: "gameScreen", sender: nil)
        
        
    }
    @objc func onPressDark( _ button : UIButton){
        userChoice = "dark"
        performSegue(withIdentifier: "gameScreen", sender: nil)
    }
    
}
