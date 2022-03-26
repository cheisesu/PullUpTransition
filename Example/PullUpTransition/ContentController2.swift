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
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var description: String {
        return self.debugDescription
    }
    
    override var debugDescription: String {
        return "ContentController2"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("== \(presentingViewController)")
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

//extension ContentController2: ContentSizeGetter {
//    func frameSize(in containerFrame: CGRect, with dragThickness: CGFloat) -> CGSize {
//        var size = CGSize(width: containerFrame.width, height: 0.7 * containerFrame.height)
//        size.height -= dragThickness
//        
//        return size
//    }
//}
