//
//  OB3View.swift
//  Doomstop
//

import SwiftUI

struct OB3View: View {
    let name: String
    let onNext: () -> Void
    
    @State private var showLabel = false
    @State private var showNumber = false
    @State private var showCard = false
    @State private var showStats = false
    @State private var showButton = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                // Label
                Text("ONE NUMBER")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                    .kerning(2.5)
                    .foregroundColor(Color(hex: "#7a7060"))
                    .padding(.bottom, 22)
                    .opacity(showLabel ? 1 : 0)
                    .offset(y: showLabel ? 0 : 14)
                
                // Big number
                Text("80×")
                    .font(.custom(Theme.Fonts.headlineBold, size: 96))
                    .foregroundColor(Color(hex: "#F4A340"))
                    .lineLimit(1)
                    .padding(.bottom, 10)
                    .opacity(showNumber ? 1 : 0)
                    .offset(y: showNumber ? 0 : 14)
                
                Text("The average person picks up their phone 80 times a day.")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 24))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .lineSpacing(3)
                    .padding(.bottom, 22)
                    .opacity(showNumber ? 1 : 0)
                    .offset(y: showNumber ? 0 : 14)
                
                // Card
                VStack(alignment: .leading, spacing: 0) {
                    Text("That's once every ")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                        .foregroundColor(Color(hex: "#7a7060"))
                    + Text("12 minutes")
                        .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                    + Text(" of waking life, \(name). Most are mindless. Most you won't remember an hour later.")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                        .foregroundColor(Color(hex: "#7a7060"))
                }
                .lineSpacing(4)
                .padding(18)
                .background(Color(hex: "#FDFAF4"))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                )
                .padding(.bottom, 12)
                .opacity(showCard ? 1 : 0)
                .offset(y: showCard ? 0 : 14)
                
                // Mini stats row
                HStack(spacing: 10) {
                    ForEach([
                        ("2.4h", "avg daily screen time"),
                        ("30k", "pickups per year"),
                        ("86%", "feel addicted to phone")
                    ], id: \.0) { stat in
                        VStack(spacing: 4) {
                            Text(stat.0)
                                .font(.custom(Theme.Fonts.headlineBold, size: 20))
                                .foregroundColor(Color(hex: "#F4A340"))
                            Text(stat.1)
                                .font(.custom(Theme.Fonts.bodyRegular, size: 10))
                                .foregroundColor(Color(hex: "#7a7060"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "#FDFAF4"))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                        )
                    }
                }
                .opacity(showStats ? 1 : 0)
                .offset(y: showStats ? 0 : 14)
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
            
            // Button
            Button(action: onNext) {
                Text("That sounds familiar")
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
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) { showLabel = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.6)) { showNumber = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.3)) { showCard = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.9)) { showStats = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.5)) { showButton = true }
        }
    }
}

#Preview {
    OB3View(name: "Boris", onNext: {})
}