//
//  PresentAnimation.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 19.07.2022.
//

import Foundation
import UIKit

class PresentAnimation: NSObject {
    let duration: TimeInterval = 0.3
    
    private func animator(using transitionContex: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let to = transitionContex.view(forKey: .to)!
        let finalFrame = transitionContex.finalFrame(for: transitionContex.viewController(forKey: .to)!)
        to.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            to.frame = finalFrame
        }
        
        animator.addCompletion { position in
            transitionContex.completeTransition(!transitionContex.transitionWasCancelled)
        }
        
        return animator
    }
}

extension PresentAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}
