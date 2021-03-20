//
//  DilationTestVC.swift
//  DVHacks3
//
//  Created by Sid on 3/20/21.
//

import UIKit
import AVKit
import Vision
import CoreML

class DilationTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) else { fatalError("no front camera. but don't all iOS 10 devices have them?")}
            
    
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
//        VNImageRequestHandler(
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
