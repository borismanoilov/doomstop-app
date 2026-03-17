//
//  OB1View.swift
//  Doomstop
//

import SwiftUI

struct OB1View: View {
    let onNext: () -> Void
    
    @State private var showLabel = false
    @State private var showHeadline = false
    @State private var showSubtitle = false
    @State private var showButton = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()
            
            // Center content
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                // Label
                Text("DOOMSTOP")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                    .kerning(3)
                    .foregroundColor(Color(hex: "#7a7060"))
                    .textCase(.uppercase)
                    .padding(.bottom, 22)
                    .opacity(showLabel ? 1 : 0)
                    .offset(y: showLabel ? 0 : 14)
                
                // Headline
                VStack(alignment: .leading, spacing: 0) {
                    Text("You just opened this")
                        .foregroundColor(Color(hex: "#1C1C1C"))
                    Text("instead of scrolling.")
                        .foregroundColor(Color(hex: "#F4A340"))
                }
                .font(.custom(Theme.Fonts.headlineBold, size: 44))
                .lineSpacing(2)
                .padding(.bottom, 20)
                .opacity(showHeadline ? 1 : 0)
                .offset(y: showHeadline ? 0 : 14)
                
                // Subtitle
                Text("That's already progress.")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 17))
                    .foregroundColor(Color(hex: "#7a7060"))
                    .italic()
                    .opacity(showSubtitle ? 1 : 0)
                    .offset(y: showSubtitle ? 0 : 14)
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
            
            // Pinned bottom button
            VStack {
                Button(action: onNext) {
                    Text("Let's talk →")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(Color(hex: "#F4A340"))
                        .cornerRadius(14)
                }
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 40)
            .opacity(showButton ? 1 : 0)
            .offset(y: showButton ? 0 : 14)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) { showLabel = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) { showHeadline = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.1)) { showSubtitle = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.8)) { showButton = true }
        }
    }
}

#Preview {
    OB1View(onNext: {})
}