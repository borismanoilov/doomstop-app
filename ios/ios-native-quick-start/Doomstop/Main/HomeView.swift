//
//  HomeView.swift
//  Doomstop
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationRouter: NavigationRouter

    var greeting: String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 12 { return "Good morning" }
        if h < 17 { return "Good afternoon" }
        return "Good evening"
    }

    var tierBadgeColor: Color {
        switch appState.currentTier {
        case "t3": return Color(hex: "#F4A340")
        case "t2": return Color(hex: "#4f9e6a")
        default:   return Color(hex: "#7a7060")
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    // Top padding
                    Color.clear.frame(height: 8)

                    // Header row
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(greeting + ",")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 14))
                                .foregroundColor(Color(hex: "#7a7060"))
                            Text(appState.userName.isEmpty ? "there" : appState.userName)
                                .font(.custom(Theme.Fonts.headlineSemiBold, size: 28))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                        }

                        Spacer()

                        // Lock status badge
                        if appState.isUnlocked {
                            HStack(spacing: 4) {
                                Text("🔓")
                                    .font(.system(size: 12))
                                Text(appState.lockStatusLabel)
                                    .font(.custom(Theme.Fonts.bodyMedium, size: 12))
                                    .foregroundColor(Color(hex: "#4f9e6a"))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#4f9e6a").opacity(0.12))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#4f9e6a").opacity(0.32), lineWidth: 1)
                            )
                        } else {
                            HStack(spacing: 4) {
                                Text("🔒")
                                    .font(.system(size: 12))
                                Text("Locked")
                                    .font(.custom(Theme.Fonts.bodyMedium, size: 12))
                                    .foregroundColor(Color(hex: "#d94f4f"))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#d94f4f").opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#d94f4f").opacity(0.32), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 24)

                    // Intention card
                    Button(action: {
                        navigationRouter.showIntentionSheet = true
                    }) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("TODAY'S INTENTION")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                .kerning(1.5)
                                .foregroundColor(Color(hex: "#7a7060"))
                            if let intention = appState.todayIntention, !intention.isEmpty {
                                Text("\"\(intention)\"")
                                    .font(.custom(Theme.Fonts.bodyMedium, size: 16))
                                    .foregroundColor(Color(hex: "#1C1C1C"))
                                    .lineSpacing(3)
                            } else {
                                Text("Tap to set one →")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                                    .foregroundColor(Color(hex: "#7a7060"))
                                    .italic()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(18)
                        .background(Color(hex: "#FDFAF4"))
                        .cornerRadius(18)
                        .overlay(
                            HStack {
                                Rectangle()
                                    .fill(Color(hex: "#F4A340"))
                                    .frame(width: 3)
                                Spacer()
                            }
                            .cornerRadius(18)
                        )
                    }
                    .padding(.horizontal, 24)

                    // Streak card
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("CURRENT STREAK")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                    .kerning(1.2)
                                    .foregroundColor(Color(hex: "#1C1C1C").opacity(0.55))
                                HStack(alignment: .lastTextBaseline, spacing: 8) {
                                    Text("\(appState.streak)")
                                        .font(.custom(Theme.Fonts.headlineBold, size: 48))
                                        .foregroundColor(Color(hex: "#1C1C1C"))
                                    Text("🔥")
                                        .font(.system(size: 32))
                                }
                                Text("consecutive task days")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                                    .foregroundColor(Color(hex: "#1C1C1C").opacity(0.55))
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Tier")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                    .foregroundColor(Color(hex: "#1C1C1C").opacity(0.55))
                                Text(appState.tierLabel)
                                    .font(.custom(Theme.Fonts.headlineBold, size: 20))
                                    .foregroundColor(Color(hex: "#1C1C1C"))
                                if let next = appState.nextTierStreak {
                                    Text("\(next - appState.streak)d to next")
                                        .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                        .foregroundColor(Color(hex: "#1C1C1C").opacity(0.55))
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#F4A340"), Color(hex: "#d4871a")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(18)
                    .padding(.horizontal, 24)

                    // Today stats row
                    HStack(spacing: 12) {
                        StatCard(label: "Tasks done", value: "\(appState.tasksCompletedToday)", sub: "today", isRed: false)
                        StatCard(label: "Gate hits", value: "\(appState.gateAttemptsToday)", sub: "today", isRed: false)
                        StatCard(label: "Emergency", value: "\(appState.emergenciesToday)", sub: appState.emergenciesToday > 0 ? "⚠️ streak at risk" : "today", isRed: appState.emergenciesToday > 0)
                    }
                    .padding(.horizontal, 24)

                    // Share card
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack {
                            LinearGradient(
                                colors: [Color(hex: "#1C1C1C"), Color(hex: "#2a1f10")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )

                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color(hex: "#F4A340").opacity(0.2), .clear],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 45
                                    )
                                )
                                .frame(width: 90, height: 90)
                                .offset(x: 120, y: -28)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("THIS WEEK")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                    .kerning(2)
                                    .foregroundColor(Color.white.opacity(0.42))

                                HStack(alignment: .lastTextBaseline, spacing: 4) {
                                    Text("\(appState.streak)")
                                        .font(.custom(Theme.Fonts.headlineBold, size: 22))
                                        .foregroundColor(Color(hex: "#F4A340"))
                                    Text("-day streak 🔥")
                                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 22))
                                        .foregroundColor(Color.white)
                                }

                                Text("Tap to share your progress")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                                    .foregroundColor(Color.white.opacity(0.38))
                                    .padding(.bottom, 14)

                                Button(action: {}) {
                                    Text("Share Streak ↗")
                                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 14))
                                        .foregroundColor(Color(hex: "#1C1C1C"))
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 9)
                                        .background(Color(hex: "#F4A340"))
                                        .cornerRadius(10)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                        }
                    }
                    .cornerRadius(18)
                    .padding(.horizontal, 24)

                    // Do a task CTA
                    Button(action: {
                        navigationRouter.showTaskSheet = true
                    }) {
                        Text("+ Do a task now")
                            .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                            .foregroundColor(Color(hex: "#1C1C1C"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(Color(hex: "#F4A340"))
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 24)

                    Color.clear.frame(height: 24)
                }
            }
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let label: String
    let value: String
    let sub: String
    let isRed: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                .foregroundColor(Color(hex: "#7a7060"))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(value)
                .font(.custom(Theme.Fonts.headlineBold, size: 28))
                .foregroundColor(isRed ? Color(hex: "#d94f4f") : Color(hex: "#1C1C1C"))
            Text(sub)
                .font(.custom(Theme.Fonts.bodyRegular, size: 10))
                .foregroundColor(isRed ? Color(hex: "#d94f4f") : Color(hex: "#7a7060"))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(hex: "#FDFAF4"))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
        .environmentObject(NavigationRouter())
}