import UIKit

public protocol ContentSizeGetter: AnyObject {
    // TODO: учесть направление
    func frameSize(in containerFrame: CGRect) -> CGSize
}

class PresentationController: UIPresentationController {
    private let draggingView: UIView?
    
    init(with draggingView: UIView? = nil, presentedViewController: UIViewController,
         presenting: UIViewController?) {
        self.draggingView = draggingView
        
        super.init(presentedViewController: presentedViewController, presenting: presenting)
        
        if let draggingView = draggingView {
            self.configureDraggingView(draggingView)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var bounds = self.containerView?.bounds ?? .zero
//        bounds = bounds.inset(by: self.containerView?.safeAreaInsets ?? .zero)

        // reducing bounds for dragging view
        if let draggingView = draggingView {
            let size = draggingView.sizeThatFits(CGSize(width: bounds.width, height: .infinity))
            bounds.size.height -= size.height
            bounds.origin.y += size.height
        }

        // TODO: учесть scroll view
        
        var size: CGSize
        // if our presented controller handles its size itself, so okay
        if let sizeGetter = self.presentedViewController as? ContentSizeGetter {
            size = sizeGetter.frameSize(in: bounds)
        } else {
//            let targetSize = UIView.layoutFittingCompressedSize
            let targetSize = bounds.size
            size = self.presentedView?.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel) ?? bounds.size
            size.width = bounds.width
            size.height = min(bounds.height, size.height)
        }
        
        let top = bounds.maxY - size.height
        let left = bounds.midX - 0.5 * size.width
        let rect = CGRect(x: left, y: top, width: size.width, height: size.height)
        return rect
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        if let presentedView = self.presentedView {
            self.containerView?.addSubview(presentedView)
        }
        if let draggingView = self.draggingView {
            self.containerView?.addSubview(draggingView)
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        let presentedViewFrame = self.frameOfPresentedViewInContainerView
        self.presentedView?.frame = presentedViewFrame
        //TODO: учесть направления
        
        var bounds = self.containerView?.bounds ?? .zero
        bounds = bounds.inset(by: self.containerView?.safeAreaInsets ?? .zero)
        let size = self.draggingView?.sizeThatFits(CGSize(width: bounds.width, height: .infinity)) ?? .zero
        self.draggingView?.frame = CGRect(x: presentedViewFrame.origin.x,
                                          y: presentedViewFrame.origin.y - size.height,
                                          width: presentedViewFrame.width,
                                          height: size.height)
    }
    
    private func configureDraggingView(_ draggingView: UIView) {
        //TODO: учесть направления
        let bounds = containerView?.bounds ?? .zero
        draggingView.sizeToFit()
        draggingView.frame.size.width = bounds.width
    }
}
