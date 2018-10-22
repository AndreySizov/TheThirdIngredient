//
//  ViewController.swift
//  The Third Ingredient
//
//  Created by Андрей on 02.10.2018.
//  Copyright © 2018 Андрей. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    var arrayOfContent = Array<Any>()
    var presentPage = 1
    var arrayOfAudioPlayers = Array<AVAudioPlayer>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readJson()
        createPage(i: presentPage)

    }
    
    func addTextView(text: String, type: String){
        var view = UITextView()
        if type == "normal"{
            view = UITextView(frame: CGRect(x: self.view.frame.origin.x + self.view.frame.size.width/26, y: self.view.frame.origin.y + 19 + 15 + 30, width: 24*self.view.frame.size.width/26, height: 0.7*(self.view.frame.size.height - 19 - 15 - 60 - 40)))
        }else{
            view = UITextView(frame: CGRect(x: self.view.frame.origin.x + self.view.frame.size.width/26, y: self.view.frame.origin.y + 19 + 15 + 30, width: 24*self.view.frame.size.width/26, height: self.view.frame.size.height - 19 - 15 - 60 - 40))
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
    }
    
    func addImageView(image: String){
        let view = UIImageView(frame: CGRect(x: self.view.frame.origin.x + self.view.frame.size.width/26, y: self.view.frame.size.height - 30 - 40 - 0.3*(self.view.frame.size.height - 19 - 15 - 60 - 40), width: 24*self.view.frame.size.width/26, height: 0.3*(self.view.frame.size.height - 19 - 15 - 60 - 40)))
        view.image = UIImage(named:image)
        view.contentMode = .scaleAspectFit
        self.view.addSubview(view)
    }
    
    func createButtons(pageNumber: Int){
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
        createPage(i: presentPage)
    }
    
    @objc func previousPage(){
        
        for v in self.view.subviews{
            v.removeFromSuperview()
        }
        presentPage -= 1
        createPage(i: presentPage)
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
    
    func createPage(i:Int){
        stopMusic()
        
        if ((arrayOfContent[i-1] as! NSDictionary)["photo"] != nil){
            addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "normal")
            addImageView(image: (arrayOfContent[i-1] as! NSDictionary)["photo"]! as! String)
        }else{
            addTextView(text: (arrayOfContent[i-1] as! NSDictionary)["text"]! as! String, type: "withoutPhoto")
        }
        
        createBrackets()
        createButtons(pageNumber: i)
        
        if ((arrayOfContent[i-1] as! NSDictionary)["audio"] != nil){
            playMusic(array: (arrayOfContent[i-1] as! NSDictionary)["audio"]! as! [String])
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

