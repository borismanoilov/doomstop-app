//
//  MilestoneView.swift
//  Doomstop
//

import SwiftUI

struct MilestoneView: View {
    let streak: Int
    let onDismiss: () -> Void

    @State private var showContent = false
    @State private var confettiActive = false

    var message: (String, String) {
        switch streak {
        case 7:  return ("7 days.", "You're building something.\nMost people quit before this.")
        case 14: return ("Two weeks straight.", "That's not luck.\nThat's discipline.")
        case 30: return ("30 days.", "That's not a habit anymore.\nThat's who you are.")
        case 60: return ("60 days of showing up.", "You've changed something real.")
        case 100: return ("100 days.", "One hundred.\nThat's elite.")
        default: return ("\(streak) days.", "Keep going.")
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1C").ignoresSafeArea()

            // Confetti layer
            ConfettiView(isActive: $confettiActive)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                Spacer()

                // Streak number
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#F4A340").opacity(0.15))
                            .frame(width: 120, height: 120)
                        VStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(hex: "#F4A340"))
                            Text("\(streak)")
                                .font(.custom(Theme.Fonts.headlineBold, size: 40))
                                .foregroundColor(Color.white)
                        }
                    }
                    .scaleEffect(showContent ? 1 : 0.6)
                    .opacity(showContent ? 1 : 0)
                    .padding(.bottom, 28)

                    Text(message.0)
                        .font(.custom(Theme.Fonts.headlineBold, size: 42))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)

                    Text(message.1)
                        .font(.custom(Theme.Fonts.bodyRegular, size: 18))
                        .foregroundColor(Color.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .padding(.top, 12)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                }
                .padding(.horizontal, 32)

                Spacer()
                Spacer()
            }

            // Dismiss button
            VStack {
                Spacer()
                Button(action: {
                    HapticManager.shared.medium()
                    onDismiss()
                }) {
                    Text("Keep going →")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(Color(hex: "#F4A340"))
                        .cornerRadius(14)
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            confettiActive = true
            HapticManager.shared.streakMilestone()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3)) {
                showContent = true
            }
        }
    }
}

// MARK: - Tier Unlock View
struct TierUnlockView: View {
    let tier: String
    let onDismiss: () -> Void

    @State private var showContent = false
    @State private var confettiActive = false

    var tierInfo: (String, String, String) {
        switch tier {
        case "t2": return ("Consistent", "You've shown up for 7 days straight.", "Harder tasks are now unlocked.")
        case "t3": return ("Committed", "30 days. You've made this part of who you are.", "Your most challenging tasks are now unlocked.")
        default:   return ("Next Level", "You've leveled up.", "New tasks are now available.")
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1C").ignoresSafeArea()

            ConfettiView(isActive: $confettiActive)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#F4A340").opacity(0.15))
                            .frame(width: 110, height: 110)
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundColor(Color(hex: "#F4A340"))
                    }
                    .scaleEffect(showContent ? 1 : 0.6)
                    .opacity(showContent ? 1 : 0)
                    .padding(.bottom, 16)

                    Text("Tier unlocked")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                        .kerning(2)
                        .foregroundColor(Color(hex: "#F4A340"))
                        .opacity(showContent ? 1 : 0)

                    Text(tierInfo.0)
                        .font(.custom(Theme.Fonts.headlineBold, size: 52))
                        .foregroundColor(Color.white)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)

                    Text(tierInfo.1)
                        .font(.custom(Theme.Fonts.bodyRegular, size: 17))
                        .foregroundColor(Color.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                        .opacity(showContent ? 1 : 0)

                    Text(tierInfo.2)
                        .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                        .foregroundColor(Color(hex: "#F4A340"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .opacity(showContent ? 1 : 0)
                }

                Spacer()
                Spacer()
            }

            VStack {
                Spacer()
                Button(action: {
                    HapticManager.shared.medium()
                    onDismiss()
                }) {
                    Text("Let's go →")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(Color(hex: "#F4A340"))
                        .cornerRadius(14)
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            confettiActive = true
            HapticManager.shared.tierUnlock()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3)) {
                showContent = true
            }
        }
    }
}

#Preview {
    MilestoneView(streak: 7, onDismiss: {})
}