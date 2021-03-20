//
//  ViewController.swift
//  DVHacks3
//
//  Created by Sid on 3/19/21.
//

import UIKit

struct defaultsKeys {
    static let self_name = "self_name"
    static let self_phone = "self_phone"
    static let friend1_name = "friend1_name"
    static let friend1_phone = "friend1_phone"
    static let has_signed_up = "has_signed_up"
}

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    var signed_up = false
    
    @IBOutlet weak var self_nameLabel: UILabel!
    @IBOutlet weak var self_nameTF: UITextField!
    @IBOutlet weak var self_phoneTF: UITextField!
    @IBOutlet weak var self_phone: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sign_up_status = defaults.string(forKey: defaultsKeys.has_signed_up) {
            signed_up = true
        }
        
        if(signed_up){
            show_greeting()
        } else{
            show_sign_up_sequence()
        }
        
        print(signed_up)
    }
    
    
    func show_greeting(){
        
    }
    
    func show_sign_up_sequence(){
        initial_animation()
    }
    
    func initial_animation(){
        var up_50_px = CGAffineTransform(translationX: 0, y: -50)
        self_nameLabel.transform = up_50_px
        self_nameLabel.alpha = 0
        
        self_nameTF.transform = up_50_px
        self_nameTF.alpha = 0
        
        self_phone.transform = up_50_px
        self_phone.alpha = 0
        
        self_phoneTF.transform = up_50_px
        self_phoneTF.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.self_nameLabel.transform = CGAffineTransform.identity
            self.self_nameLabel.alpha = 1
            
            self.self_nameTF.transform = CGAffineTransform.identity
            self.self_nameTF.alpha = 1
            
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveLinear, animations: {
            self.self_phone.transform = CGAffineTransform.identity
            self.self_phone.alpha = 1
            
            self.self_phoneTF.transform = CGAffineTransform.identity
            self.self_phoneTF.alpha = 1
        }, completion: nil)
        
        
        
        
    }


}

