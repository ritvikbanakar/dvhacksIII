//
//  ViewController.swift
//  DVHacks3
//
//  Created by Sid on 3/19/21.
//

import UIKit
import CoreLocation
import RecordButton
class SpinVC: UIViewController ,CLLocationManagerDelegate {
    var prevHeading: CLHeading!
    var initHeading: CLHeading!
    var lm:CLLocationManager!
    var first: Bool = false
    var nextBucket:Int = 0
    var progressTimer : Timer!
    var progress : CGFloat = 0
    var recordButton : RecordButton!
    var negative: Bool = false
    var currProgress: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        lm = CLLocationManager()
        lm.delegate = self

        
        
        recordButton = RecordButton(frame: CGRect(x: self.view.frame.width / 2,y: self.view.frame.height / 2,width: 200,height: 200))
        view.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(self.record), for: .touchDown)
        recordButton.addTarget(self, action: #selector(self.stop), for: UIControl.Event.touchUpInside)

        
        
        
    }
    @objc func record() {
//        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.updateProgress), userInfo: nil, repeats: true)
        lm.startUpdatingHeading()
        
    }
    @objc func stop() {
            recordButton.setProgress(0)
           
       }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func updateProgress() {
           
        let maxDuration = CGFloat(5) // Max duration of the recordButton
        if(prevHeading != nil)
        {
            
            progress = CGFloat((Int(prevHeading.trueHeading) - Int(initHeading.trueHeading)) % 360) / 360
            
            else
            {
                
                progress = progress + CGFloat((Int(initHeading.trueHeading) - Int(prevHeading.trueHeading)) % 360) / 360

            }
            if(progress == 1)
            {
                recordButton.backgroundColor = .green
            }
            print(progress)
            
           recordButton.setProgress(progress)
        }
           
           
           
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        
        
        if(first == false)
        {
            first = true
            initHeading = newHeading
            prevHeading = newHeading
            print(initHeading)
            nextBucket = (Int(initHeading.trueHeading) + 5) % 360
            print(nextBucket)
            
        }
//        else {
//            if (Int(newHeading.trueHeading) < Int(prevHeading.trueHeading) || Int(newHeading.trueHeading) > nextBucket) {
//                print("hi")
//            }
//            else {
//                if (Int(prevHeading.trueHeading)) < initHeading) && nextBucket > initHeading)
//                prevHeading = newHeading
//                nextBucket = (Int(initHeading.trueHeading) + 5) % 360
//            }
//        }
        else
        {
            if(360 - Int(initHeading.trueHeading) + Int(newHeading.trueHeading) >= 360)
            {
                print("circle")
            }
            if(360-initHeading.trueHeading )
            
//            if(Int(newHeading.trueHeading) < nextBucket && Int(newHeading.trueHeading) >= Int(prevHeading.trueHeading))
//            {
//                prevHeading = newHeading
//                nextBucket = (Int(prevHeading.trueHeading) + 5) % 360
//                updateProgress()
//            }
        }
        
//        print(truncate(places: 0, num: newHeading.trueHeading))
        
    }
    func truncate(places : Int, num: Double)-> Double {
        return Double(floor(pow(10.0, Double(places)) * num)/pow(10.0, Double(places)))
    }

}
