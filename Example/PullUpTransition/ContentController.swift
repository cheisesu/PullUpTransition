//
//  ContentController.swift
//  PopUp
//
//  Created by Дмитрий Шелонин on 03.01.2021.
//

import UIKit
import PullUpTransition

final class ContentController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var percentLabel: UILabel!
    
    private(set) lazy var percentHandler: OpenStateHandler = { [weak self] state in
        print("\(state)")
        self?.percentLabel.text = "\(state)"
    }
    
    @IBAction
    private func closeHandler() {
        self.dismiss(animated: true, completion: nil)
    }
}
