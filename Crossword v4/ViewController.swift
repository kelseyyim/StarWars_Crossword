//
//  ViewController.swift
//  Crossword v4
//
//  Created by Kelsey Yim on 4/4/19.
//  Copyright © 2019 Kelsey Yim. All rights reserved.
//

import UIKit
let buttonArray = [0, 1, 2, 3, 4, 5, 6, 7] //Size of grid = 8x8
var btnY = 0
var btnX = -50   // x coordinate of where buttons start getting placed on the view
let btnHeight = 50
let btnWidth = 50
var answerLetters = [Character]()
var wordArray = [KelseyButton]()
var currentAnswer: String = ""
var viewWidth: Int = 0

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var mainView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoLabel2: UILabel!
    @IBOutlet weak var infoLabel3: UILabel!
    let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    //Variables to dynamically calculate center of view so it works with any screen size
    
    var spacing: Int = 0
    var difference: Int = 0
    
    var questionmark: UIButton!
    var boardView: UIView!
    var counter: Int = 0
    var infoCounter: Int = 1
    let lightside_bg = UIImage(named: "luke.png")
    let darkside_bg = UIImage(named: "darth.png")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Helps center programmatically created button grid
        viewWidth = Int(view.frame.size.width)
        spacing = (viewWidth - (btnWidth * 7))/2
        difference = btnWidth - spacing
        
        //Set up textfield and submit button to answer
        textField.delegate = self
        textField.backgroundColor = UIColor(white: 1, alpha: 0)
        submitButton.backgroundColor = UIColor(white: 1, alpha: 0)
        submitButton.setTitleColor(UIColor(white: 1, alpha: 0), for: .normal)
        
        
        
        //Change background of image depending on light/dark button
        if (userChoice == "light"){
            self.mainView.image = lightside_bg
            mainView.contentMode =  UIView.ContentMode.scaleAspectFill
            mainView.clipsToBounds = true
            view.addSubview(mainView)
            view.sendSubviewToBack(mainView)
        }
        else{
            self.mainView.image = darkside_bg
            mainView.contentMode =  UIView.ContentMode.scaleAspectFill
            mainView.clipsToBounds = true
            view.addSubview(mainView)
            view.sendSubviewToBack(mainView)
            
        }
        
        //Create home button
        let deathstar = UIButton(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
        deathstar.addTarget(self, action: #selector(self.onPress(_:)), for: UIControl.Event.touchUpInside)
        deathstar.setImage(UIImage(named: "deathstar"), for: .normal)
        
        
        //Create Info button
        questionmark = UIButton(frame: CGRect(x: view.frame.width - 50, y: 20, width: 40, height: 50))
        questionmark.addTarget(self, action: #selector(onInfoPress(_:)), for: UIControl.Event.touchUpInside)
        questionmark.setImage(UIImage(named: "lights_off"), for: .normal)
        
        //Set info labels to disappear and reappear on touch
        infoLabel.backgroundColor = UIColor.yellow.withAlphaComponent(0.8)
        infoLabel.textAlignment = .center
        infoLabel.text = " Touch the death star to go back home "
        infoLabel.numberOfLines = 0
        infoLabel.sizeToFit()
        infoLabel.isHidden = true
        
        infoLabel2.backgroundColor = UIColor.yellow.withAlphaComponent(0.8)
        infoLabel2.textAlignment = .center
        infoLabel2.text = " Touch the boxes and guess the answer! "
        infoLabel2.numberOfLines = 0
        infoLabel2.sizeToFit()
        infoLabel2.isHidden = true
        
        infoLabel3.backgroundColor = UIColor.yellow
        infoLabel3.textAlignment = .center
        infoLabel3.text = " Pinch to zoom in/out if necessary "
        infoLabel3.numberOfLines = 0
        infoLabel3.sizeToFit()
        infoLabel3.isHidden = true
        
        //Create gestures
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        //Create board for where crossword tiles will appear
        self.boardView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 250))
        self.view.addSubview(boardView)
        createButtons()
        self.boardView.addGestureRecognizer(pinchGesture)
        
        self.view.addSubview(deathstar)
        self.view.addSubview(questionmark)
        self.view.addSubview(hintLabel)
        boardView.addSubview(infoLabel3)
        
        boardView.center.x = view.center.x
        boardView.center.y = CGFloat(Int(view.center.y) - Int(deathstar.center.y) - btnWidth)
       
        
    }

    //Keyboard settings
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y = -100     //Creates effect of zooming to the text field
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
        return true
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
        self.view.frame.origin.y = 0
    }
    
    //Home + Info Button functionality
    @objc func onPress( _ button : UIButton){       // for death star home button
        let homeView = sampleStoryBoard.instantiateViewController(withIdentifier: "home") as! IntroScreenController
        homeView.isModalInPopover = true
        self.showDetailViewController(homeView, sender: button)
    }
    
    
    @objc func onInfoPress( _ button : UIButton){       //for light bulb info button
        infoCounter += 1                                //To mimic a toggle feature
        if (infoCounter % 2 == 0){
            infoLabel.isHidden = false
            infoLabel2.isHidden = false
            infoLabel3.isHidden = false
            questionmark.setImage(UIImage(named: "lights_on"), for: .normal)
        }
        if (infoCounter % 2 != 0){
            infoLabel.isHidden = true
            infoLabel2.isHidden = true
            infoLabel3.isHidden = true
            questionmark.setImage(UIImage(named: "lights_off"), for: .normal)
        }
    }
    
    //Defining pinchGesture to mimic zooming in/out
    @objc func pinchGesture(sender: UIPinchGestureRecognizer){  //allows you to zoom in and out
        boardView.transform = (boardView.transform.scaledBy(x: sender.scale, y: sender.scale))
        sender.scale = 1
    }
    
    //Programmatically create grid of buttons
    func createButtons(){
        for i in 1 ..< buttonArray.count{
            btnX = btnWidth * i
            for j in 1 ..< buttonArray.count{
                counter += 1
                btnY = btnHeight * j + 50          //60 is how far down the crossword is from the top of the screen
                let btn = KelseyButton()
                btn.backgroundColor = UIColor(white: 1, alpha: 0)
                btn.frame = CGRect(x: btnX - difference , y: btnY - 50, width: btnWidth - 2, height: btnHeight - 2)
                btn.contentMode = UIView.ContentMode.scaleToFill
                btn.mytag = (buttonArray.index(of: i)!, (buttonArray.index(of: j))!)
                btn.btnX = buttonArray.index(of: i)!
                btn.btnY = buttonArray.index(of: j)!
                btn.tag = counter
                btn.addTarget(self, action: #selector(self.btnTouched(_:)), for: UIControl.Event.touchUpInside)
                self.boardView.addSubview(btn)
                
                if (btn.tag <= 11 && btn.tag >= 8){
                    for index in 0 ..< 5 {
                        if let button = self.view.viewWithTag(8 + index) as? KelseyButton
                        {
                            button.backgroundColor = UIColor(white: 1, alpha: 0.7)
                            if (button.word == ""){
                                button.word = "yoda"
                                
                            }
                            if (button.tag == 11 || button.tag == 8){
                                button.thirdWord = "yoda"
                            }
                            button.hint = "Who trained almost every Jedi master"
                            wordArray.append(button)
                        }
                    }
                }
                if (btn.tag == 1 || btn.tag == 8 || btn.tag == 15){
                    for index in 0 ..< 4 {        //Creates a 3 letter word horizontally
                        if let button = self.view.viewWithTag(index * 8 - index + 1) as? KelseyButton
                        {
                            button.backgroundColor = UIColor(white: 1, alpha: 0.7)
                            button.word = "jyn"
                            button.hint = "Lyra’s daughter"
                            wordArray.append(button)
                        }
                    }
                }
            
                if (btn.tag <= 28 && btn.tag >= 25){
                    for index in 25 ..< 29 {
                        if let button = self.view.viewWithTag(index) as? KelseyButton
                        {
                            button.backgroundColor = UIColor(white: 1, alpha: 0.7)
                            if (button.word == ""){
                                button.word = "shmi"
                                
                            }
                            if (button.tag == 28 || button.tag == 25){
                                button.thirdWord = "shmi"
                            }
                            button.hint = "Luke's Grandmother"
                            wordArray.append(button)
                        }
                    }
                }
                if (btn.tag <= 7 && btn.tag >= 4){
                    for index in 4 ..< 8 {
                        if let button = self.view.viewWithTag(index) as? KelseyButton
                        {
                            button.backgroundColor = UIColor(white: 1, alpha: 0.7)
                            if (button.word == ""){
                                button.word = "hutt"
                                
                            }
                            if (button.tag == 4){
                                button.thirdWord = "hutt"
                            }
                            button.hint = "A fictional alien race in the Star Wars universe"
                            wordArray.append(button)
                        }
                    }
                }
                if (btn.tag <= 32 && btn.tag >= 29){
                    for index in 21 ..< 25 {
                        if let button = self.view.viewWithTag(index + 8) as? KelseyButton
                        {
                            button.backgroundColor = UIColor(white: 1, alpha: 0.7)
                            if (button.word == ""){
                                button.word = "c3po"
                            
                            }
                            if (button.tag == 32){
                                button.thirdWord = "c3po"
                            }
                            button.hint = "Fluent in over six million forms of communication"
                            wordArray.append(button)
                        }
                    }
                }
                if (btn.tag == 11 || btn.tag == 18 || btn.tag == 39 || btn.tag == 46){
                    for index in 0 ..< 8 {
                        if let button = self.view.viewWithTag((index * 8 - index + 4)) as? KelseyButton
                        {
                            button.backgroundColor = UIColor(white: 1, alpha: 0.7)
                            
                            button.word = "hansolo"
                            button.hint = "He smashes his mask in the Last Jedi"
                            wordArray.append(button)
                        }
                    }
                }

                if (btn.tag <= 49 && btn.tag >= 45){
                    for index in 45 ..< 50 {
                        if let button = self.view.viewWithTag(index) as? KelseyButton
                        {
                            button.backgroundColor = UIColor(white: 1, alpha: 0.7)
                            if (button.word == ""){
                                button.word = "porgs"
                                
                            }
                            if (button.tag == 46){
                                button.thirdWord = "porgs"
                            }
                            button.hint = "Native to AhCh-To and can be found dwelling in along the cliffs of the island where Luke and Rey are."
                            wordArray.append(button)
                        }
                    }
                }


                if (btn.tag == 21 || btn.tag == 28 || btn.tag == 35){
                    for index in 2 ..< 6 {                              //7 is the row
                        if let button = self.view.viewWithTag((index * 8 - index + 7)) as?  KelseyButton
                        {
                            button.backgroundColor = UIColor(white: 1, alpha: 0.7)
                            button.word = "fin"
                            button.hint = "Who was the former storm trooper who joined the rebels"
                            wordArray.append(button)
                        }
                    }
                }
            }
        }
    
    }
    
    //For when user touches any box on the crossword
    @objc func btnTouched( _ button : KelseyButton)
    {
        print("tag #: ", button.tag, "  word: ", button.word, " thirdWord: ", button.thirdWord)
        currentAnswer = button.word
        hintLabel.isHidden = false
        hintLabel.text = button.hint
        hintLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        //So it's not noticeable the spaces around are buttons also
        if(button.word == ""){
            hintLabel.isHidden = true
        }
        self.view.addSubview(hintLabel)
        if (!button.pressedBool){
            for i in wordArray{
                i.backgroundColor = UIColor(white: 1, alpha: 0.7)
                i.pressedBool = false
            }
        }
        for i in wordArray{
            if (i.word.contains(button.word) || i.secondWord.contains(button.secondWord) || i.thirdWord.contains(button.word)){
                i.backgroundColor = UIColor.white
                i.pressedBool = true

                }
            }
        textField.backgroundColor = UIColor(white: 1, alpha: 0.5)
        submitButton.backgroundColor = UIColor.red
        submitButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    //Checks to see if user's input matches crossword's answer
    @IBAction func pressSubmit(){
        if (textField.text == currentAnswer){
            for letter in textField.text!.uppercased().characters{
                answerLetters.append(letter)
                print(answerLetters.count)
                changeButtonLabels()
                hintLabel.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            }
        }
        else{
            hintLabel.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            textField.text = ""
        }
        
    }
    //Prints correct answer onto appropriate crossword section
    func changeButtonLabels(){
        var count = 0
        for i in wordArray{
            if (i.backgroundColor == UIColor.white && count <= answerLetters.count-1){
                count += 1
                i.setTitle(String(answerLetters[count-1]), for: .normal)
                i.setTitleColor(UIColor.black, for: .normal)
                i.backgroundColor = UIColor.green
                i.isEnabled = false
            }
        }
        textField.text = ""
        answerLetters.removeAll()
       
    }
    
}

