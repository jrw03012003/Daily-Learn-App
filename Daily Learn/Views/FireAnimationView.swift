//
//  FireAnimationView.swift
//  test 2 app
//
//  Created by Jack white on 12/11/2024.
//

import SwiftUI

struct FireAnimationView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.clear

            VStack {
                Spacer()
                Image(systemName: "flame.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
                    .frame(width: 200, height: 200)
                    .offset(y: animate ? -300 : 0)
                    .opacity(animate ? 0 : 1)
                    .animation(.easeInOut(duration: 2), value: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}
