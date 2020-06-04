//
//  AnnotatedPictureViewController.swift
//  Emotion
//
//  Created by Anthony Arzola on 2/12/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class AnnotatedPictureViewController: UIViewController {
    
    // MARK: - Member variables
    private let COGNATIVE_SERVICE_API_KEY = "YOUR_API_KEY"
    private let COGNATIVE_SERVICE_API_ENDPOINT = "https://WestCentralUS.api.Cognitive.Microsoft.com/face/v1.0/detect"
    private let CONTENT_TYPE_OCTET_STREAM = "application/octet-stream"
    
    var imageData: Data?
    var emotion: [Detect] = []
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    // MARK: - Outlets
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    
    // MARK: - Lifecycle events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide label until we Emotion API is called
        self.emotionLabel.isHidden = true
        
        guard let capturedImage = UIImage.init(data: imageData!, scale: 1.0) else {
            print("❗️ - Failed to initialize UIImageView with image data.")
            return
        }
        
        self.pictureImageView.image = capturedImage
        
        // Send image to Emotion API
        getEmotions(image: capturedImage).done { emotionalArray in
            if (emotionalArray.count > 0) {
                self.pictureImageView.image = self.addRectanglesToImage(image: capturedImage, emotions: emotionalArray)
                self.addLabelsToView(view: self.pictureImageView, emotions: emotionalArray)
            } else {
                self.emotionLabel.isHidden = false
            }
        }.catch { error in
            self.emotionLabel.isHidden = false
            self.emotionLabel.text = error.localizedDescription
        }
    }
    
    // MARK: - Events
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
            
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0,
                                         y: touchPoint.y - initialTouchPoint.y + 75,
                                         width: self.view.frame.size.width,
                                         height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 150 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 75,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        }
    }
    
    // MARK: - Private methods
    private func getEmotions(image: UIImage) -> Promise<[Detect]> {
        
        return Promise { resolver in
            // API has restriction on image size, reduce quality/size
            guard let data = image.jpegData(compressionQuality: 0.75) else {
                print("❗️ - Failed to convert UIImageview.image into image data.")
                return
            }
            
            // Create HTTP Headers
            let header = [
                "Ocp-Apim-Subscription-Key": COGNATIVE_SERVICE_API_KEY,
                "Content-Type": CONTENT_TYPE_OCTET_STREAM]
            
            Alamofire.upload(data, to: COGNATIVE_SERVICE_API_ENDPOINT + "?returnFaceAttributes=emotion", method: .post, headers: header).responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let emotionalArray = try JSONDecoder().decode([Detect].self, from: response.data!)
                        resolver.fulfill(emotionalArray)
                    }
                    catch {
                        print("❗️ - Unable to deserialize JSON. Error:\(error)")
                        resolver.reject(error)
                    }
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }

    private func addRectanglesToImage(image: UIImage, emotions: [Detect]) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(at: CGPoint.zero)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.setLineWidth(8.0)
        context.setStrokeColor(UIColor.green.cgColor)
        
        for emotion in emotions {
            let rectangle = CGRect(x: emotion.FaceRectangle.Left,
                                   y: emotion.FaceRectangle.Top,
                                   width: emotion.FaceRectangle.Width,
                                   height: emotion.FaceRectangle.Height)
            
            context.addRect(rectangle)
        }
        context.drawPath(using: .stroke)
        
        let modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return modifiedImage!
    }
    
    private func addLabelsToView(view: UIView, emotions: [Detect]) {
        for emotion in emotions {
            let emotionTuple = emotion.getProminetEmotionWithEmoji()
            
            let rectangle = CGRect(x: emotion.FaceRectangle.Left/10,
                                   y: emotion.FaceRectangle.Top/10,
                                   width: 200,
                                   height: 30)
            
            let label = UILabel(frame: rectangle)
            label.textColor = UIColor.red
            label.font = UIFont.systemFont(ofSize: 22.0)
            label.text = "\(emotionTuple.0) \(emotionTuple.1)"
            
            view.addSubview(label)
        }
        
    }
    
}
