//
//  ChangeView.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import SwiftUI

struct ChangeView: View {
    @State var isGreenColor: Bool
    @State var number: Double
    
    init(number: Double, isGreenColor: Bool = true) {
        self.number = number
        self.isGreenColor = isGreenColor
    }
    
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: isGreenColor ? "arrow.up" : "arrow.down")
                .resizable()
                .foregroundColor(isGreenColor ? .green : .red)
                .frame(width: 10, height: 10, alignment: .center)
            Text("\(String(format: "%.2f", number))")
                .font(.extraSmallBold)
                .foregroundColor(isGreenColor ? .green : .red)
        }
    }
}
