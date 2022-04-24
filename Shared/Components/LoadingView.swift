//
//  LoadingView.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 10/4/2565 BE.
//

import SwiftUI

public struct LoadingView: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    @State private var isLoading = false
    
    let style = StrokeStyle(lineWidth: 6, lineCap: .round)
    let size: Int?
    
    public init(size: Int) {
        self.size = size
    }
 
    public var body: some View {
        ZStack {
            Color(.white).opacity(0.5)
 
            Circle()
                .trim(from: 0, to: 1)
                .stroke(
                    AngularGradient(gradient: .init(colors: [Color._BLUE, Color._WHITE]),
                                    center: .center),
                    style: style
                )
                .frame(width: CGFloat(size ?? 40), height: CGFloat(size ?? 40))
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isLoading)
                .onAppear() {
                    self.isLoading = true
                }
        }
    }
}
