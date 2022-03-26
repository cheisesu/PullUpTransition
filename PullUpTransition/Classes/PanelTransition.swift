import UIKit

public final class PanelTransition: NSObject {
    private let hideDriver: HideTransitionDriver = HideTransitionDriver()
    private let duration: TimeInterval
    private let substrate: Substrate
    private let isInteractive: Bool
    private let dismissalOutside: Bool
    private var draggingView: UIView?

    public var percentHandler: OpenStateHandler? {
        get { return self.hideDriver.percentHandler }
        set { self.hideDriver.percentHandler = newValue }
    }

    //TODO: добавить направления
    //TODO: добавить вьюху для тяги
    
    init(duration: TimeInterval = 0.3,
         isInteractive: Bool = true,
         dismissalOutside: Bool = true,
         substrate: Substrate = .color(UIColor.black.withAlphaComponent(0.3)),
         draggingView: UIView? = nil) {
        self.duration = duration
        self.isInteractive = isInteractive
        self.dismissalOutside = dismissalOutside
        self.substrate = substrate
        self.draggingView = draggingView
        
        super.init()
    }
}

extension PanelTransition: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        if self.isInteractive {
            self.hideDriver.link(to: presented, with: self.draggingView)
        }
        
        switch self.substrate {
        case .none:
            return PresentationController(with: self.draggingView,
                                          presentedViewController: presented,
                                          presenting: presenting ?? source)
        case let .color(color):
            return SubstratedPresentationController(with: .emptyView(with: color),
                                                    with: self.draggingView,
                                                    presentedViewController: presented,
                                                    presenting: presenting ?? source)
        case let .custom(view):
            view.alpha = 0
            return SubstratedPresentationController(with: view,
                                                    with: self.draggingView,
                                                    presentedViewController: presented,
                                                    presenting: presenting ?? source)
        }
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimation(self.duration, percentHandler: self.percentHandler, draggingView: self.draggingView)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation(self.duration, percentHandler: self.percentHandler, draggingView: self.draggingView)
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if isInteractive {
            return self.hideDriver
        }
        return nil
    }
}
