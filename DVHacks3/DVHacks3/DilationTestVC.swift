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

protocol DilationTestResult{
    func didPassTest(isDrunk: Bool, testNumber: Int)
}

class DilationTestVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var secondView: UIView!
    let defaults = UserDefaults.standard

    var dilationResult: DilationTestResult!
    var model = EyeClassifer()


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
        
        var editedImage = image.scaleImage(toSize: CGSize(width: 299, height: 299))
        
        let dilation_data = try? model.prediction(image: (editedImage?.pixelBuffer())!)
        
        let result = dilation_data!.classLabel
        
        let dilated_result = defaults.double(forKey: defaultsKeys.dilated_percent)
        print(dilation_data!.classLabelProbs["dilated"]!)
        print(dilated_result)
        
        if(dilated_result > 0.0){
            if(dilated_result + 0.5 < dilation_data!.classLabelProbs["dilated"]!){
                print("WE ARE IN HERE WE'VE FINNA PASSED")
                dilationResult.didPassTest(isDrunk: true, testNumber: 3)

            } else {
                print("WE ARE IN HERE WE'VE FINNA FAILED")
                dilationResult.didPassTest(isDrunk: false, testNumber: 3)


            }
        } else{
            defaults.set(dilation_data!.classLabelProbs["dilated"], forKey: defaultsKeys.dilated_percent)
            dilationResult.didPassTest(isDrunk: false, testNumber: 3)

        }
        //decide drunk or not here
//        dilationResult.didPassTest(isDrunk: true, testNumber: 3)
        self.dismiss(animated: true, completion: nil)
    }

}


extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    func pixelBuffer() -> CVPixelBuffer? {
        let width = self.size.width
        let height = self.size.height
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)

        guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }

        CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                      space: rgbColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                                        return nil
        }

        context.translateBy(x: 0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return resultPixelBuffer
    }
}

