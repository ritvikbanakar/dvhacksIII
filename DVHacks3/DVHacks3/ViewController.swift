//
//  ViewController.swift
//  DVHacks3
//
//  Created by Sid on 3/19/21.
//

import UIKit

//Keys to access user defaults (local iPhone storage)
struct defaultsKeys {
    static let self_name = "self_name"
    static let self_phone = "self_phone"
    static let friend1_name = "friend1_name"
    static let friend1_phone = "friend1_phone"
    static let has_signed_up = "has_signed_up"
}

class ViewController: UIViewController, TimeTestResultDelegate, SpinARTestResult, DilationTestResult {
    
    let defaults = UserDefaults.standard //instatiation of user defaults
    
    //For Sign Up
    var signed_up = false //Boolean: whether the user has signed up or not, if the user has signed up, we will be able to skip the sign up and go straight to taking the test
    var is_done = false //Boolean: Whether the user is done signing up. Once the user is done signing up we will continue on to the next screen (intoxication tests)
    var inputArrays: [String] = [] //Arrays to store sign up data
    
    //For Sign up animations
    @IBOutlet weak var signUpBackgroundView: UIView! //The sign up background view is the parent view that houses all sign up elements (buttons, labels, textfields)
    @IBOutlet weak var self_nameTF: UITextField! // The name of the user using the application
    @IBOutlet weak var self_phoneTF: UITextField! //The phone number of the user using the application
    @IBOutlet weak var friend_nameTF: UITextField! //The name of the user's friend
    @IBOutlet weak var friend_phoneTF: UITextField! //The phone number of the user's friend
    @IBOutlet weak var doneButton: UIButton! //Button to move forward with the sign up process
    @IBOutlet weak var promptLabel: UILabel! //Instruction label
    
    //For Test
    @IBOutlet weak var testView: UIView! //The parent view that houses all test elements
    
    @IBOutlet weak var test1View: UIView! //Long rectangle that holds the name of the test and the test result
    @IBOutlet weak var test1Result: UIView! //Square that shows the result of the first test
    
    @IBOutlet weak var test2View: UIView! //Same as test1View and test1Result
    @IBOutlet weak var test2Result: UIView!
    
    @IBOutlet weak var test3View: UIView! //Same as test1View and test1Result
    @IBOutlet weak var test3Result: UIView!
    
