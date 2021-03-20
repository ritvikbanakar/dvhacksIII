//
//  TimeTestVC.swift
//  DVHacks3
//
//  Created by Sid on 3/20/21.
//

import UIKit

class TimeTestVC: UIViewController {

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var testingButton: UIButton!
    let defaults = UserDefaults.standard
    var isTest = false
    var timeValues: [Int] = []
    var initialTime = 0
    var repitionAmount = 3
    let tolerance = 1.5
    override func viewDidLoad() {
        super.viewDidLoad()
        testingButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        testingButton.addTarget(self, action: #selector(buttonUp), for: [.touchUpInside, .touchUpOutside])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let time_data = defaults.string(forKey: defaultsKeys.time_trial_1) {
            isTest = true
            repitionAmount = 1
        }
    }
    
    @objc func buttonUp(_ sender: UIButton) {
        let difference = Int(Date().millisecondsSince1970) - initialTime
        let diff_sec = difference/1000
        timeValues.append(diff_sec)
        if(timeValues.count == repitionAmount){
            testingButton.isHidden = true
            if(isTest){
                analyze_data()
            } else {
                write_data()
            }
        }
    }
    
    func analyze_data(){
        let trial1 = defaults.integer(forKey: defaultsKeys.time_trial_1)
        let trial2 = defaults.integer(forKey: defaultsKeys.time_trial_2)
        let trial3 = defaults.integer(forKey: defaultsKeys.time_trial_3)
        let currentTime = timeValues[0]
        
        
        let mean = (trial1 + trial2 + trial3)/3
        let square_sum = (trial1 - mean)^2 + (trial2 - mean)^2 + (trial3 - mean)^2
        let variance = square_sum/3
        let deviation = sqrt(Double(variance))
        
        if(mean + Int(tolerance * deviation) < currentTime || mean - Int(tolerance * deviation) > currentTime){
            //homie is drunk
        } else {
            //homie is sober
        }
        
        print(trial1)
        print(trial2)
        print(trial3)
        print(timeValues[0])
        
            
    }
        
    
    func write_data(){
        defaults.set(timeValues[0], forKey: defaultsKeys.time_trial_1)
        defaults.set(timeValues[1], forKey: defaultsKeys.time_trial_2)
        defaults.set(timeValues[2], forKey: defaultsKeys.time_trial_3)
        print("written")
    }
    
    @objc func buttonDown(_ sender: UIButton) {
        initialTime = Int(Date().millisecondsSince1970)
    }
    

}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
