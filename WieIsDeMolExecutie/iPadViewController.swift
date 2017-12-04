//
//  iPadViewController.swift
//  WieIsDeMolExecutie
//
//  Created by Jordi Bruin on 15/10/2017.
//  Copyright © 2017 Jordi Bruin. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import AVFoundation

class iPadViewController: UIViewController {
    
    var afvaller = ["Teun", "Vince", "Wout", "Ernst"]
    let kandidaten = ["Tim", "Ernst", "Vince", "Teun", "Tobias", "Dolf", "Wout", "Nick"]
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .black
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 320)
        return label
    }()
    
    lazy var connectedView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .red
        view.alpha = 0.2
        
        view.layer.cornerRadius = 5
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(connectedTapped))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    func connectedTapped(){
        let controller = UIAlertController(title: "test", message: "Test2", preferredStyle: .alert)
        
        for kandidaat in kandidaten {
            let action = UIAlertAction(title: kandidaat, style: .default) { (action) in
//                self.afvaller = kandidaat
                print("afvaller is nu: \(self.afvaller)")
            }
            controller.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //self.dismiss(animated: true, completion: nil)
        }
        controller.addAction(cancelAction)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    let mpManager = MPManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        startRandomTimer()
        
        mpManager.delegate = self
        
        view.backgroundColor = .orange
        view.addSubview(imageView)
        imageView <- Edges()
        
        view.addSubview(nameLabel)
        nameLabel <- [
            CenterX(),
            CenterY(),
//            Height(100)
        ]
        
        view.addSubview(connectedView)
        connectedView <- [
            Right(20),
            Bottom(20),
            Size(10)
        ]
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startRandomTimer(){
        print("start random")
        let diceRoll = Int(arc4random_uniform(2)+9)
        
        self.nameLabel.alpha = 0
        startPlayingSong()
        perform(#selector(showScreen), with: nil, afterDelay: TimeInterval(diceRoll))
    }
    
    @objc func showScreen(){
        print("show screen")
        
        if afvaller.contains(nameLabel.text!) {
        
//        if nameLabel.text == afvaller {
            playWarning(green: false)
            nameLabel.text = ""
            imageView.image = #imageLiteral(resourceName: "rood")
        } else {
            playWarning(green: true)
            nameLabel.text = ""
            imageView.image = #imageLiteral(resourceName: "groen")
        }
    }
    
    
    var player: AVAudioPlayer?
    
    func startPlayingSong(){
        guard let url = Bundle.main.url(forResource: "long1", withExtension: "wav") else {
            print("could not find test2.mp3")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playWarning(green: Bool){
        var url : URL?
        if green {
            url = Bundle.main.url(forResource: "groen", withExtension: "wav")
        } else {
            url = Bundle.main.url(forResource: "rood", withExtension: "wav")
        }
            
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url!)
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}


extension iPadViewController : ColorServiceManagerDelegate {
    func connected() {
        connectedView.backgroundColor = .green
    }
    
    func disconnected() {
        connectedView.backgroundColor = .red
    }
    
    func confirmUser(manager: MPManager) {
        print("confirming on ipaD")
        
        DispatchQueue.main.async(execute: {
            
            self.startRandomTimer()
        })
    }
    
    
    func connectedDevicesChanged(manager: MPManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            //self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }

    func colorChanged(manager: MPManager, colorString: String) {
        OperationQueue.main.addOperation {
            print("IPAD")
            self.imageView.backgroundColor = .black
            self.imageView.image = nil
            self.nameLabel.alpha = 1
            if colorString == "CLEARRRR" {
                self.nameLabel.text = ""
            } else {
                self.nameLabel.text = colorString
            }
//            switch colorString {
            
//            case "red":
//                self.change(color: .red)
//            case "yellow":
//                self.change(color: .yellow)
//            default:
//                NSLog("%@", "Unknown color value received: \(colorString)")
//            }
        }
    }
    
}
