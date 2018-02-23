//
//  ViewController.swift
//  Emotion
//
//  Created by Anthony Arzola on 2/4/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    // MARK: - Member variables
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var imageData: Data?
    var transitionDelegate = TransitionManager() // UIViewControllerTransitioningDelegate
    
    // MARK: - Outlets
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var takePictureButton: UIButton!
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        imageData = Data()
        
        do {
            // Set capture device/input to video
            let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Specify [video] input on the capture session
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            // Configure preview view
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            
            // Show video preview layer
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            // start [video] capture
            captureSession?.startRunning()
            
            // Prepare to take photo from the capture session
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            // Define output
            captureSession?.addOutput(capturePhotoOutput!)
        }
        catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button events
    @IBAction func onTakePictureTouch(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else {
            print("❗️ - CapturePhotoOutput error.")
            return
        }
        
        // Set photo capture settings
        let capturePhotoSettings = AVCapturePhotoSettings()
        
        capturePhotoSettings.isAutoStillImageStabilizationEnabled = true
        capturePhotoSettings.isHighResolutionPhotoEnabled = true
        
        // Finally, capture the photo using settings above and handle the result
        capturePhotoOutput.capturePhoto(with: capturePhotoSettings, delegate: self)
    }
    
    // MARK: - AVCapturePhotoCaptureDelegate methods
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        
        if let error = error {
            print(" ❗️ - Photo capture error: \(error.localizedDescription)")
            return
        }
        
        imageData = photo.fileDataRepresentation()

        // Navigate to view controller after image is captured
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController =
            storyboard.instantiateViewController(withIdentifier: "annotateVC") as! AnnotatedPictureViewController
        
        viewController.imageData = imageData
        viewController.view.layer.borderWidth = 1
        viewController.view.layer.borderColor = UIColor.white.cgColor
        
        viewController.transitioningDelegate = transitionDelegate
        viewController.modalPresentationStyle = .custom
        
        self.present(viewController, animated: true, completion: nil)
    }
    
}
