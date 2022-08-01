//
//  PresentationController.swift
//  MVVM-C App
//
//  Created by Konstantin Korchak on 19.07.2022.
//

import Foundation
import UIKit

class PresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView?.bounds ?? CGRect()
        let halfHeight = bounds.height / 2
        return CGRect(
            x: 0,
            y: halfHeight,
            width: bounds.width,
            height: halfHeight
        )
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView ?? UIView())
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        setupFrame()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    private func setupFrame() {
        let newY = UIScreen.main.bounds.minY + 100
        
        containerView?.frame = CGRect(
            x: 0,
            y: newY,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height - 100
        )
    }
}
