//
//  PresentAnimation.swift
//  PopUp
//
//  Created by Дмитрий Шелонин on 03.01.2021.
//

import UIKit

class PresentAnimation: NSObject {
    private let duration: TimeInterval
    private let percentHandler: OpenStateHandler?
    private let draggingView: UIView?
    
    init(_ duration: TimeInterval, percentHandler: OpenStateHandler? = nil,
         draggingView: UIView?) {
        self.duration = duration
        self.percentHandler = percentHandler
        self.draggingView = draggingView
        
        super.init()
    }
    
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        //controller that is gonna be presented
        guard let toPresent = transitionContext.viewController(forKey: .to) else { fatalError() }
        let finalFrame = transitionContext.finalFrame(for: toPresent)

        let dragViewSize = self.draggingView?.sizeThatFits(finalFrame.size) ?? .zero
        var draggingViewFinalFrame = finalFrame
        draggingViewFinalFrame.size.height = dragViewSize.height
        draggingViewFinalFrame.origin.y = finalFrame.minY - dragViewSize.height
        //set start frame outside the screen
        toPresent.view.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        self.draggingView?.frame = draggingViewFinalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        
        let animator = UIViewPropertyAnimator(duration: self.duration, curve: .easeInOut) { [weak self] in
            self?.draggingView?.frame = draggingViewFinalFrame
            toPresent.view.frame = finalFrame
        }
        animator.addCompletion { [weak self] position in
            if position == .end {
                self?.percentHandler?(.opened)
            } else {
                self?.percentHandler?(.closed)
            }
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        }
        
        return animator
    }
}

extension PresentAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
        self.percentHandler?(.active(0))
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}
