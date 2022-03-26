import UIKit

class DismissAnimation: NSObject {
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
        guard let from = transitionContext.viewController(forKey: .from) else { fatalError() }
        let initialFrame = transitionContext.initialFrame(for: from)


        let dragViewSize = self.draggingView?.sizeThatFits(initialFrame.size) ?? .zero
        var draggingViewInitialFrame = initialFrame
        draggingViewInitialFrame.size.height = dragViewSize.height
        draggingViewInitialFrame.origin.y = initialFrame.minY - dragViewSize.height
        
        let animator = UIViewPropertyAnimator(duration: self.duration, curve: .easeInOut) { [weak self] in
            from.view.frame = initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
            self?.draggingView?.frame = draggingViewInitialFrame.offsetBy(dx: 0, dy: initialFrame.height)
        }
        animator.addCompletion { [weak self] position in
            if position == .start {
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

extension DismissAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
        self.percentHandler?(.active(1))
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}
