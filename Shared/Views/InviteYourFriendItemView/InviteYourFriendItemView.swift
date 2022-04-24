//
//  InviteYourFriendItemView.swift
//  LMWN-Coinranking (iOS)
//
//  Created by Oatxz on 10/4/2565 BE.
//

import SwiftUI

struct InviteYourFriendItemView: View {
    @State var inviteCode: String
    @State var sheet: Bool = false
    
    init(inviteCode: String) {
        self.inviteCode = inviteCode
    }
    
    var body: some View {
        Button(action: {}, label: {
            VStack {
                Spacer(minLength: 20)
                HStack(alignment: .center) {
                    Image("Icon_InviteFriend")
                        .resizable()
                        .background(.white)
                        .frame(width: 40, height: 40, alignment: .center)
                        .clipShape(Capsule())
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    HStack {
                        Text("You can earn $10 when you invite a friend to buy crypto. ")
                            .font(.bodyText)
                            .foregroundColor(.black)
                        Text("Invite your friend")
                            .font(.bodyText)
                            .foregroundColor(Color.init(hex: "#38A0FF"))
                    }
                }
                Spacer(minLength: 20)
            }
            .sheet(isPresented: $sheet, onDismiss: nil, content: {
                ShareSheet(item: [self.inviteCode])
            })
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
