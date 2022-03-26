//
//  ViewController.swift
//  PullUpTransition
//
//  Created by Dmitry Shelonin on 03/26/2022.
//  Copyright (c) 2022 Dmitry Shelonin. All rights reserved.
//

import UIKit
import PullUpTransition
import SwiftUI

class ViewController: UIViewController {
    private var transition: PanelTransition!
    private weak var trash: UIViewController?

    @objc
    private func buttonHandler() {
        let draggingView = UIView()
        draggingView.translatesAutoresizingMaskIntoConstraints = false
        draggingView.backgroundColor = .green
        draggingView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.transition = PanelTransition(isInteractive: true, draggingView: draggingView)

        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = main.instantiateViewController(withIdentifier: "ContentController") as? ContentController else {
            return
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transition

        self.transition.percentHandler = vc.percentHandler

        self.present(vc, animated: true, completion: nil)
    }

    @objc
    private func buttonHandler2() {
        self.transition = PanelTransition(isInteractive: true)

        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = main.instantiateViewController(withIdentifier: "ContentController2") as? ContentController2 else {
            return
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transition

        self.transition.percentHandler = vc.percentHandler

        self.present(vc, animated: true, completion: nil)
    }

    @objc
    private func buttonHandler3() {
        self.transition = PanelTransition(isInteractive: true)
        let view = SwiftUIView(dismiss: { [weak self] in
            self?.presentedViewController?.dismiss(animated: true, completion: nil)
        })
        let vc = UIHostingController(rootView: view)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transition

        self.present(vc, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "trash" else { return }
        trash = segue.destination
        let buttons = segue.destination.view.subviews.compactMap { $0 as? UIButton }
        let button1 = buttons.first(where: { $0.title(for: .normal) == "Open 1" })
        let button2 = buttons.first(where: { $0.title(for: .normal) == "Open 2" })
        let button3 = buttons.first(where: { $0.title(for: .normal) == "Open 3" })
        button1?.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
        button2?.addTarget(self, action: #selector(buttonHandler2), for: .touchUpInside)
        button3?.addTarget(self, action: #selector(buttonHandler3), for: .touchUpInside)
    }
}

