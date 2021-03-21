//
//  ViewController.swift
//  DVHacks3
//
//  Created by Sid on 3/19/21.
//

import UIKit
import CoreLocation
import RecordButton
import SceneKit
import ARKit
import SpeechRecognizerButton

protocol SpinARTestResult{
    func didPassTest(isDrunk: Bool, testNumber: Int)
}

class SpinVC: UIViewController ,CLLocationManagerDelegate, ARSCNViewDelegate {
    var button: SFButton!
    var locateButton: UIButton!
    var currentHeading: CLLocationDirection!
    var initHeading: CLLocationDirection!
    var startingHeading: CLLocationDirection = -10
    var lm:CLLocationManager!
    var progressTimer : Timer!
    var progress : CGFloat = 0
    var passed_half = false
    var recordButton : RecordButton!
    var stop_updated = false
    var rounds = 0
    var progressLabel: UILabel!
    var visualEffectView: UIVisualEffectView!
    var sceneView: ARSCNView!
    var textLabel: UILabel!
    var e:EchoAR!;
    var s = [[0.25,0,0,0],[0,0.25,0,0],[0,0,0.25,0],[0,0,0,1]]
    var successButton: UIButton!
    var numErrors = 0
    var spinResult: SpinARTestResult!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        // Set the view's delegate
        sceneView.delegate = self
        //let scene = SCNScene(named: "art.scnassets/River otter.usdz")!
    
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        let e = EchoAR();
        let scene = SCNScene()
        e.loadAllNodes(){ (nodes) in
            for node in nodes{
                node.transform = SCNMatrix4(m11: 0.01, m12: 0, m13: 0, m14: 0, m21: 0, m22: 0.01, m23: 0, m24: 0, m31: 0, m32: 0, m33: 0.01, m34: 0, m41: 0, m42: 0, m43: 0, m44: 1)
                let x2 = Double.random(in: -0.5...0.5)
                
                let z2 = Double.random(in: -0.5...0.5)
                node.position = SCNVector3(x2, 0, z2)
    
                scene.rootNode.addChildNode(node);
            }
        }
        
