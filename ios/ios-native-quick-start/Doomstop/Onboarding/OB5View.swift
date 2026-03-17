//
//  OB5View.swift
//  Doomstop
//

import SwiftUI

struct OB5View: View {
    let name: String
    let currentScreenTime: Double
    let desiredScreenTime: Double
    let onNext: () -> Void

    @State private var showLabel = false
    @State private var showCounter = false
    @State private var showHeadline = false
    @State private var showCard = false
    @State private var showStats = false
    @State private var showNote = false
    @State private var showButton = false
    @State private var animatedHours: Int = 0

    var daysIntoYear: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }
    var hrsLostThisYear: Int { Int(currentScreenTime * Double(daysIntoYear)) }
    var hrsDesiredThisYear: Int { Int(desiredScreenTime * Double(daysIntoYear)) }
    var hrsReclaimed: Int { Int((currentScreenTime - desiredScreenTime) * Double(daysIntoYear)) }
    var daysLost: Int { hrsLostThisYear / 24 }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                // Label
                Text("\(name.uppercased())'S NUMBER — \(currentYear())")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                    .kerning(2.5)
                    .foregroundColor(Color(hex: "#7a7060"))
                    .padding(.bottom, 18)
                    .opacity(showLabel ? 1 : 0)
                    .offset(y: showLabel ? 0 : 14)

                // Animated counter
                HStack(alignment: .lastTextBaseline, spacing: 10) {
                    Text("\(animatedHours)")
                        .font(.custom(Theme.Fonts.headlineBold, size: 82))
                        .foregroundColor(Color(hex: "#F4A340"))
                        .monospacedDigit()
                    Text("hrs")
                        .font(.custom(Theme.Fonts.headlineRegular, size: 26))
                        .foregroundColor(Color(hex: "#7a7060"))
                }
                .opacity(showCounter ? 1 : 0)

                Text("spent on your phone in \(daysIntoYear) days.")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 21))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .lineSpacing(2)
                    .padding(.bottom, 20)
                    .opacity(showHeadline ? 1 : 0)
                    .offset(y: showHeadline ? 0 : 14)

                // Card
                VStack(alignment: .leading, spacing: 0) {
                    (Text("That's roughly ")
                        .foregroundColor(Color(hex: "#7a7060"))
                    + Text("\(daysLost) full days")
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                    + Text(" gone since January 1st. Getting to your goal of ")
                        .foregroundColor(Color(hex: "#7a7060"))
                    + Text("\(formatHours(desiredScreenTime))/day")
                        .foregroundColor(Color(hex: "#4f9e6a"))
                        .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                    + Text(" means reclaiming ")
                        .foregroundColor(Color(hex: "#7a7060"))
                    + Text("\(hrsReclaimed) hours")
                        .foregroundColor(Color(hex: "#F4A340"))
                        .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                    + Text(" this year.")
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
                .opacity(showCard ? 1 : 0)
                .offset(y: showCard ? 0 : 14)

                // Mini stats row
                HStack(spacing: 10) {
                    ForEach([
                        (String(hrsLostThisYear) + "h", "spent so far", "#d94f4f"),
                        (String(hrsReclaimed) + "h", "to reclaim", "#F4A340"),
                        (String(hrsDesiredThisYear) + "h", "your goal", "#4f9e6a")
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

                // Note
                Text("\(formatHours(currentScreenTime)) current − \(formatHours(desiredScreenTime)) goal × \(daysIntoYear) days into \(currentYear()).")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                    .foregroundColor(Color(hex: "#7a7060"))
                    .italic()
                    .padding(.top, 12)
                    .opacity(showNote ? 1 : 0)

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)

            // Button
            Button(action: onNext) {
                Text("I want that time back")
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
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) { showCounter = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) { showHeadline = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.2)) { showCard = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.9)) { showStats = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.3)) { showNote = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.6)) { showButton = true }
            animateCounter()
        }
    }

    func animateCounter() {
        let duration: Double = 1.4
        let steps = 60
        let target = hrsLostThisYear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in 0...steps {
                DispatchQueue.main.asyncAfter(deadline: .now() + (duration / Double(steps)) * Double(i)) {
                    let progress = Double(i) / Double(steps)
                    let eased = 1 - pow(1 - progress, 3)
                    animatedHours = Int(eased * Double(target))
                }
            }
        }
    }

    func formatHours(_ value: Double) -> String {
        if value < 1 { return "30 min" }
        else if value == floor(value) { return "\(Int(value))h" }
        else { return "\(String(format: "%.1f", value))h" }
    }

    func currentYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date())
    }
}

#Preview {
    OB5View(name: "Boris", currentScreenTime: 4, desiredScreenTime: 1, onNext: {})
}