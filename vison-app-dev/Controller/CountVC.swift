//
//  CountVC.swift
//  vison-app-dev
//
//  Created by Apple on 7/5/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision



@available(iOS 11.0, *)
class CountVC: UIViewController {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var backgroundResult: UIView!
    var speechSynthesizer = AVSpeechSynthesizer()
    
    
//    let request = VNCoreMLRequest(model: model) { [weak self] request, error in
//        guard let results = request.results as? [VNClassificationObservation],
//            let topResult = results.first else {
//                fatalError("unexpected result type from VNCoreMLRequest")
//        }
//
//        // Update UI on main queue
//        let article = (self?.vowels.contains(topResult.identifier.first!))! ? "an" : "a"
//        DispatchQueue.main.async { [weak self] in
//
//
//        }
//    }
    
//    let model = try? VNCoreMLModel(for: ObjectClassifier().model)
    
    
//    lazy var classificationRequest:VNCoreMLRequest = {
//
//        do{
//            guard let model = try? VNCoreMLModel(for: ObjectClassifier().model) else {
//                fatalError("can't load Places ML model")
//            }
//            let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
//                print("request\(request)")
//                self.processClassifications(for: request, error: error)
//            })
//
//            return request
//        }catch{
//            fatalError("Failed to load Core ML Model: \(error)")
//        }
//    }()

    var count = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundResult.isHidden = true
        
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            let image = UIImage(named: "test.jpg")
//        var thePixelBuffer : CVPixelBuffer?
//        thePixelBuffer = self.pixelBufferFromImage(image: image!)
//        guard let prediction =  try? ObjectClassifier().prediction(image: thePixelBuffer!) else { return }
//        print("test\(prediction.classLabel)")


    }
    
    @objc func update()
    {
    
        if count > 0{
            count -= 1
            
            if count == 2{
               self.view.backgroundColor = #colorLiteral(red: 0.9608203769, green: 0.5931894183, blue: 0.1159928367, alpha: 1)
            }
            
            if count == 1{
                self.view.backgroundColor = #colorLiteral(red: 0, green: 0.9244301915, blue: 0, alpha: 1)
            }
            
            if count == 0{
                countLabel.isHidden = true
                backgroundResult.isHidden = false
                var thePixelBuffer : CVPixelBuffer?
                let image = UIImage(named: "test.jpg")
                thePixelBuffer = self.pixelBufferFromImage(image: image!)
                guard let prediction =  try? ObjectClassifier().prediction(image: thePixelBuffer!) else { return }
                print("test\(prediction.classLabel)")
                synthesizeSpeech(fromString: "I want you find \(prediction.classLabel)")
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                   
                    
                }
            }
        
            countLabel.text = String(count)
        }
    
    }
    
    func presentDetail() {
        guard let cameraVC = storyboard?.instantiateViewController(withIdentifier: "CameraVC") as? CameraVC else { return }
        //
        present(cameraVC, animated: true, completion: nil)
        
    }
    
    func synthesizeSpeech(fromString string: String) {
        let speechUtterance = AVSpeechUtterance(string: string)
        speechSynthesizer.speak(speechUtterance)
    }
    
    @available(iOS 11.0, *)

    func debugPrint(sentences:String){
        
        print(sentences)
        
        
    }
    func processClassifications(for request: VNRequest, error: Error?){
        
        DispatchQueue.main.async {
            
            
            guard let results =  request.results as? [VNClassificationObservation] else {
                fatalError("can't load Places ML model")
                return
                
            }
            
            for classification in results {
                let identification = classification.identifier
                
                print("your result \(identification)")
                
            }
        }
        
       
        
      
        
        
    }
    

    
    
    
    
    

    
}
@available(iOS 11.0, *)
extension CountVC{
    
    func detectScene(image: CIImage) {
        
//        let model = ObjectClassifierInput.self
        // Load the ML model through its generated class
//        guard let model = try? VNCoreMLModel(for: ObjectClassifierInput(image: <#CVPixelBuffer#>)) else {
//            fatalError("can't load Places ML model")
//        }
    }
    func pixelBufferFromImage(image: UIImage) -> CVPixelBuffer {
        
        let ciimage = CIImage(image: image)
        //let cgimage = convertCIImageToCGImage(inputImage: ciimage!)
        let tmpcontext = CIContext(options: nil)
        let cgimage =  tmpcontext.createCGImage(ciimage!, from: ciimage!.extent)
        let cfnumPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
        let cfnum = CFNumberCreate(kCFAllocatorDefault, .intType, cfnumPointer)
        let keys: [CFString] = [kCVPixelBufferCGImageCompatibilityKey, kCVPixelBufferCGBitmapContextCompatibilityKey, kCVPixelBufferBytesPerRowAlignmentKey]
        let values: [CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, cfnum!]
        let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        let valuesPointer =  UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        keysPointer.initialize(to: keys)
        valuesPointer.initialize(to: values)
        let options = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, keys.count, nil, nil)
        let width = cgimage!.width
        let height = cgimage!.height
        var pxbuffer: CVPixelBuffer?
        // if pxbuffer = nil, you will get status = -6661
        var status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_32BGRA, options, &pxbuffer)
        status = CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        let bufferAddress = CVPixelBufferGetBaseAddress(pxbuffer!);
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        let bytesperrow = CVPixelBufferGetBytesPerRow(pxbuffer!)
        let context = CGContext(data: bufferAddress,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesperrow,
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue);
        context?.concatenate(CGAffineTransform(rotationAngle: 0))
        context?.concatenate(__CGAffineTransformMake( 1, 0, 0, -1, 0, CGFloat(height) )) //Flip Vertical
        //        context?.concatenate(__CGAffineTransformMake( -1.0, 0.0, 0.0, 1.0, CGFloat(width), 0.0)) //Flip Horizontal
        
        context?.draw(cgimage!, in: CGRect(x:0, y:0, width:CGFloat(width), height:CGFloat(height)));
        status = CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        return pxbuffer!;
    
    }
    
}