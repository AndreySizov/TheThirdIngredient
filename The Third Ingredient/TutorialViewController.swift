//
//  TutorialViewController.swift
//  The Third Ingredient
//
//  Created by Sergey Korobin on 10/02/2019.
//  Copyright © 2019 Андрей. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func moveToMainView(_ sender: Any) {
        
        // Run it at the end of Tutorial to save data (isTutorialWatched). Uncomment next line
        // setTutorialWatched()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "ContentVC")
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func setTutorialWatched(){
        UserDefaults.standard.set(true, forKey: "isTutorialWatched")
    }
}
