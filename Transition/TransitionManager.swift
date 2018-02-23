//
//  PresentationManager.swift
//  Emotion
//
//  Created by Anthony Arzola on 2/19/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerTransitioningDelegate {
 
    // MARK: - UIViewControllerTransitioningDelegate methods
    
    // Asks your delegate for the custom presentation controller to use for
    // managing the view hierarchy when presenting a view controller.
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        let presentationController = PresentationController(presentedViewController: presented,
                                                                   presenting: presenting)
        return presentationController
    }
    
}
