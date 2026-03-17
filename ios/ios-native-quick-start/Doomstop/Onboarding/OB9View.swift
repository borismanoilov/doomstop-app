//
//  OB9View.swift
//  Doomstop
//

import SwiftUI

struct OB9View: View {
    let name: String
    let currentScreenTime: Double
    let desiredScreenTime: Double
    let onNext: () -> Void

    @State private var showName = false
    @State private var showCard1 = false
    @State private var showCard2 = false
    @State private var showStats = false
    @State private var showButton = false

    var daysIntoYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }
    var hrsLost: Int { Int(currentScreenTime * Double(daysIntoYear)) }
    var hrsReclaimed: Int { Int((currentScreenTime - desiredScreenTime) * Double(daysIntoYear)) }
    var daysReclaimed: Int { hrsReclaimed / 24 }

    func formatHours(_ value: Double) -> String {
        if value < 1 { return "30 min" }
        else if value == floor(value) { return "\(Int(value))h" }
        else { return "\(String(format: "%.1f", value))h" }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                (Text("Alright, ")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 36))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                + Text("\(name).")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 36))
                    .foregroundColor(Color(hex: "#F4A340")))
                .lineSpacing(3)
                .padding(.bottom, 20)
                .opacity(showName ? 1 : 0)
                .offset(y: showName ? 0 : 14)

                // Card 1
                VStack(alignment: .leading, spacing: 0) {
                    (Text("You've spent roughly ")
                        .foregroundColor(Color(hex: "#7a7060"))
                    + Text("\(hrsLost) hours")
                        .foregroundColor(Color(hex: "#d94f4f"))
                        .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                    + Text(" on your phone since January 1st. At \(formatHours(currentScreenTime))/day, that's your reality right now.")
                        .foregroundColor(Color(hex: "#7a7060")))
                    .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                    .lineSpacing(4)
                }
                .padding(18)
                .background(Color(hex: "#FDFAF4"))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                )
                .padding(.bottom, 12)
                .opacity(showCard1 ? 1 : 0)
                .offset(y: showCard1 ? 0 : 14)

                // Card 2
                VStack(alignment: .leading, spacing: 0) {
                    (Text("Cutting to \(formatHours(desiredScreenTime))/day means getting back ")
                        .foregroundColor(Color(hex: "#1C1C1C"))
                    + Text("\(hrsReclaimed) hours")
                        .foregroundColor(Color(hex: "#F4A340"))
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 20))
                    + Text(" — this year alone.")
                        .foregroundColor(Color(hex: "#1C1C1C")))
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 20))
                    .lineSpacing(4)
                }
                .padding(16)
                .background(Color(hex: "#F4A340").opacity(0.13))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "#F4A340").opacity(0.38), lineWidth: 1)
                )
                .padding(.bottom, 12)
                .opacity(showCard2 ? 1 : 0)
                .offset(y: showCard2 ? 0 : 14)

                // Stats row
                HStack(spacing: 10) {
                    ForEach([
                        ("\(hrsReclaimed)h", "hours to reclaim", "#F4A340"),
                        ("\(daysReclaimed)d", "full days back", "#F4A340"),
                        ("$0", "cost to start", "#4f9e6a")
                    ], id: \.0) { stat in
                        VStack(spacing: 4) {
                            Text(stat.0)
                                .font(.custom(Theme.Fonts.headlineBold, size: 20))
                                .foregroundColor(Color(hex: stat.2))
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

            Button(action: onNext) {
                Text("Let's do it")
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
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) { showName = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.9)) { showCard1 = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.5)) { showCard2 = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.1)) { showStats = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.6)) { showButton = true }
        }
    }
}

#Preview {
    OB9View(name: "Boris", currentScreenTime: 4, desiredScreenTime: 1, onNext: {})
}