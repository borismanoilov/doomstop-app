//
//  OB7View.swift
//  Doomstop
//

import SwiftUI

struct OB7View: View {
    let onNext: () -> Void

    @State private var showHeadline1 = false
    @State private var showHeadline2 = false
    @State private var showCard = false
    @State private var showTagline = false
    @State private var showButton = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                Text("These apps aren't distractions.")
                    .font(.custom(Theme.Fonts.headlineBold, size: 38))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .lineSpacing(3)
                    .padding(.bottom, 8)
                    .opacity(showHeadline1 ? 1 : 0)
                    .offset(y: showHeadline1 ? 0 : 14)

                Text("They're products.")
                    .font(.custom(Theme.Fonts.headlineBold, size: 38))
                    .foregroundColor(Color(hex: "#F4A340"))
                    .lineSpacing(3)
                    .padding(.bottom, 28)
                    .opacity(showHeadline2 ? 1 : 0)
                    .offset(y: showHeadline2 ? 0 : 14)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Teams of engineers study your behavior to keep you engaged longer. Variable rewards. Infinite scroll. Notification timing. Every pixel exists to beat your willpower.\n\nYou can't out-discipline a billion-dollar algorithm.")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                        .foregroundColor(Color(hex: "#7a7060"))
                        .lineSpacing(5)
                }
                .padding(18)
                .background(Color(hex: "#FDFAF4"))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                )
                .padding(.bottom, 20)
                .opacity(showCard ? 1 : 0)
                .offset(y: showCard ? 0 : 14)

                (Text("But you can ")
                    .font(.custom(Theme.Fonts.bodyMedium, size: 16))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                + Text("change the rules.")
                    .font(.custom(Theme.Fonts.bodyMedium, size: 16))
                    .foregroundColor(Color(hex: "#F4A340")))
                .opacity(showTagline ? 1 : 0)
                .offset(y: showTagline ? 0 : 14)

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)

            Button(action: onNext) {
                Text("Show me how")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(Color(hex: "#F4A340"))
                    .cornerRadius(14)
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 40)
            .opacity(showButton ? 1 : 0)
            .offset(y: showButton ? 0 : 14)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) { showHeadline1 = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.9)) { showHeadline2 = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.6)) { showCard = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.4)) { showTagline = true }
            withAnimation(.easeOut(duration: 0.5).delay(3.0)) { showButton = true }
        }
    }
}

#Preview {
    OB7View(onNext: {})
}