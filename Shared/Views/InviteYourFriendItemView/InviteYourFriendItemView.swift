//
//  InviteYourFriendItemView.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 10/4/2565 BE.
//

import SwiftUI

struct InviteYourFriendItemView: View {
    @State var sheet: Bool = false
    private var onClick: () -> ()
    
    init(onClick: @escaping () -> ()) {
        self.onClick = onClick
    }
    
    var body: some View {
        Button(action: { self.onClick() }, label: {
            VStack {
                Spacer(minLength: 20)
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        Image("Icon_InviteFriend")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(10)
                    }
                    .background(.white)
                    .frame(width: 40, height: 40, alignment: .center)
                    .clipShape(Circle())
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    
                    VStack(alignment: .leading) {
                        Text("You can earn $10 when you invite a friend to buy crypto.").font(.bodyText).foregroundColor(.black) + Text(" Invite your friend").font(.bodyText).foregroundColor(Color.init(hex: "#38A0FF"))
                    }
                }
                Spacer(minLength: 20)
            }
        })
        .padding(5)
        .background(Color.init(hex: "#C5E6FF"))
        .cornerRadius(5)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        .frame(maxHeight: 360, alignment: .center)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var item: [Any]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIActivityViewController(activityItems: item, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // do something ..
    }
}
