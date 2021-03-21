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
//Protocol to change the color of the "result" view from a different view controller
protocol DilationTestResult{
    func didPassTest(isDrunk: Bool, testNumber: Int)
}

class DilationTestVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var dilationResult: DilationTestResult! //Instatiating the procotol
    var model = EyeClassifer() //Creating an instance of our EyeClassifier model
    override func viewDidLoad() {
        super.viewDidLoad()
    


    }
    
    //Function to take a picture once the button is pressed
    @IBAction func takePicture(_ sender: Any) {
        let picker = UIImagePickerController() //Creates a UIImagePickerController as the body of the camera view
        picker.sourceType = .camera //Chooses the camera as the source
        picker.allowsEditing = true //Allows us to zoom in and move the image to get our eye
        picker.delegate = self //Sets the delegate as self to use object functions
        present(picker, animated: true) //Shows the picker view
    }
    
    //Gets rid of the picker when cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //Creates the image once the image has been taken and selected.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            return
        }
        
        var editedImage = image.scaleImage(toSize: CGSize(width: 299, height: 299)) //Changes the size of the image for it to fit in the CoreML model
        
        let dilation_data = try? model.prediction(image: (editedImage?.pixelBuffer())!) //Uses the model to predict the data by turning it into a pixelBuffer type
        
        let result = dilation_data!.classLabel //Gets the result
        
        
        //Gets the dilation probability and sees whether it is a majority or not is predicting dilated, and decide drunk or not accordingly
        let dilute_prob = dilation_data!.classLabelProbs["dilated"]!
        
        if(dilute_prob > 0.5){
            dilationResult.didPassTest(isDrunk: false, testNumber: 3)
        } else {
            dilationResult.didPassTest(isDrunk: false, testNumber: 3)

        }
        self.dismiss(animated: true, completion: nil)
    }

}


//UIImage extension to scale images and change images into a pixel buffer (the type used by CoreML models to be able to go through the data)
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

