//
//  ViewController.swift
//  WieIsDeMolExecutie
//
//  Created by Jordi Bruin on 15/10/2017.
//  Copyright © 2017 Jordi Bruin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .black
        return iv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            // is iPAd
            let controller = iPadViewController()
            present(controller, animated: false, completion: nil)
        } else {
            // is iPhone
            let controller = iPhoneViewController()
            present(controller, animated: true, completion: nil)
        }
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func startRandomTimer(){
        print("start random")
        let diceRoll = Int(arc4random_uniform(10))
        
        perform(#selector(showScreen), with: nil, afterDelay: TimeInterval(diceRoll))
    }
    
    @objc func showScreen(){
        print("show screen")
        
        
        imageView.image = #imageLiteral(resourceName: "groen")
        
    }
    
}

