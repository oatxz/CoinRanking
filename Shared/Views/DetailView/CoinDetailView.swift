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
    
    @State var uuid: String
    @ObservedObject var viewModel: HomeViewModel
    private var onClose: () -> ()
    private var onClickOpenWebsite: () -> ()
    
    init(uuid: String, viewModel: HomeViewModel, onClose: @escaping () -> (), onClickOpenWebsite: @escaping () -> ()) {
        self.uuid = uuid
        self.viewModel = viewModel
        self.onClose = onClose
        self.onClickOpenWebsite = onClickOpenWebsite
    }
    
    var body: some View {
        switch viewModel.detailState {
        case .idle:
            Color.clear
        case .loading:
            VStack(alignment: .center) {
                LoadingView(size: 40)
                Spacer()
            }
        case .fail:
            VStack(alignment: .center) {
                ErrorView(onClickTryAgain: {
                    viewModel.fetchCoinDetail(uuid: self.uuid, completion: { result in
                        switch result {
                        case .failure(_):
                            self.viewModel.detailState = .fail
                        case .success(let data):
                            self.viewModel.detailCoin = data
                            self.viewModel.detailState = .success
                        }
                    })
                })
                Spacer()
            }
        case .success:
            if viewModel.detailCoin != nil {
                let item = viewModel.detailCoin
                ZStack(alignment: .bottom) {
                    // out of view
                    Color.black
                        .opacity(0.3)
                        .onTapGesture {
                            self.onClose()
                        }

                    VStack {
                        
                        // close button
//                        HStack {
//                            Spacer()
//                            Button(action: { self.onClose() }, label: {
//                                Image(systemName: "xmark")
//                                    .resizable()
//                                    .frame(width: 20, height: 20, alignment: .center)
//                            })
//                        }
//                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
                        
                        // content
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
                                    self.onClickOpenWebsite()
                                    openWebsite(url: item?.websiteUrl ?? "")
                                }, label: {
                                    Text("GO TO WEBSITE")
                                        .font(.smallBold)
                                        .foregroundColor(Color.init(hex: "#38A0FF"))
                                })
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(minHeight: 50, maxHeight: 50)
                    }
                    .background(.white)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                }
            }
        }
    }
    
    func openWebsite(url: String) {
        guard let url = URL(string: url) else { return }
        //guard let url = URL(string: url) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
