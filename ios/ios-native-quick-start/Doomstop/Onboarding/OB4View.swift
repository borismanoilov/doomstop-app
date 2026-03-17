//
//  OB4View.swift
//  Doomstop
//

import SwiftUI

struct OB4View: View {
    let name: String
    let onNext: (Double, Double) -> Void

    @State private var current: Double = 4
    @State private var desired: Double = 1

    @State private var showLabel = false
    @State private var showHeadline = false
    @State private var showCurrentSlider = false
    @State private var showDesiredSlider = false
    @State private var showGapCard = false
    @State private var showButton = false

    var gap: Double { max(0, current - desired) }
    var hrsReclaimed: Int { Int(gap * Double(daysIntoYear)) }
    var daysIntoYear: Int {
        let calendar = Calendar.current
        return calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                // Label
                Text("YOUR SCREEN TIME")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                    .kerning(2.5)
                    .foregroundColor(Color(hex: "#7a7060"))
                    .padding(.bottom, 14)
                    .opacity(showLabel ? 1 : 0)
                    .offset(y: showLabel ? 0 : 14)

                // Headline
                Text("How much time do you actually spend on your phone?")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 34))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .lineSpacing(3)
                    .padding(.bottom, 24)
                    .opacity(showHeadline ? 1 : 0)
                    .offset(y: showHeadline ? 0 : 14)

                // Current slider
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Current daily screen time")
                            .font(.custom(Theme.Fonts.bodyMedium, size: 14))
                            .foregroundColor(Color(hex: "#7a7060"))
                        Spacer()
                        Text("\(formatHours(current))")
                            .font(.custom(Theme.Fonts.headlineBold, size: 26))
                            .foregroundColor(Color(hex: "#d94f4f"))
                    }

                    Slider(value: $current, in: 1...12, step: 0.5)
                        .accentColor(Color(hex: "#d94f4f"))
                        .onChange(of: current) { val in
                            if desired >= val {
                                desired = max(0.5, val - 0.5)
                            }
                        }

                    HStack {
                        Text("1h")
                        Spacer()
                        Text("12h")
                    }
                    .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                    .foregroundColor(Color(hex: "#7a7060"))
                }
                .padding(18)
                .background(Color(hex: "#FDFAF4"))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                )
                .padding(.bottom, 14)
                .opacity(showCurrentSlider ? 1 : 0)
                .offset(y: showCurrentSlider ? 0 : 14)

                // Desired slider
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Where you want to be")
                            .font(.custom(Theme.Fonts.bodyMedium, size: 14))
                            .foregroundColor(Color(hex: "#7a7060"))
                        Spacer()
                        Text("\(formatHours(desired))")
                            .font(.custom(Theme.Fonts.headlineBold, size: 26))
                            .foregroundColor(Color(hex: "#4f9e6a"))
                    }

                    Slider(value: $desired, in: 0.5...max(0.5, current - 0.5), step: 0.5)
                        .accentColor(Color(hex: "#4f9e6a"))

                    HStack {
                        Text("30 min")
                        Spacer()
                        Text("\(formatHours(current - 0.5))")
                    }
                    .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                    .foregroundColor(Color(hex: "#7a7060"))
                }
                .padding(18)
                .background(Color(hex: "#FDFAF4"))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                )
                .padding(.bottom, 14)
                .opacity(showDesiredSlider ? 1 : 0)
                .offset(y: showDesiredSlider ? 0 : 14)

                // Gap card
                if gap > 0 {
                    HStack(spacing: 6) {
                        Text("That's")
                            .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                            .foregroundColor(Color(hex: "#1C1C1C"))
                        Text("\(formatHours(gap))/day")
                            .font(.custom(Theme.Fonts.headlineBold, size: 20))
                            .foregroundColor(Color(hex: "#F4A340"))
                        Text("to reclaim —")
                            .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                            .foregroundColor(Color(hex: "#1C1C1C"))
                        Text("\(hrsReclaimed)h")
                            .font(.custom(Theme.Fonts.headlineBold, size: 20))
                            .foregroundColor(Color(hex: "#F4A340"))
                        Text("since Jan 1st.")
                            .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                            .foregroundColor(Color(hex: "#1C1C1C"))
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(hex: "#F4A340").opacity(0.13))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#F4A340").opacity(0.38), lineWidth: 1)
                    )
                    .opacity(showGapCard ? 1 : 0)
                    .offset(y: showGapCard ? 0 : 14)
                }

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 30)

            // Button
            Button(action: { onNext(current, desired) }) {
                Text("That's accurate")
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
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) { showLabel = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) { showHeadline = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) { showCurrentSlider = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.2)) { showDesiredSlider = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.6)) { showGapCard = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.0)) { showButton = true }
        }
    }

    func formatHours(_ value: Double) -> String {
        if value < 1 {
            return "30 min"
        } else if value == floor(value) {
            return "\(Int(value))h"
        } else {
            return "\(String(format: "%.1f", value))h"
        }
    }
}

#Preview {
    OB4View(name: "Boris", onNext: { _, _ in })
}