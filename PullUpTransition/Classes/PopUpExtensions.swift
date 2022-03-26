//
//  PopUpExtensions.swift
//  PopUp
//
//  Created by Дмитрий Шелонин on 10.01.2021.
//

import UIKit

extension UIPanGestureRecognizer {
    func isGonnaBeClosed(_ maxTranslation: CGFloat) -> Bool {
        guard let view = self.view else { return false }
        let endLocation = self.location(in: view) + self.velocity(in: view)
        let isPresentationCompleted = endLocation.y > 0.5 * maxTranslation
        return isPresentationCompleted
    }
}

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x,
                       y: left.y + right.y)
    }
}

extension UIView {
    static func emptyView(with color: UIColor, alpha: CGFloat = 0) -> UIView {
        let view = UIView()
        
        view.backgroundColor = color
        view.alpha = alpha
        
        return view
    }
}
