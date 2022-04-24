//
//  HomeView.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 8/4/2565 BE.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State var search: Search = Search(text: "", active: false, isFinish: false)
    @State var isShowDetail: Bool = false
    @State var isShareSheet: Bool = false
    @State var pullRefresh: Refresh = Refresh(isStarted: false, isReleased: false)
    @State var pullNext: Next = Next(isStarted: false, isReleased: false)
    @Namespace private var topID
    @Namespace private var bottomID
    @State var lastIndex: Int = 0
    @State var isPullSuccess: Bool = true
    @State var selectCoin: String = ""
    @State var isFirstOpen: Bool = false
    private let BUY_SELL_TEXT = "Buy, sell and hold crypto"
    
    init(viewModel: HomeViewModel = HomeViewModel(useCase: CoinRankingUseCaseImpl())) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            Color.white.onAppear(perform: viewModel.loadShelf)
        case .loading:
            VStack(alignment: .leading, spacing: 20){
                Text(BUY_SELL_TEXT)
                    .font(.bodyBold)
                    .foregroundColor(.black)
                HStack(alignment: .center) {
                    Spacer()
                    LoadingView(size: 40)
                        .frame(width: 40, height: 40, alignment: .center)
                    Spacer()
                }
                Spacer()
            }
            .background(.white)
            .padding(EdgeInsets(top: 20, leading: 8, bottom: 0, trailing: 0))
        case .success:
            if viewModel.coins.count > 0 {
                ScrollViewReader { scroll in
                    // search bar
                    HStack {
                        TextField("Search", text: $search.text)
                            .padding(.leading, 24)
                            .font(.smallText)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color._LIGHT_GRAY)
                    .cornerRadius(8)
                    .padding(.horizontal, 8)
                    .onAppear(perform: {
                        resetPull()
                    })
                    .onTapGesture {
                        withAnimation(Animation.spring()) {
                            search.active = true
                        }
                    }
                    .onChange(of: search.text, perform: { text in
                        withAnimation() {
                            scroll.scrollTo(0, anchor: .top)
                            
                            // Delay search 1 second
                            if !search.isFinish {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    search.isFinish = true
                                }
                            } else {
                                search.isFinish = false
                                viewModel.fetchSearchCoins(keyword: text, limit: 20, completion: { _ in
                                    // do something
                                })
                            }
                        }
                    })
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Spacer()
                            if search.active {
                                Button(action: {
                                    withAnimation(Animation.linear) {
                                        search.text = ""
                                        search.active = false
                                    }
                                    viewModel.filterCoins = viewModel.coins
                                }, label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .padding(.vertical)
                                })
                            }
                        }
                        .padding(.horizontal, 24)
                        .foregroundColor(Color._MEDUIM_GRAY)
                    )
                    Divider()
                    
                    // content
                    if viewModel.filterCoins.count > 0 {
                        // Pull to Refresh
                        if pullRefresh.isStarted, pullRefresh.isReleased {
                            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                                LoadingView(size: 26)
                                    .padding(10)
                            }
                            .frame(width: 48, height: 48, alignment: .center)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                            .transition(.opacity)
                        }
                        
                        // Main
                        ScrollView(showsIndicators: false) {
                            LazyVStack(alignment: .center, spacing: 12) {
                                // Top 3 Ranking
                                if !search.active {
                                    VStack(spacing: 12) {
                                        HStack {
                                            Text("Top")
                                                .font(.bodyBold)
                                                .foregroundColor(.black)
                                            Text("3")
                                                .font(.bodyBold)
                                                .foregroundColor(.red)
                                            Text("rank crypto")
                                                .font(.bodyText)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        HStack(spacing: 8) {
                                            TopRankingItemView(item: viewModel.coins[0])
                                            TopRankingItemView(item: viewModel.coins[1])
                                            TopRankingItemView(item: viewModel.coins[2])
                                        }
                                    }
                                    .transition(.move(edge: .top))
                                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 20, trailing: 8))
                                }
                                
                                // Coins
                                HStack {
                                    Text(BUY_SELL_TEXT)
                                        .font(.bodyBold)
                                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                                        .foregroundColor(.black)
                                        .id(topID)
                                    Spacer()
                                }
                                ForEach(search.active ? (0..<viewModel.filterCoins.count) :      (3..<viewModel.filterCoins.count), id: \.self) { index in
                                    let coin = viewModel.filterCoins[index]
                                    
                                    // Coin List
                                    CoinItemView(item: coin, onClickItem: {
                                        selectCoin = coin.uuid
                                        isShowDetail = true
                                    })
                                    .id(index)
                                    .sheet(isPresented: $isShowDetail,
                                           onDismiss: nil,
                                           content: {
                                        CoinDetailView(uuid: $selectCoin, viewModel: self.viewModel, onClose: {
                                            withAnimation() {
                                                selectCoin = ""
                                                isShowDetail = false
                                            }
                                        })
                                        .onAppear(perform: {
                                            debugPrint("CoinDetailView onAppear by \(selectCoin) ..")
                                        })
                                        .onDisappear(perform: {
                                            self.viewModel.detailState = .idle
                                        })
                                        .ignoresSafeArea()
                                    })
                                }
                                
                                // Invite Friend ..
                                if search.active {
                                    InviteYourFriendItemView(onClick: {
                                            isShareSheet = true
                                        })
                                        .sheet(isPresented: $isShareSheet,
                                               onDismiss: { isShareSheet = false },
                                               content: {
                                            ShareSheet(item: ["https://careers.lmwn.com when"])
                                        })
                                }
                                
                                // Pull to next
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                                    if isPullSuccess {
                                        LoadingView(size: 40)
                                            .frame(width: 40, height: 40, alignment: .center)
                                    } else {
                                        ErrorView(onClickTryAgain: { setPullState(to: .refresh) })
                                    }
                                }
                                .onAppear(perform: {
                                    if isFirstOpen {
                                        debugPrint("Pull to Refresh - onAppear")
                                        scroll.scrollTo(bottomID, anchor: .bottom)
                                        setPullState(to: .next)
                                    }
                                })
                                .transition(.opacity)
                                .padding(.vertical, 16)
                            }
                            .padding(8)
                            .overlay(
                                // Detect Scrolling point ..
                                GeometryReader { proxy in
                                    let offset = proxy.frame(in: .named("scroll")).minY
                                    Color.clear.preference(key: ViewOffsetKey.self, value: offset)
                                }
                            )
                        }
                        .onPreferenceChange(ViewOffsetKey.self) { value in
                            DispatchQueue.main.async {
                                /****
                                 PULL TO REFRESH
                                 */
                                if pullRefresh.startOffset == 0 {
                                    pullRefresh.startOffset = value
                                }
                                // Drag is started ..
                                pullRefresh.offset = value
                                if (pullRefresh.offset - pullRefresh.startOffset) > 80,
                                   !pullRefresh.isStarted {
                                    pullRefresh.isStarted = true
                                    debugPrint("pullRefresh.isStarted = true")
                                }
                                // Drag is released ..
                                if pullRefresh.startOffset == pullRefresh.offset,
                                   pullRefresh.isStarted,
                                   !pullRefresh.isReleased {
                                    withAnimation(Animation.linear) {
                                        pullRefresh.isReleased = true
                                        scroll.scrollTo(0, anchor: .bottom)
                                    }
                                    debugPrint("pullRefresh.isReleased = true")
                                    self.setPullState(to: .refresh)
                                }
                            }
                        }
                        .id(bottomID)
                    } else {
                        HStack(alignment: .center) {
                            Spacer()
                            VStack(alignment: .center) {
                                Spacer()
                                Text("Sorry")
                                    .font(.custom(Style.bold.rawValue, size: 20))
                                    .foregroundColor(.black)
                                Text("No result match this keyword")
                                    .font(.bodyText)
                                    .foregroundColor(._GRAY)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    
                    // fix: Don't scroll PULL TO NEXT when open page first time
                    Color.clear
                        .frame(width: 0, height: 0, alignment: .bottom)
                        .onAppear {
                            isFirstOpen = true
                        }
                }
                .background(.white)
            } else {
                VStack(alignment: .center, spacing: 5) {
                    HStack(alignment: .top) {
                        Text(BUY_SELL_TEXT)
                            .font(.bodyBold)
                            .padding(EdgeInsets(top: 20, leading: 8, bottom: 0, trailing: 0))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    ErrorView(onClickTryAgain: {
                        viewModel.loadShelf()
                    })
                    Spacer()
                }
                .background(.white)
            }
        case .fail:
            VStack(alignment: .center, spacing: 20){
                HStack(alignment: .top) {
                    Text(BUY_SELL_TEXT)
                        .font(.bodyBold)
                        .foregroundColor(.black)
                    Spacer()
                }
                ErrorView(onClickTryAgain: {
                    viewModel.loadShelf()
                })
                Spacer()
            }
            .background(.white)
            .padding(EdgeInsets(top: 20, leading: 8, bottom: 0, trailing: 0))
        }
    }
    
    private func setPullState(to: PulltoState) {
        debugPrint("Start Pull..")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            // Reset
            resetPull()
            
            switch to {
            case .next:
                // Pull to Next
                viewModel.pullToNext()
                fetchCoinRanking()
                debugPrint(".. to Next")
            case .refresh:
                // Pull to Refresh
                fetchCoinRanking()
                debugPrint(".. to Refresh")
            }
        })
    }
    
    private func resetPull() {
        pullRefresh.isStarted  = false
        pullRefresh.isReleased = false
        pullNext.isStarted  = false
        pullNext.isReleased = false
    }
    
    private func fetchCoinRanking() {
        self.viewModel.fetchCoinRanking(limit: viewModel.limitCoinsList, completion: { result in
            switch result {
            case .failure(_):
                isPullSuccess = false
            case .success(let data):
                isPullSuccess = true
                self.viewModel.coins       = self.viewModel.coinsData(object: data)
                self.viewModel.filterCoins = self.viewModel.coins
            }
        })
    }
}

enum PulltoState {
    case next
    case refresh
}

struct Refresh {
    var startOffset: CGFloat = 0
    var offset: CGFloat = 0
    var isStarted: Bool
    var isReleased: Bool
}

struct Next {
    var releaseOffset: CGFloat = -60
    var offset: CGFloat = 0
    var isStarted: Bool
    var isReleased: Bool
}

struct Search {
    var text: String = ""
    var active: Bool
    var isFinish: Bool
}
