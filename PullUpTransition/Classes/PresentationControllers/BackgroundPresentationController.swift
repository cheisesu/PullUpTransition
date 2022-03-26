import UIKit

class BackgroundPresentationController: PresentationController {
    private let substrateView: UIView
    
    init(with view: UIView, dismissalOutside: Bool = true,
         with draggingView: UIView? = nil, presentedViewController: UIViewController,
         presenting: UIViewController?) {
        self.substrateView = view
        
        super.init(with: draggingView, presentedViewController: presentedViewController, presenting: presenting)
        
        if dismissalOutside {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissHandler(_:)))
            tap.name = "BackgroundPresentationController.TapDismiss"
            view.addGestureRecognizer(tap)
        }
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.insertSubview(self.substrateView, at: 0)
        self.performAlongSideTransitionIfPossible { [weak self] in
            self?.substrateView.alpha = 1
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.substrateView.frame = containerView?.frame ?? .zero
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            self.substrateView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        self.performAlongSideTransitionIfPossible { [weak self] in
            self?.substrateView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            self.substrateView.removeFromSuperview()
        }
    }
    
    private func performAlongSideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }
        coordinator.animate { _ in
            block()
        } completion: { _ in
        }
    }
    
    @objc
    private func dismissHandler(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            self.presentedViewController.dismiss(animated: true, completion: nil)
        default: break
        }
    }
}
