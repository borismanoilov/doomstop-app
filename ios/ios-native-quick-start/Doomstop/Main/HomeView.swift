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

    var body: some View {
        ZStack {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
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
                            HStack(spacing: 5) {
                                Image(systemName: "lock.open.fill")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(hex: "#4f9e6a"))
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
                            HStack(spacing: 5) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(hex: "#d94f4f"))
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
                        HapticManager.shared.light()
                        navigationRouter.showIntentionSheet = true
                    }) {
                        HStack(alignment: .top, spacing: 14) {
                            Image(systemName: "pencil.line")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "#F4A340"))
                                .frame(width: 20)
                                .padding(.top, 2)
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
                            Spacer()
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
                                HStack(alignment: .lastTextBaseline, spacing: 10) {
                                    Text("\(appState.streak)")
                                        .font(.custom(Theme.Fonts.headlineBold, size: 48))
                                        .foregroundColor(Color(hex: "#1C1C1C"))
                                    Image(systemName: "flame.fill")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(Color(hex: "#1C1C1C").opacity(0.7))
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
                        StatCard(
                            systemName: "checkmark.circle.fill",
                            iconColor: Color(hex: "#4f9e6a"),
                            label: "Tasks done",
                            value: "\(appState.tasksCompletedToday)",
                            sub: "today",
                            isRed: false
                        )
                        StatCard(
                            systemName: "shield.fill",
                            iconColor: Color(hex: "#7a7060"),
                            label: "Gate hits",
                            value: "\(appState.gateAttemptsToday)",
                            sub: "today",
                            isRed: false
                        )
                        StatCard(
                            systemName: "exclamationmark.triangle.fill",
                            iconColor: appState.emergenciesToday > 0 ? Color(hex: "#d94f4f") : Color(hex: "#7a7060"),
                            label: "Emergency",
                            value: "\(appState.emergenciesToday)",
                            sub: appState.emergenciesToday > 0 ? "streak at risk" : "today",
                            isRed: appState.emergenciesToday > 0
                        )
                    }
                    .padding(.horizontal, 24)

                    // Streak freeze card if available
                    if appState.freezesAvailable > 0 {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(hex: "#4f9e6a").opacity(0.12))
                                    .frame(width: 36, height: 36)
                                Image(systemName: "snowflake")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "#4f9e6a"))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Streak freeze available")
                                    .font(.custom(Theme.Fonts.bodyMedium, size: 14))
                                    .foregroundColor(Color(hex: "#1C1C1C"))
                                Text("Auto-applies if you miss a day this week")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                    .foregroundColor(Color(hex: "#7a7060"))
                            }
                            Spacer()
                        }
                        .padding(16)
                        .background(Color(hex: "#FDFAF4"))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "#4f9e6a").opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, 24)
                    }

                    // Share card
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

                            HStack(alignment: .center, spacing: 6) {
                                Text("\(appState.streak)-day streak")
                                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 22))
                                    .foregroundColor(Color.white)
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(hex: "#F4A340"))
                            }

                            Text("Tap to share your progress")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                                .foregroundColor(Color.white.opacity(0.38))
                                .padding(.bottom, 14)

                            Button(action: {
                                HapticManager.shared.light()
                            }) {
                                HStack(spacing: 6) {
                                    Text("Share Streak")
                                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 14))
                                        .foregroundColor(Color(hex: "#1C1C1C"))
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(Color(hex: "#1C1C1C"))
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 9)
                                .background(Color(hex: "#F4A340"))
                                .cornerRadius(10)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                    }
                    .cornerRadius(18)
                    .padding(.horizontal, 24)

                    // Do a task CTA
                    Button(action: {
                        HapticManager.shared.buttonTap()
                        navigationRouter.showTaskSheet = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                            Text("Do a task now")
                                .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                        }
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
    let systemName: String
    let iconColor: Color
    let label: String
    let value: String
    let sub: String
    let isRed: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(iconColor)
            Text(value)
                .font(.custom(Theme.Fonts.headlineBold, size: 28))
                .foregroundColor(isRed ? Color(hex: "#d94f4f") : Color(hex: "#1C1C1C"))
            Text(label)
                .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                .foregroundColor(Color(hex: "#7a7060"))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
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