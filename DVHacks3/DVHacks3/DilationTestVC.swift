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

class DilationTestVC: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var newImage: UIImageView!
    
    @IBOutlet weak var secondView: UIView!
    


    override func viewDidLoad() {
        super.viewDidLoad()

       
        
    }
    
  
    @IBAction func takePicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return
        }
        newImage.image = image
        
    }

}