        // Set the scene to the view
        sceneView.scene=scene;
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        visualEffectView.isUserInteractionEnabled = false
        let blurAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
                
        
        }
        blurAnimator.startAnimation()
        
        button = SFButton(frame: CGRect(x: self.view.frame.width / 2 - 50,y: self.view.frame.height / 2 + 100 ,width: 100,height: 100))
        button.setImage(UIImage(named: "mic"), for: .normal)
        button.isHidden = true
        
        successButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 100,y: self.view.frame.height + 200 ,width: 200,height: 200))
        successButton.addTarget(self, action: #selector(self.successTapped), for: .touchUpInside)
        successButton.setImage(UIImage(named: "check"), for: .normal)
        
        self.view.addSubview(successButton)
        self.view.addSubview(button)
        button.isUserInteractionEnabled = false
        button.resultHandler = {
            var up_50_px = CGAffineTransform(translationX: 0, y: -500)
            self.textLabel.text = $1?.bestTranscription.formattedString
            
            if(self.textLabel.text == "Building")
            {
                
                self.button.isHidden = true
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeLinear, animations: {
                    self.successButton.transform = up_50_px
                    self.textLabel.text = "Success!"
                    self.textLabel.textColor = .green
                }, completion: {
                    (value: Bool) in
                    do {
                        sleep(1)
                    }
                    self.spinResult.didPassTest(isDrunk: false, testNumber: 2)
                    self.dismiss(animated: true, completion: nil)
                })
               
               
            }
            else
            {
                self.textLabel.textColor = .red
                self.numErrors += 1
                if(self.numErrors >= 2){
                    self.spinResult.didPassTest(isDrunk: true, testNumber: 2)
                    self.dismiss(animated: true, completion: nil)
                }
            }
                    
        }
        button.errorHandler = {
                   guard let error = $0 else {
                       self.textLabel.text = "Unknown error."
                       return
                   }
                   switch error {
                   case .authorization(let reason):
                       switch reason {
                       case .denied:
                           self.textLabel.text = "Authorization denied."
                       case .restricted:
                           self.textLabel.text = "Authorization restricted."
                       case .usageDescription(let key):
                           self.textLabel.text = "Info.plist \"\(key)\" key is missing."
                       }
                   case .cancelled(let reason):
                       switch reason {
                       case .notFound:
                           self.textLabel.text = "Cancelled, not found."
                       case .user:
                           self.textLabel.text = "Cancelled by user."
                       }
                   case .invalid(let locale):
                       self.textLabel.text = "Locale \"\(locale)\" not supported."
                   case .unknown(let unknownError):
                       self.textLabel.text = unknownError?.localizedDescription
                   default:
                       self.textLabel.text = error.localizedDescription
                   }
               }
        locateButton = UIButton(frame: CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height / 2 + 300, width: 200, height: 30))
        locateButton.backgroundColor = .black
        locateButton.setTitleColor(.white, for: .normal)
        locateButton.setTitle("Locate the object.", for: .normal)
        locateButton.titleLabel?.font = UIFont(name: "GTWalsheimProTrial-Medium", size: 20)
        locateButton.isHidden = true
        self.view.addSubview(locateButton)
        locateButton.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)

        
        textLabel = UILabel(frame: CGRect(x: self.view.frame.width/2 , y: self.view.frame.height / 2 - 200, width: 300, height: 31))
        textLabel.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        textLabel.textAlignment = .center
        textLabel.text = ""
        textLabel.font = UIFont(name: "GTWalsheimProTrial-Medium", size: 30)
        self.view.addSubview(textLabel)
        
        
        
        
        
        
       
        lm = CLLocationManager()
        lm.delegate = self
      
        
        
        recordButton = RecordButton(frame: CGRect(x: self.view.frame.width / 2 - 100,y: self.view.frame.height / 2 - 100,width: 200,height: 200))
        view.addSubview(recordButton)
        
        progressLabel = UILabel(frame: CGRect(x: self.view.frame.width/2 , y: self.view.frame.height / 2 - 200, width: 300, height: 31))
        progressLabel.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + 200)
        progressLabel.textAlignment = .center
        progressLabel.text = "0/3 rounds completed"
        progressLabel.font = UIFont(name: "GTWalsheimProTrial-Medium", size: 30)
        self.view.addSubview(progressLabel)

        recordButton.addTarget(self, action: #selector(self.record), for: .touchDown)
        recordButton.addTarget(self, action: #selector(self.stop), for: UIControl.Event.touchUpInside)
        
    
    }
    @objc func successTapped()
    {
        //segue back to home
    }

    @objc func buttonTapped()
    {
        
        var up_50_px = CGAffineTransform(translationX: 0, y: 300)
        visualEffectView.isUserInteractionEnabled = false
        let blurAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
            
        
        }
        UIView.animate(withDuration: 0.5, animations: {
                self.locateButton.transform = up_50_px
            
        })
        blurAnimator.startAnimation()
        
        button.isHidden = false
        button.isUserInteractionEnabled = true
        
    }
    @objc func record() {
//        self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        lm.startUpdatingHeading()
        stop_updated = false
        progressLabel.isHidden = false
        
        
        
        
    }
    @objc func stop() {
        recordButton.setProgress(0)
        stop_updated = true
//        progressTimer.invalidate
        recordButton.buttonState = .idle
        var up_50_px = CGAffineTransform(translationX: 0, y: -550)
        var down_50_px = CGAffineTransform(translationX: 0, y: 300)
        UIView.animate(withDuration: 1, animations: {
                    self.recordButton.transform = up_50_px
            self.progressLabel.transform = down_50_px
        })
        let blurAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
                self.visualEffectView.effect = nil
                self.visualEffectView.isUserInteractionEnabled = false
        }
        blurAnimator.startAnimation()
        locateButton.isHidden = false
        locateButton.isUserInteractionEnabled = true
       }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func updateProgress() {
//        print("updating")
        var angle_traversed = 0
        if(currentHeading >= startingHeading){
            angle_traversed = Int(currentHeading) - Int(startingHeading)
        } else {
            angle_traversed = 360 - Int(startingHeading) + Int(currentHeading)
        }
        
        progress = CGFloat(angle_traversed)/360.0
//        print("Traversed \(angle_traversed)")
        if(!passed_half && angle_traversed > 180){
            passed_half = true
        }
        if(passed_half){
            if(angle_traversed + 10 > 360 && angle_traversed - 10 < 360){
                rounds += 1
                print("DONE WITH ONE ROUND")
              
                startingHeading = -10
                
            }
        }
        if(rounds == 1)
        {
            progressLabel.text = "1/3 rounds completed"
            progressLabel.textColor = .yellow
        }
        else if(rounds == 2)
        {
            progressLabel.text = "2/3 rounds completed"
            progressLabel.textColor = .orange
        }
        else if(rounds == 3)
        {
            progressLabel.text = "completed!"
            progressLabel.textColor = .green
            lm.stopUpdatingHeading()
           
        }
        
        recordButton.setProgress(progress)
           
           
           
    }
//    func update_checkpoints(angle: Int){
//        let margin = 5
//        if(angle + margin > 90 && angle - margin < 90 ){
//            if(checkPoints[0] == true && checkPoints[2] == false && checkPoints[3])
//        }
//    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        
        if(startingHeading < 0){
            startingHeading = newHeading.trueHeading
            initHeading = 0
            currentHeading = newHeading.trueHeading
        } else{
            initHeading = currentHeading
            currentHeading = newHeading.trueHeading
        }
        
//        print("Starting \(Int(startingHeading))")
//        print("Current \(Int(currentHeading))")
        if(!stop_updated){
            updateProgress()
        }

        
    }
    func truncate(places : Int, num: Double)-> Double {
        return Double(floor(pow(10.0, Double(places)) * num)/pow(10.0, Double(places)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        //configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

}
