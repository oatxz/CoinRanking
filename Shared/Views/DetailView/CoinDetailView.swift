//
//  CoinDetailView.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 10/4/2565 BE.
//

import SwiftUI
import Kingfisher

enum MarketCapUnit {
    case million
    case billion
    case trillion
}

struct CoinDetailView: View {
    
    @Binding var uuid: String
    @ObservedObject var viewModel: HomeViewModel
    private var onClose: () -> ()
    
    init(uuid: Binding<String>, viewModel: HomeViewModel, onClose: @escaping () -> ()) {
        self._uuid = uuid
        self.viewModel = viewModel
        self.onClose = onClose
    }
    
    var body: some View {
        switch viewModel.detailState {
        case .idle:
            Color.clear.onAppear(perform: {
                viewModel.loadCoinDetail(uuid: self.uuid)
            })
        case .loading:
            VStack(alignment: .center) {
                LoadingView(size: 40)
                Spacer()
            }
        case .fail:
            ZStack(alignment: .top) {
                VStack(alignment: .center) {
                    ErrorView(onClickTryAgain: {
                        viewModel.loadCoinDetail(uuid: self.uuid)
                    })
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Button(action: { self.onClose() }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 20, height: 20, alignment: .center)
                    })
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
            }
        case .success:
            if viewModel.detailCoin != nil,
               viewModel.detailCoin?.uuid == self.uuid {
                let item = viewModel.detailCoin
                ZStack(alignment: .top) {
                    // out of view
                    Color.black
                        .opacity(0.7)
                        .onTapGesture {
                            self.onClose()
                        }
                    
                    // content
                    VStack {
                        VStack(alignment: .leading, spacing: 16) {
                            // header
                            HStack(alignment: .top, spacing: 16) {
                                KFImage(URL(string: item?.iconUrl ?? ""))
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

                                VStack(alignment: .leading, spacing: 6) {
                                    // name
                                    HStack(spacing: 4) {
                                        Text(item?.name ?? "")
                                            .font(.bodyBold)
                                            .foregroundColor(Color.init(hex: item?.nameColor ?? ""))
                                            .lineLimit(1)
                                        Text("(\(item?.symbol ?? ""))")
                                            .font(.bodyText)
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    // price
                                    HStack(spacing: 4) {
                                        Text("PRICE")
                                            .font(.extraSmallBold)
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                        Text("$ \(String(format: "%.2f", item?.price ?? 0.0))")
                                            .font(.extraSmallText)
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                        Spacer()
                                    }

                                    // market cap
                                    HStack(spacing: 4) {
                                        Text("MARKET CAP")
                                            .font(.extraSmallBold)
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                        Text("$ \(String(format: "%.2f", item?.marketCap ?? 0.0))")
                                            .font(.extraSmallText)
                                            .foregroundColor(.black)
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                }
                            }

                            // description
                            HTMLTextView(htmlContent: item?.description ?? "")

                        }
                        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 4))

                        // Go to website
                        VStack(alignment: .center) {
                            Divider()
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    openWebsite(url: item?.websiteUrl ?? "")
                                }, label: {
                                    Text("GO TO WEBSITE")
                                        .font(.smallBold)
                                        .foregroundColor(Color._BLUE)
                                })
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(minHeight: 50, maxHeight: 50)
                    }
                    .background(.white)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                    
                    // close button
                    HStack {
                        Spacer()
                        Button(action: { self.onClose() }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 20, height: 20, alignment: .center)
                        })
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
                }
            }
        }
    }
    
    func openWebsite(url: String) {
        guard let url = URL(string: url) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
