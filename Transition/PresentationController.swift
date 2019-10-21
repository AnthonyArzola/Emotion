//
//  PresentationController.swift
//  Emotion
//
//  Created by Anthony Arzola on 2/19/18.
//  Copyright © 2018 Anthony Arzola. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    // MARK: - Member variables
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    @objc func dismiss(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIPresentationController methods overridden
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                      action: #selector(self.dismiss))
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // The default implementation of this method returns the frame rectangle of the
    // container view, which results in the presented view controller’s content occupying
    // the entire presentation space. Override this method to return a different
    // frame rectangle as needed.
    override var frameOfPresentedViewInContainerView: CGRect{
        return CGRect(origin: CGPoint(x: 0, y: 75),
                      size: CGSize(width: self.containerView!.frame.width,
                                   height: self.containerView!.frame.height))
    }
    
    // Add custom views to the view hierarchy and create any animations associated with those views
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 1
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            
        })
    }

    // Perform animations related to the dismissal of the presented view controller
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
            
        })
    }
    
    // Layout-specific changes
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 10
    }
    
    // UIKit calls this method after adjusting the layout of the views in the container view
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
    
}
