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
var secondHint: String = ""
var viewWidth: Int = 0
var coins: Int = 50
var numOfCorrectAnswers: Int = 0


class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var mainView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoLabel2: UILabel!
    @IBOutlet weak var infoLabel3: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    
    let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    //Variables to dynamically calculate center of view so it works with any screen size
    
    var spacing: Int = 0
    var difference: Int = 0

    
    var deathstar: UIButton!
    var questionmark: UIButton!
    
    var buyLabel: UILabel!
    var buy_yes: UIButton!
    var buy_no: UIButton!
    
    var boardView: UIView!
    var titleScreenView: UIView!
    var titleScreenBG: UIImageView!
    
    var coinsImage: UIImageView!

    var buyHintView: UIImageView!
    
    var counter: Int = 0
    var infoCounter: Int = 1
    let lightside_bg = UIImage(named: "luke.png")
    let darkside_bg = UIImage(named: "darth.png")
    let titlescreen_bg = UIImage(named: "yoda.png")
    let coinImage = UIImage(named:"coin.png")
    let buyHintWarning = UIImage(named: "Rectangle.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Helps center programmatically created button grid
        viewWidth = Int(view.frame.size.width)
        spacing = (viewWidth - (btnWidth * 7))/2
        difference = btnWidth - spacing
        
        //Set up textfield, submit button, and hint button
        textField.delegate = self
        textField.backgroundColor = UIColor(white: 1, alpha: 0)
        submitButton.backgroundColor = UIColor(white: 1, alpha: 0)
        submitButton.setTitleColor(UIColor(white: 1, alpha: 0), for: .normal)
        hintButton.isHidden = true
        
        //Create view for title screen
        self.titleScreenView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        self.titleScreenView.backgroundColor = UIColor(patternImage: UIImage(named: "yoda.png")!)
        
        self.titleScreenBG = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        self.titleScreenBG.image = titlescreen_bg
        self.titleScreenView.addSubview(titleScreenBG)
        self.view.addSubview(titleScreenView)
        
        
        //Set up title screen buttons
        let viewHeight = Int(self.view.frame.size.height)
        let darkPlay = UIButton(frame: CGRect(x: Int(view.center.x/2), y: viewHeight/4 , width: 200, height: 100))
        let lightPlay = UIButton(frame: CGRect(x: Int(view.center.x/2), y: viewHeight/2, width: 200, height: 100))
        darkPlay.addTarget(self, action: #selector(self.onPressDark(_:)), for: UIControl.Event.touchUpInside)
        lightPlay.addTarget(self, action: #selector(self.onPressLight(_:)), for: UIControl.Event.touchUpInside)
        darkPlay.setImage(UIImage(named: "darkside"), for: .normal)
        lightPlay.setImage(UIImage(named:"lightside"), for: .normal)
        self.titleScreenView.addSubview(darkPlay)
        self.titleScreenView.addSubview(lightPlay)
        
        //Create home button
        deathstar = UIButton(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
        deathstar.addTarget(self, action: #selector(self.onPress(_:)), for: UIControl.Event.touchUpInside)
        deathstar.setImage(UIImage(named: "deathstar"), for: .normal)
        deathstar.isHidden = true
        
        //Create Info button
        questionmark = UIButton(frame: CGRect(x: view.frame.width - 50, y: 20, width: 40, height: 50))
        questionmark.addTarget(self, action: #selector(onInfoPress(_:)), for: UIControl.Event.touchUpInside)
        questionmark.setImage(UIImage(named: "lights_off"), for: .normal)
        questionmark.isHidden = true
        
        //Set info labels to disappear and reappear on touch
        infoLabel.backgroundColor = UIColor.yellow.withAlphaComponent(0.8)
        infoLabel.textAlignment = .center
        infoLabel.text = " Touch the death star to go back home 🏠"
        infoLabel.numberOfLines = 0
        infoLabel.sizeToFit()
        infoLabel.isHidden = true
        
        infoLabel2.backgroundColor = UIColor.yellow.withAlphaComponent(0.8)
        infoLabel2.textAlignment = .center
        infoLabel2.text = " Touch the boxes and guess the answer! ☝🏻"
        infoLabel2.numberOfLines = 0
        infoLabel2.sizeToFit()
        infoLabel2.isHidden = true
        
        infoLabel3.backgroundColor = UIColor.yellow
        infoLabel3.textAlignment = .center
        infoLabel3.text = " Pinch to zoom in/out if necessary 🔍"
        infoLabel3.numberOfLines = 0
        infoLabel3.sizeToFit()
        infoLabel3.isHidden = true
        
        //Create coin information view
        self.coinsImage = UIImageView(frame: CGRect(x: view.frame.width/2, y: 20, width: 50, height: 50))
        self.coinsImage.image = coinImage
        self.coinsImage.isHidden = true
        coinLabel.textAlignment = .center
        coinLabel.text = String(coins)
        coinLabel.center = CGPoint(x: view.frame.width/2 - 20, y: 50)
        coinLabel.isHidden = true
        coinLabel.textColor = UIColor.black
        self.view.addSubview(coinLabel)
        self.view.addSubview(coinsImage)
        
        //Create buy hint view
        self.buyHintView = UIImageView(frame: CGRect(x: view.frame.width/2, y: view.center.y, width: view.frame.width/1.5, height: 150))
        self.buyHintView.center.y = view.center.y
        self.buyHintView.center.x = view.center.x
        self.buyHintView.image = buyHintWarning
        self.buyHintView.isHidden = true
        
        hintButton.backgroundColor = UIColor(hex: "#6E8CD9ff")
        
        buy_no = UIButton(frame: CGRect(x: view.frame.width/2, y: self.buyHintView.center.x, width: 45, height: 60))
        buy_no.center.y = buyHintView.center.y
        buy_no.addTarget(self, action: #selector(closeHint(_:)), for: UIControl.Event.touchUpInside)
        buy_no.setTitle("No", for: .normal)
        buy_no.isHidden = true
        
        buy_yes = UIButton(frame: CGRect(x: buy_no.center.x, y: self.buyHintView.center.x, width: 40, height: 60))
        buy_yes.center.x = buyHintView.center.x - 20.0
        buy_yes.center.y = buy_no.center.y
        buy_yes.addTarget(self, action: #selector(buyHint(_:)), for: UIControl.Event.touchUpInside)
        buy_yes.setTitle("Yes", for: .normal)
        buy_yes.isHidden = true
        
        buyLabel = UILabel(frame: CGRect(x: view.frame.width/2, y: self.buyHintView.center.x, width: view.frame.width/2, height: 45))
        buyLabel.center.y = buyHintView.center.y - 40.0
        buyLabel.center.x = buyHintView.center.x + 5.0
        buyLabel.text = "Spend 100 coins on another hint? 🤑"
        buyLabel.textAlignment = .center
        buyLabel.numberOfLines = 0
        buyLabel.sizeToFit()
        buyLabel.isHidden = true
        
        self.view.addSubview(buyLabel)
        self.view.addSubview(buy_yes)
        self.view.addSubview(buy_no)
        self.view.addSubview(buyHintView)
        
        
        
        //Create gestures
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        let tapHintGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissHint))
        self.mainView.addGestureRecognizer(tapHintGesture)
        self.view.addGestureRecognizer(tapHintGesture)
        self.view.addGestureRecognizer(tapGesture)
        
        //Create view for where crossword tiles will appear
        self.boardView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 250))
        self.view.addSubview(boardView)
        createButtons()
        self.boardView.addGestureRecognizer(pinchGesture)
        self.boardView.isHidden = true
        self.view.addSubview(deathstar)
        self.view.addSubview(questionmark)
        self.view.addSubview(hintLabel)
        boardView.center.x = view.center.x
        boardView.center.y = CGFloat(Int(view.center.y) - Int(deathstar.center.y) - btnWidth)
        self.boardView.addGestureRecognizer(tapHintGesture)

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
    @objc func dismissHint (_ sender: UITapGestureRecognizer) {
        self.buyHintView.isHidden = true
        buyLabel.isHidden = true
        buy_yes.isHidden = true
        buy_no.isHidden = true
    }
    
    //Home + Info Button functionality
    @objc func onPress( _ button : UIButton){       // for death star home button
        self.hintLabel.isHidden = true
        self.titleScreenView.isHidden = false
        self.boardView.isHidden = true
        self.deathstar.isHidden = true
        self.questionmark.isHidden = true
        self.coinsImage.isHidden = true
        self.coinLabel.isHidden = true
        infoLabel2.layer.zPosition = 0
        infoLabel.layer.zPosition = 0
        infoLabel3.layer.zPosition = 0
    }
    
    @objc func onPressLight( _ button : UIButton){

        self.titleScreenView.isHidden = true
        self.boardView.isHidden = false
        self.deathstar.isHidden = false
        self.questionmark.isHidden = false
        self.coinsImage.isHidden = false
        self.coinLabel.isHidden = false
        infoLabel2.layer.zPosition = 1
        infoLabel.layer.zPosition = 1
        infoLabel3.layer.zPosition = 1
        
        self.mainView.image = lightside_bg
        mainView.contentMode =  UIView.ContentMode.scaleAspectFill
        mainView.clipsToBounds = true
        view.addSubview(mainView)
        view.sendSubviewToBack(mainView)
        
        
    }
    @objc func onPressDark( _ button : UIButton){

        self.titleScreenView.isHidden = true
        self.boardView.isHidden = false
        self.deathstar.isHidden = false
        self.questionmark.isHidden = false
        self.coinsImage.isHidden = false
        self.coinLabel.isHidden = false
        infoLabel2.layer.zPosition = 1
        infoLabel.layer.zPosition = 1
        infoLabel3.layer.zPosition = 1
        
        self.mainView.image = darkside_bg
        mainView.contentMode =  UIView.ContentMode.scaleAspectFill
        mainView.clipsToBounds = true
        view.addSubview(mainView)
        view.sendSubviewToBack(mainView)
    }
    
    @objc func onInfoPress( _ button : UIButton){       //for light bulb info button
        infoCounter += 1                                //To mimic a toggle feature
        if (infoCounter % 2 == 0){
            infoLabel.isHidden = false
            infoLabel.layer.zPosition = 1
            infoLabel2.isHidden = false
            infoLabel2.layer.zPosition = 1
            infoLabel3.isHidden = false
            infoLabel3.layer.zPosition = 1
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
                            button.hint2 = "Small in size but wise and powerful"
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
                            button.hint = "A former criminal who aids the Rebel Alliance in a desperate attempt to steal the plans to the Death Star"
                            button.hint2 = "Lyra's daughter"
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
                            button.hint = "She survived life as a slave to become a Tatooine moisture farmer"
                            button.hint2 = "Mother of Anakin Skywalker"
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
                            button.hint = "A large slug-like sentient species who were native to the planet Nal Hutta"
                            button.hint2 = "Rotund, voracious and grotesque-looking slug-like creatures with a predisposition to being involved as leaders in organized crime"
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
                            button.hint2 = "A droid programmed for etiquette and protocol, built by the heroic Jedi Anakin Skywalker"
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
                            button.hint = "Captain of the Millenium Falcon"
                            button.hint2 = "Best buddies with Chewbacca"
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
                            button.hint = "Native to AhCh-To and can be found where Jedi Master Luke Skywalker made his exile"
                            button.hint2 = "A species of non-sentient birds"
                            wordArray.append(button)
                        }
                    }
                }


                if (btn.tag == 21 || btn.tag == 28 || btn.tag == 35 || btn.tag == 42 || btn.tag == 49){
                    for index in 2 ..< 8 {                              //7 is the row
                        if let button = self.view.viewWithTag((index * 8 - index + 7)) as?  KelseyButton
                        {
                            if (button.tag == 49){
                                button.thirdWord = "porgs"
                            }
                            button.backgroundColor = UIColor(white: 1, alpha: 0.7)
                            button.word = "siths"
                            button.hint = "An order of Force-sensitive beings who use the dark side of the Force"
                            button.hint2 = "Believed that conflict was the only true test of one's ability"
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
        hintButton.isHidden = false
        currentAnswer = button.word
        hintLabel.isHidden = false
        hintLabel.text = button.hint
        secondHint = button.hint2
        hintLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        //So it's not noticeable the spaces around are buttons also
        if(button.word == ""){
            hintLabel.isHidden = true
            buyHintView.isHidden = true
            buy_yes.isHidden = true
            buy_no.isHidden = true
            buyLabel.isHidden = true
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
                coins += 10
                coinLabel.text = String(coins)
                changeButtonLabels()
                hintLabel.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            }
            numOfCorrectAnswers += 1
            if (numOfCorrectAnswers == 8){
                coins += 100
                print("You did it!")
                for i in wordArray{
                    if (i.correctAnswer == true){
                        i.backgroundColor = UIColor.green.withAlphaComponent(0.5)
                    }
                }
                hintLabel.text = "Congrats! 🎉 You earned 100 coins. More levels coming soon!"
            }
        }
        else{
            hintLabel.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            textField.text = ""
        }
        
    }
    
    //Displays confirm buy hint view
    @IBAction func pressHint(){
        buyHintView.isHidden = false
        buy_yes.isHidden = false
        buy_no.isHidden = false
        buyLabel.isHidden = false
        
        view.bringSubviewToFront(buyHintView)
        view.bringSubviewToFront(buy_yes)
        view.bringSubviewToFront(buy_no)
        view.bringSubviewToFront(buyLabel)
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
                i.correctAnswer = true
                i.isEnabled = false
            }
        }
        textField.text = ""
        answerLetters.removeAll()
       
    }
    
    @objc func buyHint( _ button : UIButton){
        if (coins - 100 < 0){
            buyLabel.text = "Sorry! Looks like you don't have enough coins 😭"
            buyLabel.textAlignment = .center
            buyLabel.numberOfLines = 0
            buyLabel.sizeToFit()
            buy_yes.isHidden = true
        }
        else{
            buyLabel.text = "Spend 100 coins on another hint? 🤑"
            coins -= 100
            coinLabel.text = String(coins)
            hintLabel.text = secondHint
            buyHintView.isHidden = true
            buy_yes.isHidden = true
            buy_no.isHidden = true
            buyLabel.isHidden = true
        }
        
    }
    
    @objc func closeHint( _ button: UIButton){
        buyLabel.text = "Spend 100 coins on another hint? 🤑"
        buyHintView.isHidden = true
        buy_yes.isHidden = true
        buy_no.isHidden = true
        buyLabel.isHidden = true
    }
    
}

