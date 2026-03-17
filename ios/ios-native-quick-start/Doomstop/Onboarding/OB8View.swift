//
//  OB8View.swift
//  Doomstop
//

import SwiftUI

struct OB8View: View {
    let onNext: () -> Void

    @State private var showHeadline = false
    @State private var showSteps: [Bool] = [false, false, false, false]
    @State private var showButton = false

    let steps = [
        ("1", "Apps get blocked", "Your chosen apps are locked — always."),
        ("2", "You try to open one", "Doomstop intercepts and shows the gate."),
        ("3", "Pick a category, get a task", "Body, Mind, Space, Social, or Work."),
        ("4", "Do the task. Earn the time.", "20 min or 1h of real usage — your choice."),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                Text("Here's how Doomstop works")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 36))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .lineSpacing(3)
                    .padding(.bottom, 28)
                    .opacity(showHeadline ? 1 : 0)
                    .offset(y: showHeadline ? 0 : 14)

                VStack(spacing: 12) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        HStack(spacing: 16) {
                            // Number badge
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#F4A340"))
                                    .frame(width: 40, height: 40)
                                Text(step.0)
                                    .font(.custom(Theme.Fonts.headlineBold, size: 17))
                                    .foregroundColor(Color(hex: "#1C1C1C"))
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(step.1)
                                    .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                                    .foregroundColor(Color(hex: "#1C1C1C"))
                                Text(step.2)
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                                    .foregroundColor(Color(hex: "#7a7060"))
                            }

                            Spacer()
                        }
                        .padding(18)
                        .background(Color(hex: "#FDFAF4"))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                        )
                        .opacity(showSteps[index] ? 1 : 0)
                        .offset(y: showSteps[index] ? 0 : 14)
                    }
                }

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)

            Button(action: onNext) {
                Text("Makes sense")
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
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) { showHeadline = true }
            for i in 0..<steps.count {
                withAnimation(.easeOut(duration: 0.5).delay(0.5 + Double(i) * 0.42)) {
                    showSteps[i] = true
                }
            }
            withAnimation(.easeOut(duration: 0.5).delay(2.5)) { showButton = true }
        }
    }
}

#Preview {
    OB8View(onNext: {})
}