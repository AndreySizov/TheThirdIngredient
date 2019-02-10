//
//  LaunchViewController.swift
//  The Third Ingredient
//
//  Created by Sergey Korobin on 07/02/2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    var presentViewTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        createUpperLabel()
        createImage()
        createLowerText()
        
        let tutorialStatus: Bool = UserDefaults.standard.bool(forKey: "isTutorialWatched")
        
        if presentViewTimer == nil {
            if tutorialStatus{
                presentViewTimer = Timer.scheduledTimer(timeInterval: 6.5, target: self, selector: #selector(moveToMainVC), userInfo: nil, repeats: false)
            } else {
                presentViewTimer = Timer.scheduledTimer(timeInterval: 6.5, target: self, selector: #selector(moveToTutorialVC), userInfo: nil, repeats: false)
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    func createUpperLabel(){
        let upperLabel = UILabel()
       
        let x = self.view.frame.origin.x
        let y = self.view.frame.origin.y
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height * 0.18
        
        upperLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        
        if(self.view.frame.size.height < 568){
            upperLabel.font = UIFont(name: "WiGuru4", size: 26)
        }else if(self.view.frame.size.height < 667){
            upperLabel.font = UIFont(name: "WiGuru4", size: 28)
        }else if (self.view.frame.size.height < 736){
            upperLabel.font = UIFont(name: "WiGuru4", size: 29)
        }else if (self.view.frame.size.height < 896){
            upperLabel.font = UIFont(name: "WiGuru4", size: 31)
        }else{
            // iPads resolutions
            if (self.view.frame.size.height < 1112){
                // lot of ipads
                upperLabel.font = UIFont(name: "WiGuru4", size: 55)
            } else if (self.view.frame.size.height < 1194){
                //ipad pro 10.5 inch
                upperLabel.font = UIFont(name: "WiGuru4", size: 58)
            } else if (self.view.frame.size.height < 1366){
                //ipad pro 11 inch
                upperLabel.font = UIFont(name: "WiGuru4", size: 60)
            } else {
                // ipad pro 12.9 inch
                upperLabel.font = UIFont(name: "WiGuru4", size: 62)
            }
        }
  
        upperLabel.text = "О. Генри"
        upperLabel.textAlignment = .center
        self.view.addSubview(upperLabel)
    }
    
    
    func createImage(){
        let imageView = UIImageView()
        
        let x = self.view.frame.origin.x
        let y = self.view.frame.origin.y + self.view.frame.size.height * 0.18
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height * 0.55
        
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        imageView.image = UIImage(named: "launchPic")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
    }
    
    func createLowerText(){
        
        let lowerTextView = UITextView()
        let x = self.view.frame.origin.x
        let y = self.view.frame.size.height * 0.728
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height * 0.272
        
        lowerTextView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        if(self.view.frame.size.height < 568){
            lowerTextView.text = "\tТРЕТИЙ\n \t\tИНГРЕДИЕНТ"
            lowerTextView.font = UIFont(name: "lazer84 [RUS by Daymarius]", size: 32)
        }else if(self.view.frame.size.height < 667){
            lowerTextView.text = "\tТРЕТИЙ\n \t\tИНГРЕДИЕНТ"
            lowerTextView.font = UIFont(name: "lazer84 [RUS by Daymarius]", size: 34)
        }else if (self.view.frame.size.height < 736){
            lowerTextView.text = "\t\t\tТРЕТИЙ\n \t\t\t\tИНГРЕДИЕНТ"
            lowerTextView.font = UIFont(name: "lazer84 [RUS by Daymarius]", size: 35)
        }else if (self.view.frame.size.height < 896){
            lowerTextView.text = "\t\t\tТРЕТИЙ\n \t\t\t\tИНГРЕДИЕНТ"
            lowerTextView.font = UIFont(name: "lazer84 [RUS by Daymarius]", size: 37)
        }else{
             // iPads resolutions
            if (self.view.frame.size.height < 1112){
                // lot of ipads
                lowerTextView.text = "\t\t\t\t\t\tТРЕТИЙ\n \t\t\t\t\t\t\t\tИНГРЕДИЕНТ"
                lowerTextView.font = UIFont(name: "lazer84 [RUS by Daymarius]", size: 60)
            } else if (self.view.frame.size.height < 1194){
                //ipad pro 10.5 inch
                lowerTextView.text = "\t\t\t\t\t\tТРЕТИЙ\n \t\t\t\t\t\t\t\tИНГРЕДИЕНТ"
                lowerTextView.font = UIFont(name: "lazer84 [RUS by Daymarius]", size: 65)
            } else if (self.view.frame.size.height < 1366){
                //ipad pro 11 inch
                lowerTextView.text = "\t\t\t\t\t\tТРЕТИЙ\n \t\t\t\t\t\t\t\tИНГРЕДИЕНТ"
                lowerTextView.font = UIFont(name: "lazer84 [RUS by Daymarius]", size: 70)
            } else {
                // ipad pro 12.9 inch
                lowerTextView.text = "\t\t\t\t\t\t\t\t\tТРЕТИЙ\n \t\t\t\t\t\t\t\t\t\t\tИНГРЕДИЕНТ"
                lowerTextView.font = UIFont(name: "lazer84 [RUS by Daymarius]", size: 75)
            }
        }
        
        lowerTextView.textAlignment = .justified
        lowerTextView.backgroundColor = UIColor.clear
        lowerTextView.isEditable = false
        lowerTextView.isSelectable = false
        lowerTextView.isScrollEnabled = false
        self.view.addSubview(lowerTextView)
    }
    
    @objc func moveToMainVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "ContentVC")
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func moveToTutorialVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "TutorialVC")
        self.present(nextVC, animated: true, completion: nil)
    }

}
