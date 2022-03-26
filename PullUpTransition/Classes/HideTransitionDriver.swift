import UIKit

public enum OpenState {
    /// When content is closed
    case closed
    /// When content is in moving
    /// - parameter : value from 0 to 1 means percent of opening (0 - closed, 1 - opened)
    case active(CGFloat)
    /// When content is opened
    case opened
}

public protocol HideTransitionDraggingViewProvider {
    var draggingView: UIView? { get }
}

/// Handler of opening state
/// - parameter state: open state value
public typealias OpenStateHandler = (_ state: OpenState) -> Void

class HideTransitionDriver: UIPercentDrivenInteractiveTransition {
    private var presentedController: UIViewController?
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.name = "HideTransitionDriver.HidePanGesture"
        panGesture.maximumNumberOfTouches = 1
        
        return panGesture
    }()
    
    private var isRunning: Bool {
        return self.percentComplete != 0
    }
    
    private var maxTranslation: CGFloat {
        return self.presentedController?.view.frame.height ?? 0
    }

    var percentHandler: OpenStateHandler?
    
    override var wantsInteractiveStart: Bool {
        get {
            return self.panRecognizer.state == .began
        }
        set {}
    }
    
    override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        self.percentHandler?(.active(1 - self.percentComplete))
    }
    
    override func cancel() {
        super.cancel()
        
        switch 1 - self.percentComplete {
        case 0: self.percentHandler?(.closed)
        case 1: self.percentHandler?(.opened)
        default: self.percentHandler?(.active(1 - self.percentComplete))
        }
    }
    
    override func finish() {
        super.finish()
        switch 1 - self.percentComplete {
        case 0: self.percentHandler?(.closed)
        case 1: self.percentHandler?(.opened)
        default: self.percentHandler?(.active(1 - self.percentComplete))
        }
    }

    @discardableResult
    func link(to viewController: UIViewController, with concreteDraggingView: UIView? = nil) -> Bool {
        self.panRecognizer.view?.removeGestureRecognizer(self.panRecognizer)
        
        self.presentedController = viewController
        var view: UIView? = concreteDraggingView
        if concreteDraggingView != nil {
            view = concreteDraggingView
        } else if let provider = viewController as? HideTransitionDraggingViewProvider {
            viewController.loadViewIfNeeded()
            view = provider.draggingView
        } else {
            viewController.loadViewIfNeeded()
            view = viewController.view
        }
        
        if let targetView = view {
            targetView.isUserInteractionEnabled = true
            targetView.addGestureRecognizer(self.panRecognizer)
            return true
        }
        return false
    }
    
    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            self.pause()
            if !self.isRunning {
                self.presentedController?.dismiss(animated: true)
            }
        case .changed:
            //TODO: update counting of percent
            let percent = gesture.translation(in: gesture.view).y / self.maxTranslation
            self.update(percent)
        case .ended:
            if gesture.isGonnaBeClosed(self.maxTranslation) {
                self.finish()
            } else {
                self.cancel()
            }
        case .failed, .cancelled:
            self.cancel()
        default:
            break
        }
    }
}
