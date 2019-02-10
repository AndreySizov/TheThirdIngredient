//
//  TutorialViewController.swift
//  The Third Ingredient
//
//  Created by Sergey Korobin on 10/02/2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

import UIKit
import SwiftyGif

class TutorialViewController: UIViewController, SwiftyGifDelegate {
    @IBOutlet weak var gifImageView: UIImageView!
    var alertStop: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setGifToView()
        gifImageView.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(showStopAlert))
        self.view.addGestureRecognizer(oneTap)
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    func setTutorialWatched(){
        UserDefaults.standard.set(true, forKey: "isTutorialWatched")
    }
    
    func setGifToView(){
        gifImageView.setGifImage(UIImage(gifName: "onboarding.gif"), manager: .defaultManager, loopCount: 1)
        gifImageView.contentMode = .scaleAspectFit
    }
    
    func gifDidStop(sender: UIImageView) {
        showAlert()
    }
    
    func showAlert(){
        
        if alertStop != nil{
            
        alertStop!.dismiss(animated: true, completion: nil)
        }
        let alert = UIAlertController(title: "Обучение пройдено!", message: "Хотите повторить или перейти к чтению?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default, handler: {
            action in
            self.setGifToView()
        }))
        alert.addAction(UIAlertAction(title: "Перейти к чтению", style: UIAlertActionStyle.default, handler: {
            action in
            
            self.moveToMainVC()
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func showStopAlert(){
        self.gifImageView.stopAnimating()
        
        alertStop = UIAlertController(title: nil, message: "Хотите прервать и перейти к чтению?", preferredStyle: UIAlertControllerStyle.alert)
        alertStop!.addAction(UIAlertAction(title: "Продолжить", style: UIAlertActionStyle.default, handler: nil))
        alertStop!.addAction(UIAlertAction(title: "Перейти к чтению", style: UIAlertActionStyle.default, handler: {
            action in
            
            self.moveToMainVC()
            
        }))
        self.present(alertStop!, animated: true, completion: nil)
    }
    
    
    func moveToMainVC(){
        
        setTutorialWatched()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "ContentVC")
        self.present(nextVC, animated: true, completion: nil)
    }
}




    


