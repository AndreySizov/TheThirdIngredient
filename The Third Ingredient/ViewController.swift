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
            if(self.view.frame.size.width < 414){
                view.font = UIFont(name: "AmericanTypewriter", size: 12)
            }else{
                view.font = UIFont(name: "AmericanTypewriter", size: 16)
            }
            //        view.text = text
            
            view.text = text //(jsonData[0] as! NSDictionary)["text"]! as! String
            view.textAlignment = .justified
            self.view.addSubview(view)
            
        case .Landscape:
            
            let x = self.view.frame.origin.x + self.view.frame.size.width/45
            let y = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height + 5
            let upper_height = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height + 10
            let height = 0.93*self.view.frame.size.height - upper_height
            
            if type == "normal"{

                let width = 0.6533*self.view.frame.size.width

                
                view = UITextView(frame: CGRect(x: x, y: y, width: width, height: height))
            }else{

                let width = 0.9555*self.view.frame.size.width

                
                view = UITextView(frame: CGRect(x: x, y: y, width: width, height: height))
            }
            if(self.view.frame.size.width < 600){
                view.font = UIFont(name: "AmericanTypewriter", size: 12)
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
            let x = 0.6817*self.view.frame.size.width    //(0.955 - 0.2733)*self.view.frame.size.width
            let y = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height + 5
            let width = 0.2933*self.view.frame.size.width
//   Calculations
//            let x = 43*self.view.frame.size.width/45 - 0.3*42*self.view.frame.size.width/45
//            let width = 0.3*(44*self.view.frame.size.width/45)
            let upper_height = self.view.frame.origin.y + UIApplication.shared.statusBarFrame.height + 10
            let height = 0.93*self.view.frame.size.height - upper_height
            let view = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))

            view.image = UIImage(named:image)
            view.contentMode = .scaleAspectFit
            self.view.addSubview(view)
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
            
            let numberButton = UIButton(frame: CGRect(x: self.view.frame.size.width/2 - 25, y: 0.93*self.view.frame.size.height, width: 50, height: 0.07*self.view.frame.size.height))
            numberButton.setTitle("\(pageNumber)", for: .normal)
            numberButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 25)
            numberButton.setTitleColor(UIColor.black, for: .normal)
            self.view.addSubview(numberButton)
        }
    }
    
    func createBrackets(){
        
        let bracketUp = UIImageView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 19 + 15, width: self.view.frame.size.width, height: 30))
        bracketUp.image = UIImage(named:"bracketUp")
        bracketUp.contentMode = .scaleAspectFit
        self.view.addSubview(bracketUp)

        let bracketDown = UIImageView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.size.height - 30 - 40, width: self.view.frame.size.width, height: 30))
        bracketDown.image = UIImage(named:"bracketDown")
        bracketDown.contentMode = .scaleAspectFit
        self.view.addSubview(bracketDown)
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
            
            createBrackets()
            createButtons(pageNumber: i, state: state)
            
            if ((arrayOfContent[i-1] as! NSDictionary)["audio"] != nil){
                playMusic(array: (arrayOfContent[i-1] as! NSDictionary)["audio"]! as! [String])
            }
        case .Landscape:
            if ((arrayOfContent[i-1] as! NSDictionary)["photo"] != nil){
                addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "normal", state: state)
                addImageView(image: (arrayOfContent[i-1] as! NSDictionary)["photo"]! as! String, state: state)
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




