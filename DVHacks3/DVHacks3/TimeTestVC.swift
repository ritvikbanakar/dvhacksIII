//
//  TimeTestVC.swift
//  DVHacks3
//
//  Created by Sid on 3/20/21.
//

import UIKit
//Protocol to update the color of the result view in the other view controller
protocol TimeTestResultDelegate{
    func didPassTest(isDrunk: Bool, testNumber: Int)
}

class TimeTestVC: UIViewController {

    @IBOutlet weak var promptLabel: UILabel! //Prompt label
    @IBOutlet weak var testingButton: UIButton! //Button that the users will click
    var initialTime = 0 //Starting time value when the button was tcouhed
    let tolerance = 4 //The margin of error for the value ± tolerance
    let time_value = 30 //Amount of time we want the user to hold the button for
    var timeResultDelegate: TimeTestResultDelegate! //Delegate instantiation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Function for actions in the button
        testingButton.addTarget(self, action: #selector(buttonDown), for: .touchDown)
        testingButton.addTarget(self, action: #selector(buttonUp), for: [.touchUpInside, .touchUpOutside])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //Function for when the button is let go
    @objc func buttonUp(_ sender: UIButton) {
        let difference = Int(Date().millisecondsSince1970) - initialTime //Finding the difference in milliseconds between the current time and the starting time
        let diff_sec = difference/1000 //Finding the difference in seconds by dividing by 1000
        analyze_data(time: diff_sec) //Analyzing the time to see if the value fits or not
        self.dismiss(animated: true, completion: nil) //Dismissing (finishing the test)
    }
    //Gets the time and analyzes the data to see whether the time is between the interval of ± the tolerance
    func analyze_data(time: Int){
        if(time_value + tolerance < time || time_value - tolerance > time){ //Checking the tolerances
            timeResultDelegate.didPassTest(isDrunk: true, testNumber: 1) //Setting results
        } else {
            timeResultDelegate.didPassTest(isDrunk: false,  testNumber: 1) //Setting results
        }

            
    }
        
    
    //Function for when the button is first touched and held
    @objc func buttonDown(_ sender: UIButton) {
        initialTime = Int(Date().millisecondsSince1970)
        UIView.animate(withDuration: 0.5, animations: { //Scaling the button to let the user know it has been tapped
            self.testingButton.transform = CGAffineTransform(scaleX: 2, y: 4)
            self.testingButton.layer.cornerRadius = 20
        })
    }
    

}

//Date extension to get the milliseconds since 1970
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
