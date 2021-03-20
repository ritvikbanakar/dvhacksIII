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
    
    
    //For Sign Up
    var signed_up = false
    var is_done = false
    var inputArrays: [String] = []
    @IBOutlet weak var signUpBackgroundView: UIView!
    @IBOutlet weak var self_nameTF: UITextField!
    @IBOutlet weak var self_phoneTF: UITextField!
    @IBOutlet weak var friend_nameTF: UITextField!
    @IBOutlet weak var friend_phoneTF: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    //For Test
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var test1View: UIView!
    @IBOutlet weak var test1Result: UIView!
    
    @IBOutlet weak var test2View: UIView!
    @IBOutlet weak var test2Result: UIView!
    
    @IBOutlet weak var test3View: UIView!
    @IBOutlet weak var test3Result: UIView!

    @IBOutlet weak var test4View: UIView!
    @IBOutlet weak var test4Result: UIView!
    
    @IBOutlet weak var testButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if(self.signed_up){ self.show_test()  }
            else{ self.show_sign_up_sequence()  }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let sign_up_status = defaults.string(forKey: defaultsKeys.has_signed_up) {
            signed_up = true
        }
        prep_second_animation()
        if(signed_up){
            hide_everything()
        } else{
            prep_animations()
        }
        
       
    }
    
    func prep_second_animation(){
        test1View.alpha = 0
        test2View.alpha = 0
        test3View.alpha = 0
        test4View.alpha = 0
        testButton.alpha = 0
    }
    
    func prep_animations(){
        self_nameTF.alpha = 0
        self_phoneTF.alpha = 0
        doneButton.alpha = 0
        friend_phoneTF.alpha = 0
        friend_nameTF.alpha = 0
        testView.isHidden = true
    }
    
    func hide_everything(){
        self_nameTF.isHidden = true
        self_phoneTF.isHidden = true
        doneButton.isHidden = true
        friend_phoneTF.isHidden = true
        friend_nameTF.isHidden = true
        signUpBackgroundView.isHidden = true
    }
    
    func show_test(){
        var up_50_px = CGAffineTransform(translationX: 0, y: 0)
        test1View.transform = up_50_px
        test2View.transform = up_50_px
        test3View.transform = up_50_px
        test4View.transform = up_50_px
        testButton.transform = up_50_px
        let offset = 0.5
        let duration = 1.0
        
        UIView.animate(withDuration: duration, delay: 1.5, options: .curveLinear, animations: {
            self.test1View.alpha = 1
            self.test1View.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 1.5 + offset, options: .curveLinear, animations: {
            self.test2View.alpha = 1
            self.test2View.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 1.5 + offset*2, options: .curveLinear, animations: {
            self.test3View.alpha = 1
            self.test3View.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 1.5 + offset*3, options: .curveLinear, animations: {
            self.test4View.alpha = 1
            self.test4View.transform = CGAffineTransform.identity
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 1.5 + offset*4, options: .curveLinear, animations: {
            self.testButton.alpha = 1
            self.testButton.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
   
    
    func show_sign_up_sequence(){
        initial_animation()
    }
    
    func initial_animation(){
        
        var up_50_px = CGAffineTransform(translationX: 0, y: -10)
        var scale_down = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        self_nameTF.transform = up_50_px
        self_nameTF.alpha = 0
        
        self_phoneTF.transform = up_50_px
        self_phoneTF.alpha = 0
        
        doneButton.transform = scale_down
        doneButton.alpha = 0
        
        UIView.animate(withDuration: 1, animations: {
            
            self.self_nameTF.transform = CGAffineTransform.identity
            self.self_nameTF.alpha = 1
            self.doneButton.transform = CGAffineTransform.identity
            self.doneButton.alpha = 1
            self.doneButton.layer.cornerRadius = 10
            
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveLinear, animations: {
            
            self.self_phoneTF.transform = CGAffineTransform.identity
            self.self_phoneTF.alpha = 1
            
        }, completion: nil)
        
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        if(!is_done){
            var name = self_nameTF.text!
            var phone = self_phoneTF.text!
            if(name.count == 0){
                self_nameTF.shake()
                return
            }
            if(phone.count == 0){
                self_phoneTF.shake()
                return
            }
            inputArrays.append(name)
            inputArrays.append(phone)
    
            is_done = !is_done
            doneButton.setTitle("Done", for: .normal)
            shift_left()
        } else{
            var name = friend_nameTF.text!
            var phone = friend_phoneTF.text!
            if(name.count == 0){
                friend_nameTF.shake()
                return
            }
            if(phone.count == 0){
                friend_phoneTF.shake()
                return
            }
            defaults.set(inputArrays[0], forKey: defaultsKeys.self_name)
            defaults.set(inputArrays[1], forKey: defaultsKeys.self_phone)
            defaults.set(name, forKey: defaultsKeys.friend1_name)
            defaults.set(phone, forKey: defaultsKeys.friend1_phone)
            defaults.set("True", forKey: defaultsKeys.has_signed_up)
            print("Values Set to Local")
            
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveLinear, animations: {
                self.signUpBackgroundView.alpha = 0
                self.view.backgroundColor = UIColor(named: "Background Color")

            }, completion: {
                (value: Bool) in
                self.testView.isHidden = false
                self.signUpBackgroundView.isHidden = true
                self.show_test()
            })
           
//            doneButton.setTitle("Done", for: .normal)
        }
        
    }
    
    func shift_left(){
        var location_right = CGAffineTransform(translationX: 400, y: 0)
        var location_left = CGAffineTransform(translationX: -400, y: 0)
        
        friend_nameTF.transform = location_right
        friend_phoneTF.transform = location_right
        
        UIView.animate(withDuration: 2, animations: {
            self.view.backgroundColor = UIColor(named: "Background ColorV2")
            self.friend_phoneTF.backgroundColor = UIColor(named: "Background Color")
            self.friend_nameTF.backgroundColor = UIColor(named: "Background Color")
            
            self.friend_phoneTF.transform = CGAffineTransform.identity
            self.friend_nameTF.transform = CGAffineTransform.identity
            
            self.friend_phoneTF.alpha = 1
            self.friend_nameTF.alpha = 1
            
            self.self_phoneTF.transform = location_left
            self.self_nameTF.transform = location_left
            
            self.self_nameTF.alpha = 0
            self.self_phoneTF.alpha = 0
        })

    }
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
