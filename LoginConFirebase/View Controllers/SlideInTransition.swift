//
//  SlideInTransition.swift
//  LoginConFirebase
//
//  Created by Agustin Job Hernandez Montes on 17/01/20.
//  Copyright © 2020 Agustin Job Hernandez Montes. All rights reserved.
//

import UIKit

class SlideInTransition: NSObject , UIViewControllerAnimatedTransitioning {

    var isPresenting = false
    let dimmingView = UIView()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
      }
      
      func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewCOntroller = transitionContext.viewController(forKey: .from) else{ return }
        let containerView = transitionContext.containerView
        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeigth = toViewController.view.bounds.height
        
        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            // Add menu view controller to container
            containerView.addSubview(toViewController.view)
            print(finalWidth)
            // Init frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeigth)
             // toViewController.view.frame = CGRect(x: 100, y: 0, width: finalWidth, height: finalHeigth)
        
        }
        
        // animated on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
                      
        }
        
        // Animated back off screen
        let identity = {
             self.dimmingView.alpha = 0.0
            fromViewCOntroller.view.transform = .identity
        }
        
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform(): identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
        
        
        
      }
    
}
