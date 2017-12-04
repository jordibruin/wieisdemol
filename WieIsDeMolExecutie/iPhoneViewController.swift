//
//  iPhoneViewController.swift
//  WieIsDeMolExecutie
//
//  Created by Jordi Bruin on 15/10/2017.
//  Copyright © 2017 Jordi Bruin. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

extension UIColor {
    convenience init(rgba: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        let scanner = Scanner(string: rgba)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            if rgba.characters.count == 6 {
                red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                blue  = CGFloat(hexValue & 0x0000FF) / 255.0
            } else if rgba.characters.count == 8 {
                alpha   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                red = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                green  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                blue = CGFloat(hexValue & 0x000000FF)         / 255.0
            } else {
                print("invalid rgb string, length should be 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}


class iPhoneViewController: UIViewController {
    
    let kandidaten = ["Tim", "Ernst", "Vince", "Teun", "Tobias", "Dolf", "Wout", "Nick", "Jordi", "Maikel"]
    
    lazy var textField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 4
        tf.backgroundColor = .white
        tf.textColor = .black
        tf.delegate = self
 
        let placeholderString = NSAttributedString(string: "Kandidaat", attributes: [NSForegroundColorAttributeName:UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)])
        tf.attributedPlaceholder = placeholderString
        
        tf.layer.shadowColor = UIColor.black.cgColor
        tf.layer.shadowOpacity = 0.15
        tf.layer.shadowRadius = 8
        tf.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 40)
        return tf
    }()
    
    let fishImageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "icon_fish")
        iv.backgroundColor = .clear
        return iv
    }()
    
    
    lazy var nameButton : UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(rgba: "FF9901")
        button.layer.cornerRadius = 20
        button.setTitle("Controleer kandidaat", for: .normal)
        button.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        button.alpha = 0.3
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        return button
    }()
    
    let connectedView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .red
        view.alpha = 1
        
        view.layer.cornerRadius = 5
        return view
    }()
    
    let mpManager = MPManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
        
        mpManager.delegate = self
        
        view.backgroundColor = .white
        view.addSubview(fishImageView)
        view.addSubview(textField)
        textField <- [
            Top(40).to(fishImageView, .bottom),
            Left(20),
            Right(20),
            Height(58)
        ]
        
        view.addSubview(nameButton)
        nameButton <- [
            Top(20).to(textField, .bottom),
            Left(60),
            Right(60),
            Height(40)
        ]
        
        
        fishImageView <- [
            Top(60),
            Size(300),
            CenterX()
        ]
        
        view.addSubview(connectedView)
        connectedView <- [
            Right(12),
            Top(24),
            Size(10)
        ]
    }
    
    @objc func backgroundTapped(){
        print("background tapped")
        self.textField.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func confirm(){
        guard let input = self.textField.text else { return }
        
        // If name is not typed in correctly
        if !kandidaten.contains(input) {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.08
            animation.repeatCount = 3
            animation.autoreverses = true
            
            animation.fromValue = NSValue(cgPoint: CGPoint(x: nameButton.center.x - 6, y: nameButton.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x:nameButton.center.x + 6, y: nameButton.center.y))
            
            nameButton.layer.add(animation, forKey: "position")
            
        } else {
            mpManager.confirm()
            self.textField.text = ""
        }
    }
    
    
}

extension iPhoneViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        
        if kandidaten.contains(text + string) {
            print("KANDIDAAT FOUND")
            nameButton.isEnabled = true
            nameButton.alpha = 1
        } else {
            nameButton.isEnabled = false
            nameButton.alpha = 0.3
        }
        
        if range.length == 1 {
            print(text)
        } else {
            print(text + string)
            
            
        }
        if newLength == 0 {
            mpManager.send(colorName: "CLEARRRR")
        } else {
            let fullString = text + string
            mpManager.send(colorName: fullString)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // update constraints
        fishImageView <- [
            Top(-100),
            Size(300),
            CenterX()
        ]
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // update constraints
        fishImageView <- [
            Top(60),
            Size(300),
            CenterX()
        ]
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension iPhoneViewController : ColorServiceManagerDelegate {
    func connected() {
        connectedView.backgroundColor = .green
    }
    
    func disconnected() {
        connectedView.backgroundColor = .orange
    }
    
    func confirmUser(manager: MPManager) {
        //
    }
    
    
    func connectedDevicesChanged(manager: MPManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
//            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }
    
    func colorChanged(manager: MPManager, colorString: String) {
        OperationQueue.main.addOperation {
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
