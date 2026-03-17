//
//  OB11View.swift
//  Doomstop
//

import SwiftUI

struct OB11View: View {
    let name: String
    let onNext: () -> Void

    @State private var selectedPlan: String = "yearly"
    @State private var showIcon = false
    @State private var showHeadline = false
    @State private var showPlans = false
    @State private var showFeatures = false
    @State private var showButton = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    Color.clear.frame(height: 72)

                    // Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "#F4A340"))
                            .frame(width: 64, height: 64)
                        Text("🔒")
                            .font(.system(size: 30))
                    }
                    .padding(.bottom, 16)
                    .scaleEffect(showIcon ? 1 : 0.82)
                    .opacity(showIcon ? 1 : 0)

                    Text("Try Doomstop free")
                        .font(.custom(Theme.Fonts.headlineBold, size: 34))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .padding(.bottom, 8)
                        .opacity(showHeadline ? 1 : 0)
                        .offset(y: showHeadline ? 0 : 14)

                    Text("Start taking back your time, \(name).")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                        .foregroundColor(Color(hex: "#7a7060"))
                        .padding(.bottom, 28)
                        .opacity(showHeadline ? 1 : 0)
                        .offset(y: showHeadline ? 0 : 14)

                    // Plans
                    VStack(spacing: 12) {
                        // Yearly
                        Button(action: { selectedPlan = "yearly" }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 8) {
                                        Text("Yearly")
                                            .font(.custom(Theme.Fonts.headlineSemiBold, size: 18))
                                            .foregroundColor(Color(hex: "#1C1C1C"))
                                        Text("Best Value")
                                            .font(.custom(Theme.Fonts.bodyMedium, size: 10))
                                            .foregroundColor(Color(hex: "#1C1C1C"))
                                            .padding(.horizontal, 9)
                                            .padding(.vertical, 2)
                                            .background(Color(hex: "#F4A340"))
                                            .cornerRadius(20)
                                    }
                                    Text("Billed $47.99/year · Save 60%")
                                        .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                        .foregroundColor(Color(hex: "#7a7060"))
                                }
                                Spacer()
                                Text("$3.99/mo")
                                    .font(.custom(Theme.Fonts.headlineBold, size: 20))
                                    .foregroundColor(selectedPlan == "yearly" ? Color(hex: "#F4A340") : Color(hex: "#1C1C1C"))
                            }
                            .padding(18)
                            .background(selectedPlan == "yearly" ? Color(hex: "#F4A340").opacity(0.1) : Color(hex: "#FDFAF4"))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedPlan == "yearly" ? Color(hex: "#F4A340") : Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 2)
                            )
                        }

                        // Monthly
                        Button(action: { selectedPlan = "monthly" }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Monthly")
                                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 18))
                                        .foregroundColor(Color(hex: "#1C1C1C"))
                                    Text("Billed monthly, cancel anytime")
                                        .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                        .foregroundColor(Color(hex: "#7a7060"))
                                }
                                Spacer()
                                Text("$9.99/mo")
                                    .font(.custom(Theme.Fonts.headlineBold, size: 20))
                                    .foregroundColor(selectedPlan == "monthly" ? Color(hex: "#F4A340") : Color(hex: "#1C1C1C"))
                            }
                            .padding(18)
                            .background(selectedPlan == "monthly" ? Color(hex: "#F4A340").opacity(0.1) : Color(hex: "#FDFAF4"))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedPlan == "monthly" ? Color(hex: "#F4A340") : Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 2)
                            )
                        }
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 18)
                    .opacity(showPlans ? 1 : 0)
                    .offset(y: showPlans ? 0 : 14)

                    // Features row
                    HStack(spacing: 0) {
                        ForEach(["No ads", "Cancel anytime", "Full access"], id: \.self) { feature in
                            VStack(spacing: 3) {
                                Text("✓")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(hex: "#F4A340"))
                                Text(feature)
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                    .foregroundColor(Color(hex: "#7a7060"))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.bottom, 16)
                    .opacity(showFeatures ? 1 : 0)

                    Color.clear.frame(height: 110)
                }
            }

            // Pinned button
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [Color(hex: "#F5F2EA").opacity(0), Color(hex: "#F5F2EA")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 36)

                VStack(spacing: 10) {
                    Button(action: onNext) {
                        Text("Start 3-day free trial")
                            .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                            .foregroundColor(Color(hex: "#1C1C1C"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(Color(hex: "#F4A340"))
                            .cornerRadius(14)
                    }

                    Text("No charge until trial ends. Cancel anytime.")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                        .foregroundColor(Color(hex: "#7a7060"))
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 40)
                .background(Color(hex: "#F5F2EA"))
            }
            .opacity(showButton ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.46).delay(0.1)) { showIcon = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) { showHeadline = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.7)) { showPlans = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.2)) { showFeatures = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.6)) { showButton = true }
        }
    }
}

#Preview {
    OB11View(name: "Boris", onNext: {})
}