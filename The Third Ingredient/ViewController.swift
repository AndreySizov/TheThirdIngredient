//
//  ViewController.swift
//  The Third Ingredient
//
//  Created by Sergey Korobin on 24/10/2018.
//  Copyright © 2018 Sergey Korobin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SwiftyGif

enum AppOrientationState {
    case Portrait
    case Landscape
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var pickerPageTextField: UITextField!
    var picker: UIPickerView!
    
    var arrayOfContent: [Any]!
    var presentPage = 1
    var arrayOfAudioPlayers = Array<AVAudioPlayer>()
    var MainThemeAudioPlayer = AVAudioPlayer()
    var mainThemeName:String?
    var pauseThemeDuration: TimeInterval!
    var pauseSoundDuration: TimeInterval!
    var pauseTimer: Timer?
    var orientation = AppOrientationState.Portrait
    var textViewWidthInLandscapeMode: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readJson()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextPage))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(previousPage))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    func getOrientation(){
        if UIDevice.current.orientation.isPortrait{
            self.orientation = .Portrait
            print("Portrait")
        } else if UIDevice.current.orientation.isLandscape{
            self.orientation = .Landscape
            print("Landscape")
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        for v in self.view.subviews{
            v.removeFromSuperview()
        }
        getOrientation()
        createPage(i: presentPage, state: orientation)
    }
    
    
    func addTextView(text: String, type: String, state: AppOrientationState){
        var view = UITextView()
        switch state {
        case .Portrait:
            
            let x = self.view.frame.size.width/26
            let y = self.view.frame.origin.y + 64   //19+15+30
            let width = self.view.frame.size.width*0.923    //*24/26
            let height = self.view.frame.size.height - 124 //-19-15-60-40+10
            
            var extraSpaceForY = 10
            var extraSpaceForHeight = 10
            if(self.view.frame.size.height < 667){
                extraSpaceForY += 18
                extraSpaceForHeight += 26
            }else if (self.view.frame.size.height < 812){
                extraSpaceForY += 10
                extraSpaceForHeight += 10
            }
            
            if type == "normal"{
                
                view = UITextView(frame: CGRect(x: x, y: y - CGFloat(extraSpaceForY), width: width, height: 0.7*height + CGFloat(extraSpaceForHeight)))
            }else{
                view = UITextView(frame: CGRect(x: x, y: y - CGFloat(extraSpaceForY), width: width, height: height + CGFloat(extraSpaceForHeight)))
            }
            
            if(self.view.frame.size.height < 568){
                view.font = UIFont(name: "AmericanTypewriter", size: 10)
            }else if(self.view.frame.size.height < 667){
                view.font = UIFont(name: "AmericanTypewriter", size: 12)
            }else if (self.view.frame.size.height < 736){
                view.font = UIFont(name: "AmericanTypewriter", size: 14)
            }else if (self.view.frame.size.height < 896){
                view.font = UIFont(name: "AmericanTypewriter", size: 15)
            }else{
                view.font = UIFont(name: "AmericanTypewriter", size: 16)
            }
        
            
        case .Landscape:
            if (self.view.frame.size.width <= 736){
                let x = self.view.frame.origin.x + self.view.frame.size.width/45
                let y = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height
                let upper_height = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height
                let height = (self.view.frame.size.height - upper_height)
                let width = 0.9333*self.view.frame.size.width //*42/45
                
                if type == "normal"{
                    
                    textViewWidthInLandscapeMode = width*0.7
                    view = UITextView(frame: CGRect(x: x, y: y, width: width*0.7, height: height))
                }else{

                    let fullWidth = (width/42)*43
                     textViewWidthInLandscapeMode = fullWidth
                    view = UITextView(frame: CGRect(x: x, y: y, width: fullWidth, height: height))
                }
            }else{
                let x = self.view.frame.origin.x + 2*self.view.frame.size.width/45
                let y = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height
                let upper_height = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height
                let height = (self.view.frame.size.height - upper_height)
                let width = 0.8889*self.view.frame.size.width //*40/45
                
                if type == "normal"{
                    
                    textViewWidthInLandscapeMode = width*0.75
                    view = UITextView(frame: CGRect(x: x, y: y, width: width*0.75, height: height))
                }else{
                    
                    let fullWidth = (width/40)*41
                    textViewWidthInLandscapeMode = fullWidth
                    view = UITextView(frame: CGRect(x: x, y: y, width: fullWidth, height: height))
                }
            }
            
            if(self.view.frame.size.width < 568){
                view.font = UIFont(name: "AmericanTypewriter", size: 10)
            }else if(self.view.frame.size.width < 667){
                view.font = UIFont(name: "AmericanTypewriter", size: 11)
            }else if (self.view.frame.size.width < 736){
                view.font = UIFont(name: "AmericanTypewriter", size: 13)
            }else if (self.view.frame.size.width < 812){
                view.font = UIFont(name: "AmericanTypewriter", size: 15)
            }else if (self.view.frame.size.width < 896){
                view.font = UIFont(name: "AmericanTypewriter", size: 13)
            }else{
                view.font = UIFont(name: "AmericanTypewriter", size: 16)
            }
        }
        
        view.text = text //(jsonData[0] as! NSDictionary)["text"]! as! String
        view.textAlignment = .justified
        view.isEditable = false
        view.isScrollEnabled = false
        self.view.addSubview(view)
    }
    
    func addImageView(image: String, loop: Int, state: AppOrientationState){
        switch state{
        case .Portrait:
            
            let x = self.view.frame.size.width/26
            let height = 0.3*(self.view.frame.size.height - 134)    //-19-15-60-40
            let y = self.view.frame.size.height - 70 - height
            let width = self.view.frame.size.width*0.923    //*24/26
            
            let view = UIImageView(gifImage: UIImage(gifName: "\(image).gif"), manager: .defaultManager, loopCount: loop)
            if(self.view.frame.size.height < 667){
                view.frame = CGRect(x: x, y: y+8, width: width, height: height)
            }else{
                view.frame = CGRect(x: x, y: y, width: width, height: height)
            }
            view.contentMode = .scaleAspectFit
            self.view.addSubview(view)
        case .Landscape:
            
            if (self.view.frame.size.width <= 736){
                let x = 0.6978*self.view.frame.size.width
                let y = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height + 30
                let width = 0.28*self.view.frame.size.width
    //   Calculations
    //            let x = (42*self.view.frame.size.width/45)*0.7 + 2*self.view.frame.size.width/45
    //            let width = 0.3*(42*self.view.frame.size.width/45)
                let height = self.view.frame.size.height - 60
                let view = UIImageView(gifImage: UIImage(gifName: "\(image).gif"), manager: .defaultManager, loopCount: loop)

                view.frame = CGRect(x: x, y: y, width: width, height: height)
                view.contentMode = .scaleAspectFit
                self.view.addSubview(view)
            }else{
                let x = 0.7333*self.view.frame.size.width
                let y = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height + 30
                let width = 0.2222*self.view.frame.size.width
                //   Calculations
                //            let x = (40*self.view.frame.size.width/45)*0.75 + 3*self.view.frame.size.width/45
                //            let width = 0.25*(40*self.view.frame.size.width/45)

                let height = self.view.frame.size.height - 60
                let view = UIImageView(gifImage: UIImage(gifName: "\(image).gif"), manager: .defaultManager, loopCount: 1)
                
                view.frame = CGRect(x: x, y: y, width: width, height: height)
                view.contentMode = .scaleAspectFit
                self.view.addSubview(view)
            }
        }
    }
    
    func createButtons(pageNumber: Int, state: AppOrientationState){
        switch state {
        case .Portrait:
            let leftButton = UIButton(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height - 70, width: self.view.frame.size.width/2, height: 70))
            leftButton.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
            self.view.addSubview(leftButton)
            
            let rightButton = UIButton(frame: CGRect(x: self.view.frame.origin.x + self.view.frame.size.width/2, y: self.view.frame.size.height - 70, width: self.view.frame.size.width/2, height: 70))
            rightButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
            self.view.addSubview(rightButton)
            
            var y = self.view.frame.size.height
            if (self.view.frame.size.height <= 736){
                y = y - 45
                
            }else{
                y = y - 50
            }
            
            pickerPageTextField = UITextField(frame: CGRect(x: self.view.frame.size.width/2 - 25, y: y, width: 50, height: 40))
            pickerPageTextField.text = "\(pageNumber)"
            pickerPageTextField.textAlignment = .center
            pickerPageTextField.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
            pickerPageTextField.textColor = UIColor.black
            pickerPageTextField.addTarget(self, action: #selector(showPickerView), for: .editingDidBegin)
            self.view.addSubview(pickerPageTextField)
        case .Landscape:
            let leftButton = UIButton(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width/5, height: self.view.frame.size.height))
            leftButton.addTarget(self, action: #selector(previousPage), for: .touchUpInside)
            self.view.addSubview(leftButton)
            
            let rightButton = UIButton(frame: CGRect(x: 0.8*self.view.frame.size.width, y: self.view.frame.origin.y, width: self.view.frame.size.width/5, height: self.view.frame.size.height))
            rightButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
            self.view.addSubview(rightButton)
            
            if textViewWidthInLandscapeMode != nil{
                
                var x = self.view.frame.size.width/45
                    x += textViewWidthInLandscapeMode!/2
                    x -= 25
                var y = self.view.frame.size.height
                if (self.view.frame.size.width <= 736){
                    y = 0.9*y
                    
                }else{
                    y = 0.88*y
                }
                pickerPageTextField = UITextField(frame: CGRect(x: x, y: y, width: 50, height: 0.1*self.view.frame.size.height))
                pickerPageTextField.text = "\(pageNumber)"
                pickerPageTextField.textAlignment = .center
                pickerPageTextField.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
                pickerPageTextField.textColor = UIColor.black
                pickerPageTextField.addTarget(self, action: #selector(showPickerView), for: .editingDidBegin)
                self.view.addSubview(pickerPageTextField)
            }else{
                print("textView Width not found")
            }
        }
    }
    
    func createBrackets(state: AppOrientationState){
        
        switch state {
        case .Portrait:
            
            var heightForBracket = 30
            var extraSpaceUp = 5
            var extraSpaceDown = 0
            if(self.view.frame.size.height < 667){
                heightForBracket = 22
                extraSpaceDown = 8
            }else if (self.view.frame.size.height >= 812){
                extraSpaceUp = 15
            }
            
            let bracketUp = UIImageView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 19 + CGFloat(extraSpaceUp), width: self.view.frame.size.width, height: CGFloat(heightForBracket)))
            bracketUp.image = UIImage(named:"bracketUp")
            bracketUp.contentMode = .scaleAspectFit
            self.view.addSubview(bracketUp)
            
            let bracketDown = UIImageView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height - 30 - 40 + CGFloat(extraSpaceDown), width: self.view.frame.size.width, height: CGFloat(heightForBracket)))
            bracketDown.image = UIImage(named:"bracketDown")
            bracketDown.contentMode = .scaleAspectFit
            self.view.addSubview(bracketDown)
            
        case .Landscape:
            
            var x = self.view.frame.size.width
            var width = self.view.frame.size.width
            
            if (self.view.frame.size.width <= 736){
                x = 0.6978*x
                width = 0.28*width
                //   Calculations
                //            let x = (42*self.view.frame.size.width/45)*0.7 + 2*self.view.frame.size.width/45
                //            let width = 0.3*(42*self.view.frame.size.width/45)
            }else{
                x = 0.7333*x
                width = 0.2222*width
                //   Calculations
                //            let x = (40*self.view.frame.size.width/45)*0.75 + 3*self.view.frame.size.width/45
                //            let width = 0.25*(40*self.view.frame.size.width/45)
            }
            

            let bracketUp = UIImageView(frame: CGRect(x: x, y: self.view.frame.origin.y, width: width, height: 30))
            bracketUp.image = UIImage(named:"bracketUp")
            bracketUp.contentMode = .scaleAspectFit
            self.view.addSubview(bracketUp)
            
            let bracketDown = UIImageView(frame: CGRect(x: x, y: self.view.frame.size.height - 30, width: width, height: 30))
            bracketDown.image = UIImage(named:"bracketDown")
            bracketDown.contentMode = .scaleAspectFit
            self.view.addSubview(bracketDown)
            
        }
        
    }
    
    
    @objc func nextPage(){
        
        if(presentPage < arrayOfContent.count){
            for v in self.view.subviews{
                v.removeFromSuperview()
            }
            presentPage += 1
            createPage(i: presentPage, state: orientation)
        }else{
            let alert = UIAlertController(title: "Книга завершена!", message: "Хотите вернуться в начало?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.default, handler: {
                action in
                self.presentPage = 1
                for v in self.view.subviews{
                    v.removeFromSuperview()
                }
                self.createPage(i: self.presentPage, state: self.orientation)
            }))
            alert.addAction(UIAlertAction(title: "Нет", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func previousPage(){
        
        if(presentPage > 1){
            presentPage -= 1
            for v in self.view.subviews{
                v.removeFromSuperview()
            }
        
            createPage(i: presentPage, state: orientation)
        }
    }
    
    func readJson(){
        if let filePath = Bundle.main.path(forResource: "BookJson", ofType: "json"),
            let data = NSData(contentsOfFile: filePath) {
            do {
                
                let jsonData = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [Any]
                //                print((jsonData[0] as! NSDictionary)["id"]!)
                arrayOfContent = jsonData
            }
            catch {
                //Handle error
            }
        }
    }
    
    func createPage(i:Int, state:AppOrientationState){
        stopMusic()
        
        if pauseTimer != nil {
            if pauseThemeDuration != nil {
                pauseThemeDuration = nil
            }
        }
        
        switch state {
        case .Portrait:
            if ((arrayOfContent[i-1] as! NSDictionary)["photo"] != nil){
                addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "normal", state: state)
                addImageView(image: (arrayOfContent[i-1] as! NSDictionary)["photo"]! as! String, loop:(arrayOfContent[i-1] as! NSDictionary)["loop"]! as! Int, state: state)
            }else{
                addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "withoutPhoto", state: state)
            }
            
            createBrackets(state: state)
            createButtons(pageNumber: i, state: state)
    
        case .Landscape:
            if ((arrayOfContent[i-1] as! NSDictionary)["photo"] != nil){
                addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "normal", state: state)
                addImageView(image: (arrayOfContent[i-1] as! NSDictionary)["photo"]! as! String, loop:(arrayOfContent[i-1] as! NSDictionary)["loop"]! as! Int, state: state)
                createBrackets(state: state)
            }
            else{
                addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "withoutPhoto", state: state)
            }
            
            createButtons(pageNumber: i, state: state)
        }
        
        if ((arrayOfContent[i-1] as! NSDictionary)["audio-theme"] != nil){
            let audioTheme = (arrayOfContent[i-1] as! NSDictionary)["audio-theme"]! as! [String]
            for item in audioTheme{
                if item.contains("pause"){
                    let pauseStr = item.split(separator: "|")
                    pauseThemeDuration = Double(Int(pauseStr[1])!)
                    continue
                } else {
                    if (self.mainThemeName == nil){
                        self.mainThemeName = item
                        playMusic(sound: item, isItMainTheme: true)
                    }else if (item != self.mainThemeName){
                        self.MainThemeAudioPlayer.stop()
                        self.mainThemeName = item
                        playMusic(sound: item, isItMainTheme: true)
                    } else {
                        // there -> item == self.mainThemeName && self.mainThemeName != nil
                        if (pauseTimer != nil){
                            // case if user moving from page with timer (to that point of time it is not fired) to the page with the same maintheme
                            pauseTimer?.invalidate()
                            pauseTimer = nil
                            playMusic(sound: item, isItMainTheme: true)
                        } else if (pauseThemeDuration != nil && pauseThemeDuration > 0.0){
                            // case if user moving from page with no timer to page with timer and with the same maintheme
                            playMusic(sound: item, isItMainTheme: true)
                            
                        }
                    }
                }
            }
            
        }else{
            if (self.mainThemeName != nil){
            self.MainThemeAudioPlayer.stop()
            }
            self.mainThemeName = nil
        }
        
        if ((arrayOfContent[i-1] as! NSDictionary)["audio-sounds"] != nil){
            let audioSounds = (arrayOfContent[i-1] as! NSDictionary)["audio-sounds"] as! [String]
            for item in audioSounds{
                if item.contains("pause"){
                    let pauseStr = item.split(separator: "|")
                    pauseSoundDuration = Double(Int(pauseStr[1])!)
                    continue
                } else {
                    playMusic(sound: item, isItMainTheme: false)
                }
            }
        }
    }
    
    func playMusic(sound: String, isItMainTheme: Bool){
    
        let path = Bundle.main.path(forResource: sound, ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            if (isItMainTheme == false){
                if pauseSoundDuration != nil && pauseSoundDuration > 0.0 {
                    audioPlayer.prepareToPlay()
                    audioPlayer.play(atTime: audioPlayer.deviceCurrentTime + pauseSoundDuration)
                    pauseSoundDuration = nil
                } else {
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                }
                arrayOfAudioPlayers.append(audioPlayer)
            }else{
                if pauseThemeDuration != nil && pauseThemeDuration > 0.0 {
                    audioPlayer.prepareToPlay()
                    audioPlayer.play(atTime: audioPlayer.deviceCurrentTime + pauseThemeDuration)
                    // setting up timer
                    pauseTimer = Timer.scheduledTimer(timeInterval: pauseThemeDuration, target: self, selector: #selector(refreshPauseTimerAction), userInfo: nil, repeats: false)
                } else {
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                }
                audioPlayer.numberOfLoops = 10
                self.MainThemeAudioPlayer = audioPlayer
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopMusic(){
        for audioPlayer in arrayOfAudioPlayers{
            audioPlayer.stop()
        }
        arrayOfAudioPlayers.removeAll()
    }
    
    @objc func refreshPauseTimerAction(){
        pauseThemeDuration = nil
        pauseTimer = nil
    }
    
    //
    // Picker view section
    //
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfContent.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let id = (arrayOfContent[row] as! NSDictionary)["id"]!
        return String(describing: id)
    }
    
    @objc func showPickerView(){
        picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(presentPage - 1, inComponent: 0, animated: false)
        pickerPageTextField.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Перейти", style: .done, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        pickerPageTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        let row = picker.selectedRow(inComponent: 0)
        pickerPageTextField.resignFirstResponder()
        let id = (arrayOfContent[row] as! NSDictionary)["id"]!
        
        presentPage = id as! Int
        print("Done. Picker Page = \(presentPage)")
        for v in self.view.subviews{
            v.removeFromSuperview()
        }
        createPage(i: presentPage, state: orientation)
        
    }
    @objc func cancelClick() {
        pickerPageTextField.resignFirstResponder()
        print("Cancel in Picker view")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}




