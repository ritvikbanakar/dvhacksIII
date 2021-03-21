//
//  TimeTestVC.swift
//  DVHacks3
//
//  Created by Sid on 3/20/21.
//

import UIKit

protocol TimeTestResultDelegate{
    func didPassTest(isDrunk: Bool, testNumber: Int)
}

class TimeTestVC: UIViewController {

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var testingButton: UIButton!
    let defaults = UserDefaults.standard
    var initialTime = 0
    var repitionAmount = 3
    let tolerance = 4
    let time_value = 30
    var timeResultDelegate: TimeTestResultDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        testingButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        testingButton.addTarget(self, action: #selector(buttonUp), for: [.touchUpInside, .touchUpOutside])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func buttonUp(_ sender: UIButton) {
        let difference = Int(Date().millisecondsSince1970) - initialTime
        let diff_sec = difference/1000
//        timeValues.append(diff_sec)
//        if(timeValues.count == repitionAmount){
//            testingButton.isHidden = true
//            if(isTest){
        analyze_data(time: diff_sec)
//            } else {
//                write_data()
//                timeResultDelegate.didPassTest(isDrunk: false, testNumber: 1)
//
//            }
        self.dismiss(animated: true, completion: nil)
//        }
    }
    
    func analyze_data(time: Int){
        if(time_value + tolerance < time || time_value - tolerance > time){
            timeResultDelegate.didPassTest(isDrunk: true, testNumber: 1)
        } else {
            timeResultDelegate.didPassTest(isDrunk: false,  testNumber: 1)
        }

            
    }
        
    
    
    @objc func buttonDown(_ sender: UIButton) {
        initialTime = Int(Date().millisecondsSince1970)
        UIView.animate(withDuration: 0.5, animations: {
            self.testingButton.transform = CGAffineTransform(scaleX: 2, y: 4)
            self.testingButton.layer.cornerRadius = 20
        })
    }
    

}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
