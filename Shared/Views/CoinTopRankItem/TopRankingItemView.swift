//
//  TopRankItemView.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 9/4/2565 BE.
//

import SwiftUI
import Kingfisher

public struct TopRankingItemView: View {
    let item: CoinItemModel
    let width = UIScreen.main.bounds.width / 3.4
    init(item: CoinItemModel) {
        self.item = item
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            Spacer()
            VStack(alignment: .center, spacing: 8) {
                KFImage(URL(string: item.iconUrl))
                    .placeholder({
                        Color.secondary
                    })
                    .cacheOriginalImage()
                    .fade(duration: 0.25)
                    .cancelOnDisappear(true)
                    .resizable()
                    .clipShape(Capsule())
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(.top, 16)
                    .aspectRatio(contentMode: .fit)
                    .accessibility(identifier: "topThree\(item.symbol)_image_icon")
                Text(item.symbol)
                    .font(.smallBold)
                    .foregroundColor(.black)
                    .accessibility(identifier: "topThree\(item.symbol)_text_symbol")
                Text(item.name)
                    .font(.smallBold)
                    .foregroundColor(Color.init(hex: "#999999"))
                    .accessibility(identifier: "topThree\(item.symbol)_text_name")
                    .lineLimit(1)
                ChangeView(number: item.change, isGreenColor: item.isChangePositive)
                    .accessibility(identifier: "topThree\(item.symbol)_text_change")
                    .padding(.bottom, 16)
            }
            Spacer()
        }
        .padding(5)
        .background(Color.init(hex: "#F9F9F9"))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        .frame(minWidth: width, maxWidth: width, minHeight: 140, maxHeight: 140, alignment: .center)
    }
}
