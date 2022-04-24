//
//  CoinItemView.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 8/4/2565 BE.
//

import SwiftUI
import Kingfisher

struct CoinItemView: View {
    let item: CoinItemModel
    private var onClickItem: () -> ()
    
    init(item: CoinItemModel, onClickItem: @escaping () -> ()) {
        self.item = item
        self.onClickItem = onClickItem
    }
    
    var body: some View {
        Button(action: {
            self.onClickItem()
        }, label: {
            VStack {
                Spacer(minLength: 20)
                HStack(alignment: .top) {
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
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .accessibility(identifier: "coinItem\(item.symbol)_image_icon")
                    VStack(spacing: 5) {
                        HStack {
                            Text(item.name)
                                .font(.bodyBold)
                                .foregroundColor(.black)
                                .accessibility(identifier: "coinItem\(item.symbol)_text_name")
                                .lineLimit(1)
                            Spacer(minLength: 8)
                            Text("$\(String(format: "%.5f", item.price))")
                                .font(.extraSmallBold)
                                .foregroundColor(.black)
                                .accessibility(identifier: "coinItem\(item.symbol)_text_price")
                        }
                        HStack {
                            Text(item.symbol)
                                .font(.smallBold)
                                .foregroundColor(._GRAY)
                                .accessibility(identifier: "coinItem\(item.symbol)_text_symbol")
                            Spacer()
                            ChangeView(number: item.change, isGreenColor: item.isChangePositive)
                                .accessibility(identifier: "coinItem\(item.symbol)_text_change")
                        }
                    }
                }
                Spacer(minLength: 20)
            }
        })
        .padding(5)
        .background(Color._WHITE)
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        .frame(maxHeight: 360, alignment: .center)
    }
}
