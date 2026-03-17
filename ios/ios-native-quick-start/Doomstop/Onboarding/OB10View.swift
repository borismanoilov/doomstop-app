//
//  OB10View.swift
//  Doomstop
//

import SwiftUI

struct OB10View: View {
    let onNext: () -> Void

    @State private var showHeadline = false
    @State private var showStats: [Bool] = [false, false, false]
    @State private var showQuote = false
    @State private var showButton = false

    let stats = [
        ("64%", "replace mindless scrolling with reading or creating"),
        ("73%", "say they exercise more consistently after 30 days"),
        ("92%", "feel more in control of their own attention within the first week"),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                Text("What people get out of it")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 32))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .lineSpacing(3)
                    .padding(.bottom, 24)
                    .opacity(showHeadline ? 1 : 0)
                    .offset(y: showHeadline ? 0 : 14)

                VStack(spacing: 12) {
                    ForEach(Array(stats.enumerated()), id: \.offset) { index, stat in
                        HStack(spacing: 16) {
                            Text(stat.0)
                                .font(.custom(Theme.Fonts.headlineBold, size: 32))
                                .foregroundColor(Color(hex: "#F4A340"))
                                .frame(minWidth: 58, alignment: .leading)

                            Text(stat.1)
                                .font(.custom(Theme.Fonts.bodyRegular, size: 14))
                                .foregroundColor(Color(hex: "#7a7060"))
                                .lineSpacing(3)

                            Spacer()
                        }
                        .padding(18)
                        .background(Color(hex: "#FDFAF4"))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                        )
                        .opacity(showStats[index] ? 1 : 0)
                        .offset(y: showStats[index] ? 0 : 14)
                    }
                }
                .padding(.bottom, 14)

                // Quote
                VStack(alignment: .leading, spacing: 6) {
                    Text("\"I haven't opened Instagram before 9am in three weeks.\"")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 14))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .italic()
                        .lineSpacing(4)
                    Text("— Marcus, 24")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                        .foregroundColor(Color(hex: "#7a7060"))
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#FDFAF4"))
                .cornerRadius(0)
                .overlay(
                    HStack {
                        Rectangle()
                            .fill(Color(hex: "#F4A340"))
                            .frame(width: 3)
                        Spacer()
                    }
                )
                .cornerRadius(14)
                .opacity(showQuote ? 1 : 0)
                .offset(y: showQuote ? 0 : 14)

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)

            Button(action: onNext) {
                Text("That's what I want")
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
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) { showHeadline = true }
            for i in 0..<stats.count {
                withAnimation(.easeOut(duration: 0.5).delay(0.5 + Double(i) * 0.45)) {
                    showStats[i] = true
                }
            }
            withAnimation(.easeOut(duration: 0.5).delay(1.9)) { showQuote = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.6)) { showButton = true }
        }
    }
}

#Preview {
    OB10View(onNext: {})
}