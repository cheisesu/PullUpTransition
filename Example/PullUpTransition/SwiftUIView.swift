//
//  SwiftUIView.swift
//  PullUpTransition_Example
//
//  Created by Дмитрий Шелонин on 26.03.2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var text: String = ""

    let dismiss: () -> Void

    var body: some View {
        VStack {
            Text("Hello")
            TextField("Input sumthing", text: $text)
            Button("Just press me to dismiss", action: dismiss)
        }
        .padding()
    }
}
