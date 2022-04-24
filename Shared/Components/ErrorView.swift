//
//  ErrorView.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 10/4/2565 BE.
//

import SwiftUI

public struct ErrorView: View {
    private var onClickTryAgain: () -> ()
    
    public init(onClickTryAgain: @escaping () -> ()) {
        self.onClickTryAgain = onClickTryAgain
    }
    public var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Could not load data")
                .font(.bodyText)
                .padding(.top, 33)
                .foregroundColor(.black)
            Button(action: {
                self.onClickTryAgain()
            }, label: {
                Text("Try again")
                    .font(.smallBold)
                    .foregroundColor(._BLUE)
            })
        }
    }
}
