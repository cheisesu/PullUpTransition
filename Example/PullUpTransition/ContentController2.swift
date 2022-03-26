//
//  ContentController2.swift
//  PopUp
//
//  Created by Дмитрий Шелонин on 03.01.2021.
//

import UIKit
import PullUpTransition

final class ContentController2: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var percentLabel: UILabel!
    
    @IBOutlet private weak var viewForDragging: UIView!
    
    private(set) lazy var percentHandler: OpenStateHandler = { [weak self] state in
        print("\(state)")
        self?.percentLabel.text = "\(state)"
    }
    
    @IBAction
    private func closeHandler() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ContentController2: HideTransitionDraggingViewProvider {
    var draggingView: UIView? {
        return self.viewForDragging
    }
}
