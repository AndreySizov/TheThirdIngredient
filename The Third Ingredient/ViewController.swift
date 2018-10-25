//
//  ViewController.swift
//  BookMineCopy
//
//  Created by Sergey Korobin on 24/10/2018.
//  Copyright © 2018 Sergey Korobin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

enum AppOrientationState {
    case Portrait
    case Landscape
}

class ViewController: UIViewController {
    var arrayOfContent: [Any]!
    var presentPage = 1
    var arrayOfAudioPlayers = Array<AVAudioPlayer>()
    var orientation = AppOrientationState.Portrait
    var textViewWidthInLandscapeMode: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readJson()
    }
    
    override func viewWillLayoutSubviews() {
        getOrientation()
        createPage(i: presentPage, state: orientation)
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        for v in self.view.subviews{
            v.removeFromSuperview()
        }
    }
    
    
    func addTextView(text: String, type: String, state: AppOrientationState){
        var view = UITextView()
        switch state {
        case .Portrait:
            
            let x = self.view.frame.size.width/26
            let y = self.view.frame.origin.y + 64   //19+15+30
            let width = self.view.frame.size.width*0.923    //*24/26
            let height = self.view.frame.size.height - 134 //-19-15-60-40
            
            if type == "normal"{
                
                view = UITextView(frame: CGRect(x: x, y: y, width: width, height: 0.7*height))
            }else{
                view = UITextView(frame: CGRect(x: x, y: y, width: width, height: height))
            }
            if(self.view.frame.size.height < 667){
                view.font = UIFont(name: "AmericanTypewriter", size: 12)
            }else if (self.view.frame.size.height < 736){
                view.font = UIFont(name: "AmericanTypewriter", size: 14)
            }else{
                view.font = UIFont(name: "AmericanTypewriter", size: 16)
            }
            //        view.text = text
            
            view.text = text //(jsonData[0] as! NSDictionary)["text"]! as! String
            view.textAlignment = .justified
            self.view.addSubview(view)
            
        case .Landscape:
            if (self.view.frame.size.width <= 736){
                let x = self.view.frame.origin.x + self.view.frame.size.width/45
                let y = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height + 10
                let upper_height = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height + 10
                let height = 0.9*(self.view.frame.size.height - upper_height)
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
                let y = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height + 10
                let upper_height = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height + 10
                let height = 0.9*(self.view.frame.size.height - upper_height)
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
            if(self.view.frame.size.width < 667){
                view.font = UIFont(name: "AmericanTypewriter", size: 12)
            }else if (self.view.frame.size.width < 736){
                view.font = UIFont(name: "AmericanTypewriter", size: 14)
            }else{
                view.font = UIFont(name: "AmericanTypewriter", size: 16)
            }
            //        view.text = text
            
            view.text = text //(jsonData[0] as! NSDictionary)["text"]! as! String
            view.textAlignment = .justified
            self.view.addSubview(view)
        }
    }
    
    func addImageView(image: String, state: AppOrientationState){
        switch state{
        case .Portrait:
            
            let x = self.view.frame.size.width/26
            let height = 0.3*(self.view.frame.size.height - 134)    //-19-15-60-40
            let y = self.view.frame.size.height - 70 - height
            let width = self.view.frame.size.width*0.923    //*24/26
            
            let view = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
            view.image = UIImage(named:image)
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
                let view = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))

                view.image = UIImage(named:image)
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
                let view = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
                
                view.image = UIImage(named:image)
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
            
            let numberButton = UIButton(frame: CGRect(x: self.view.frame.size.width/2 - 25, y: self.view.frame.size.height - 40, width: 50, height: 40))
            numberButton.setTitle("\(pageNumber)", for: .normal)
            numberButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
            numberButton.setTitleColor(UIColor.black, for: .normal)
            self.view.addSubview(numberButton)
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
                
            let numberButton = UIButton(frame: CGRect(x: x, y: 0.9*self.view.frame.size.height, width: 50, height: 0.1*self.view.frame.size.height))
            numberButton.setTitle("\(pageNumber)", for: .normal)
            numberButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
            numberButton.setTitleColor(UIColor.black, for: .normal)
            self.view.addSubview(numberButton)
            }else{
                print("textView Width not found")
            }
        }
    }
    
    func createBrackets(state: AppOrientationState){
        
        switch state {
        case .Portrait:
            
            let bracketUp = UIImageView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 19 + 15, width: self.view.frame.size.width, height: 30))
            bracketUp.image = UIImage(named:"bracketUp")
            bracketUp.contentMode = .scaleAspectFit
            self.view.addSubview(bracketUp)

            let bracketDown = UIImageView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height - 30 - 40, width: self.view.frame.size.width, height: 30))
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
        
        for v in self.view.subviews{
            v.removeFromSuperview()
        }
        presentPage += 1
        createPage(i: presentPage, state: orientation)
    }
    
    @objc func previousPage(){
        
        for v in self.view.subviews{
            v.removeFromSuperview()
        }
        presentPage -= 1
        createPage(i: presentPage, state: orientation)
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
        
        switch state {
        case .Portrait:
            if ((arrayOfContent[i-1] as! NSDictionary)["photo"] != nil){
                addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "normal", state: state)
                addImageView(image: (arrayOfContent[i-1] as! NSDictionary)["photo"]! as! String, state: state)
            }else{
                addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "withoutPhoto", state: state)
            }
            
            createBrackets(state: state)
            createButtons(pageNumber: i, state: state)
            
            if ((arrayOfContent[i-1] as! NSDictionary)["audio"] != nil){
                playMusic(array: (arrayOfContent[i-1] as! NSDictionary)["audio"]! as! [String])
            }
        case .Landscape:
            if ((arrayOfContent[i-1] as! NSDictionary)["photo"] != nil){
                addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "normal", state: state)
                addImageView(image: (arrayOfContent[i-1] as! NSDictionary)["photo"]! as! String, state: state)
                createBrackets(state: state)
            }
            else{
                addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "withoutPhoto", state: state)
            }
            
            createButtons(pageNumber: i, state: state)
            
            if ((arrayOfContent[i-1] as! NSDictionary)["audio"] != nil){
                playMusic(array: (arrayOfContent[i-1] as! NSDictionary)["audio"]! as! [String])
            }
        }
    }
    
    func playMusic(array: [String]){
        
        for name in array{
            let path = Bundle.main.path(forResource: name, ofType : "mp3")!
            let url = URL(fileURLWithPath : path)
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: url)
                
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
                arrayOfAudioPlayers.append(audioPlayer)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func stopMusic(){
        for audioPlayer in arrayOfAudioPlayers{
            audioPlayer.stop()
        }
        arrayOfAudioPlayers.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}