    @IBOutlet weak var testButton: UIButton! //Button to continue with tests, and get results.
    
    
    //For Test Completion, decides whether the tests are complete or not
    var test1Complete = false
    var test2Complete = false
    var test3Complete = false
    var result = 0 //Integer that will decide whether the person is intoxicated or not. Any test fail will decrease the result by 1, and a pass will increase the result by 1.
    //A negative result means intoxicated, while a positive result is not intoxicated
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() //hides the keyboard when the user taps on the screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { //Waits for 1.5 seconds to continue with animations
            if(self.signed_up){ self.show_test()  } //If the user as signed up, we're gonna show the tests and skip the sign up sequence
            else{ self.show_sign_up_sequence()  } //If the user hasn't signed up we are going to show the sign up sequence and then the tests.
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) { //This function is called before the view is shown, so we can do some background work to decide what to show
        super.viewWillAppear(animated)
        if let sign_up_status = defaults.string(forKey: defaultsKeys.has_signed_up) { //Checks stored data to see if the user has signed up
            signed_up = true
        }
        prep_second_animation() //Preps the test animations, regardless of whether it is first or not
        if(signed_up){ //Decide what action to take depending on whether the user has signed up or not
            hide_everything()
        } else{
            prep_animations()
        }
        
       
    }
    
    //Makes all test elements invisible by turning the alpha to 0
    func prep_second_animation(){
        test1View.alpha = 0
        test2View.alpha = 0
        test3View.alpha = 0
        testButton.alpha = 0
    }
    
    //Preps the sign up animation by turning all the alpha values to 0, so we can use animations to bring them back
    func prep_animations(){
        self_nameTF.alpha = 0
        self_phoneTF.alpha = 0
        doneButton.alpha = 0
        friend_phoneTF.alpha = 0
        friend_nameTF.alpha = 0
        testView.isHidden = true
    }
    
    //If the user has signed up we will hide everything that is related to the sign up so we effectively skip this step
    func hide_everything(){
        self_nameTF.isHidden = true
        self_phoneTF.isHidden = true
        doneButton.isHidden = true
        friend_phoneTF.isHidden = true
        friend_nameTF.isHidden = true
        signUpBackgroundView.isHidden = true
    }
    
    //This is where we will show the test views using animations
    func show_test(){
        let offset = 0.5 //Animation offset to make each small view appear a little after the one prior to it.
        let duration = 1.0 //Duration of each animation
        
        //Animations, turn the alpha to 1 to make it seem like they are "floating in"
        UIView.animate(withDuration: duration, delay: 1, options: .curveLinear, animations: {
            self.test1View.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 1 + offset, options: .curveLinear, animations: {
            self.test2View.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 1 + offset*2, options: .curveLinear, animations: {
            self.test3View.alpha = 1
            
        }, completion: nil)
        
        
        UIView.animate(withDuration: duration, delay: 1 + offset*3, options: .curveLinear, animations: {
            self.testButton.alpha = 1
            
        }, completion: nil)
        
    }
   
    //To show the sign up sequence we will need to show the initial animation.
    func show_sign_up_sequence(){
        initial_animation()
    }
    
    //The initial animation will allow everything to "glide" down very slowly
    func initial_animation(){
        
        var up_10_px = CGAffineTransform(translationX: 0, y: -10) //Decides how much each item is gliding down
        var scale_down = CGAffineTransform(scaleX: 0.95, y: 0.95) //The buttn will have a "zoom in" effect which is done by scaling it down and then scaling it up
        
        //Applying the transformations to the objects
        self_nameTF.transform = up_10_px
        self_nameTF.alpha = 0
        
        self_phoneTF.transform = up_10_px
        self_phoneTF.alpha = 0
        
        doneButton.transform = scale_down
        doneButton.alpha = 0
        
        //Executing the animations to show the objects
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
    
    
    //Executing an action when the done button is pressed (only applies for sign up)
    @IBAction func doneButtonPressed(_ sender: Any) {
        if(!is_done){
            //Gets the text from the fields
            var name = self_nameTF.text!
            var phone = self_phoneTF.text!
            
            //Shakes the text field if it is empty
            if(name.count == 0){
                self_nameTF.shake()
                return
            }
            if(phone.count == 0){
                self_phoneTF.shake()
                return
            }
            
            //Appends the data to the global array so it can be accessed and stored later
            inputArrays.append(name)
            inputArrays.append(phone)
    
            
            is_done = !is_done //changes the state of "is done"
            doneButton.setTitle("Done", for: .normal) //Changes the title of the button
            promptLabel.text = "Please input a friend's name and phone number" //Changes the prompt label to prompt for friend information
            shift_left() //Executes a transition where the current items move to the left and the new field slide in from the right to the left.
        } else{
            //get data from the friend data
            var name = friend_nameTF.text!
            var phone = friend_phoneTF.text!
            //Shakes the text field if it is empty

            if(name.count == 0){
                friend_nameTF.shake()
                return
            }
            if(phone.count == 0){
                friend_phoneTF.shake()
                return
            }
            //sets the data to the default iPhone local storage
            defaults.set(inputArrays[0], forKey: defaultsKeys.self_name)
            defaults.set(inputArrays[1], forKey: defaultsKeys.self_phone)
            defaults.set(name, forKey: defaultsKeys.friend1_name)
            defaults.set(phone, forKey: defaultsKeys.friend1_phone)
            defaults.set("True", forKey: defaultsKeys.has_signed_up)
            print("Values Set to Local")
            
            UIView.animate(withDuration: 1.5, delay: 0, options: .curveLinear, animations: {
                self.signUpBackgroundView.alpha = 0
                self.view.backgroundColor = .white

            }, completion: {
                (value: Bool) in
                self.testView.isHidden = false
                self.signUpBackgroundView.isHidden = true
                self.show_test()
            })
           
//            doneButton.setTitle("Done", for: .normal)
        }
        
    }
    
    //Will cycle through each test once it is clicked that way we are able to do all the tests and get the results.
    @IBAction func testButtonPressed(_ sender: Any) {
        if(!test1Complete){
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newvc = storyboard.instantiateViewController(identifier: "timeTest") as! TimeTestVC
            newvc.modalPresentationStyle = .overFullScreen
            newvc.timeResultDelegate = self
            self.present(newvc, animated: true, completion: nil)
        
        } else if(!test2Complete){
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newvc = storyboard.instantiateViewController(identifier: "spintest") as! SpinVC
            newvc.modalPresentationStyle = .overFullScreen
            newvc.spinResult = self
            self.present(newvc, animated: true, completion: nil)
        } else if(!test3Complete){
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newvc = storyboard.instantiateViewController(identifier: "dilationTest") as! DilationTestVC
            newvc.modalPresentationStyle = .overFullScreen
            newvc.dilationResult = self
            self.present(newvc, animated: true, completion: nil)
            
        } else{
            if(result > 0){
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newvc = storyboard.instantiateViewController(identifier: "sobervc") as! SoberVC
                newvc.modalPresentationStyle = .overFullScreen
                self.present(newvc, animated: true, completion: nil)
            } else{
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newvc = storyboard.instantiateViewController(identifier: "drunkvc") as! DrunkVC
                newvc.modalPresentationStyle = .overFullScreen
                test1Complete = false
                test2Complete = false
                test3Complete = false
                result = 0
                testButton.setTitle("take test.", for: .normal)
                self.present(newvc, animated: true, completion: nil)
            }
        }
    }
    
    //Function that is called from other ViewControllers to decide the color of the "result" view
    func didPassTest(isDrunk: Bool, testNumber: Int) {
        if(isDrunk){
            result -= 1
            switch testNumber {
            case 1:
                test1Result.backgroundColor = UIColor(named: "Fail Color")
                test1Complete = true
                
            case 2:
                test2Result.backgroundColor = UIColor(named: "Fail Color")
                test2Complete = true
            case 3:
                test3Result.backgroundColor = UIColor(named: "Fail Color")
                test3Complete = true
                self.testButton.setTitle("get results.", for: .normal)
            default:
                print("something went wrong")
            }
        } else {
            result += 1
            switch testNumber {
            case 1:
                test1Result.backgroundColor = UIColor(named: "Pass Color")
                test1Complete = true
            case 2:
                test2Result.backgroundColor = UIColor(named: "Pass Color")
                test2Complete = true
            case 3:
                test3Result.backgroundColor = UIColor(named: "Pass Color")
                test3Complete = true
                self.testButton.setTitle("get results.", for: .normal)

            default:
                print("something went wrong")
            }
        }
        
    }
    
    //Function that will shift the text fields to the left, initiating the transition
    func shift_left(){
        var location_right = CGAffineTransform(translationX: 400, y: 0)
        var location_left = CGAffineTransform(translationX: -400, y: 0)
        
        friend_nameTF.transform = location_right
        friend_phoneTF.transform = location_right
        
        UIView.animate(withDuration: 2, animations: {
            self.view.backgroundColor = .black
            self.friend_phoneTF.backgroundColor = .white
            self.friend_nameTF.backgroundColor = .white
            self.friend_nameTF.textColor = .black
            self.friend_phoneTF.textColor = .black
            self.promptLabel.textColor = .white
            
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

//View controller extention to hide the keyboard when tapped
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


//UIView Extension to shake it when called
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
