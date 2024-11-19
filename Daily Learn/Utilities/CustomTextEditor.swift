//
//  CustomTextEditor.swift
//  test 2 app
//
//  Created by Jack white on 15/11/2024.
//

import SwiftUI

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    var backgroundColor: UIColor
    var font: UIFont // Pass the desired font

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = backgroundColor
        textView.font = font // Set the font here
        textView.isEditable = true
        textView.delegate = context.coordinator
        textView.text = text
        textView.autocapitalizationType = .sentences
        textView.isScrollEnabled = true
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.backgroundColor = backgroundColor
        uiView.font = font // Update font dynamically
        if uiView.text != text {
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
        }
    }
}
