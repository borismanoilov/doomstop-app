//
//  SettingsView.swift
//  Doomstop
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationRouter: NavigationRouter

    @State private var showBlockedApps = false
    @State private var showUnlockSettings = false

    var body: some View {
        ZStack {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Color.clear.frame(height: 8)

                    Text("Settings")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 26))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .padding(.horizontal, 24)

                    // Pro card
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Doomstop")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                .foregroundColor(Color.white.opacity(0.4))
                            Text("Pro Plan")
                                .font(.custom(Theme.Fonts.headlineBold, size: 22))
                                .foregroundColor(Color.white)
                            Text("Active")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                .foregroundColor(Color(hex: "#F4A340"))
                        }
                        Spacer()
                        Text("🔓")
                            .font(.system(size: 36))
                    }
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#1C1C1C"), Color(hex: "#2a2a2a")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(18)
                    .padding(.horizontal, 24)

                    // Main settings rows
                    VStack(spacing: 0) {
                        SettingsRow(icon: "🔒", title: "Blocked Apps", subtitle: "\(appState.blockedApps.count) apps blocked") {
                            showBlockedApps = true
                        }
                        Divider().padding(.leading, 52)
                        SettingsRow(icon: "⏱", title: "Unlock Settings", subtitle: "Quick Reset & Deep Focus times") {
                            showUnlockSettings = true
                        }
                        Divider().padding(.leading, 52)
                        SettingsRow(icon: "🔔", title: "Notifications", subtitle: "Daily reminders on") {
                            // future
                        }
                    }
                    .background(Color(hex: "#FDFAF4"))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                    // Hard mode toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hard Mode")
                                .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                            Text("Emergency unlock resets your streak to zero")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                .foregroundColor(Color(hex: "#7a7060"))
                        }
                        Spacer()
                        Toggle("", isOn: $appState.hardModeEnabled)
                            .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#F4A340")))
                    }
                    .padding(18)
                    .background(Color(hex: "#FDFAF4"))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                    // Bottom rows
                    VStack(spacing: 0) {
                        SettingsRow(icon: "⭐", title: "Subscription", subtitle: "Manage plan") {}
                        Divider().padding(.leading, 52)
                        SettingsRow(icon: "🔄", title: "Reset Progress", subtitle: "Clear all data", isDestructive: true) {
                            resetProgress()
                        }
                    }
                    .background(Color(hex: "#FDFAF4"))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                    Text("Doomstop v1.0.0")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                        .foregroundColor(Color(hex: "#7a7060"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)

                    Color.clear.frame(height: 24)
                }
            }
        }
        .sheet(isPresented: $showBlockedApps) {
            BlockedAppsSheet()
                .environmentObject(appState)
        }
        .sheet(isPresented: $showUnlockSettings) {
            UnlockSettingsSheet()
                .environmentObject(appState)
        }
    }

    func resetProgress() {
        appState.streak = 0
        appState.tasksCompletedToday = 0
        appState.gateAttemptsToday = 0
        appState.emergenciesToday = 0
        appState.tasksTotal = 0
        appState.emergenciesTotal = 0
        appState.taskHistory = [:]
        appState.eventLog = []
        appState.isUnlocked = false
        appState.unlockExpiresAt = nil
        appState.todayIntention = nil
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var isDestructive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(icon)
                    .font(.system(size: 20))
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                        .foregroundColor(isDestructive ? Color(hex: "#d94f4f") : Color(hex: "#1C1C1C"))
                    Text(subtitle)
                        .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                        .foregroundColor(Color(hex: "#7a7060"))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#7a7060"))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
        }
    }
}

// MARK: - Blocked Apps Sheet
struct BlockedAppsSheet: View {
    @EnvironmentObject var appState: AppState

    let allApps = [
        "TikTok", "Instagram", "YouTube", "Reddit", "X / Twitter",
        "Snapchat", "Facebook", "LinkedIn", "Pinterest", "Twitch",
        "Discord", "Telegram", "WhatsApp", "Threads", "BeReal",
        "Netflix", "Spotify", "News apps", "Gaming apps", "Other"
    ]

    var body: some View {
        ZStack {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Color.clear.frame(height: 24)

                    Text("Blocked Apps")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 26))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .padding(.horizontal, 26)
                        .padding(.bottom, 6)

                    Text("In the real app, this reads from your installed apps automatically.")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 14))
                        .foregroundColor(Color(hex: "#7a7060"))
                        .lineSpacing(4)
                        .padding(.horizontal, 26)
                        .padding(.bottom, 20)

                    VStack(spacing: 10) {
                        ForEach(allApps, id: \.self) { app in
                            HStack {
                                Text(app)
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                                    .foregroundColor(Color(hex: "#1C1C1C"))
                                Spacer()
                                Toggle("", isOn: Binding(
                                    get: { appState.blockedApps.contains(app) },
                                    set: { isOn in
                                        if isOn { appState.blockedApps.append(app) }
                                        else { appState.blockedApps.removeAll { $0 == app } }
                                    }
                                ))
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#F4A340")))
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#FDFAF4"))
                            .cornerRadius(13)
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                            )
                            .padding(.horizontal, 26)
                        }
                    }

                    Color.clear.frame(height: 40)
                }
            }
        }
    }
}

// MARK: - Unlock Settings Sheet
struct UnlockSettingsSheet: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Color.clear.frame(height: 24)

                    Text("Unlock Settings")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 26))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .padding(.horizontal, 26)
                        .padding(.bottom, 6)

                    Text("Customize how much time you earn after completing each task type.")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 14))
                        .foregroundColor(Color(hex: "#7a7060"))
                        .lineSpacing(4)
                        .padding(.horizontal, 26)
                        .padding(.bottom, 24)

                    // Quick Reset
                    UnlockTierCard(
                        title: "Quick Reset",
                        subtitle: "~5 min task",
                        dotColor: Color(hex: "#F4A340"),
                        usageMinutes: $appState.quickUsageMinutes,
                        windowHours: $appState.quickWindowHours,
                        usageRange: 5...60,
                        windowRange: 1...12
                    )
                    .padding(.horizontal, 26)
                    .padding(.bottom, 14)

                    // Deep Focus
                    UnlockTierCard(
                        title: "Deep Focus",
                        subtitle: "~20 min task",
                        dotColor: Color(hex: "#1C1C1C"),
                        usageMinutes: $appState.deepUsageMinutes,
                        windowHours: $appState.deepWindowHours,
                        usageRange: 15...120,
                        windowRange: 1...48
                    )
                    .padding(.horizontal, 26)

                    Color.clear.frame(height: 40)
                }
            }
        }
    }
}

// MARK: - Unlock Tier Card
struct UnlockTierCard: View {
    let title: String
    let subtitle: String
    let dotColor: Color
    @Binding var usageMinutes: Int
    @Binding var windowHours: Int
    let usageRange: ClosedRange<Int>
    let windowRange: ClosedRange<Int>

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Circle()
                    .fill(dotColor)
                    .frame(width: 10, height: 10)
                Text(title)
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 18))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                Text(subtitle)
                    .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                    .foregroundColor(Color(hex: "#7a7060"))
            }

            // Usage stepper
            VStack(alignment: .leading, spacing: 10) {
                Text("Usage limit (time in app)")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                    .foregroundColor(Color(hex: "#7a7060"))
                HStack(spacing: 10) {
                    Button(action: {
                        if usageMinutes > usageRange.lowerBound {
                            usageMinutes = max(usageRange.lowerBound, usageMinutes - 5)
                        }
                    }) {
                        Text("−")
                            .font(.system(size: 20))
                            .frame(width: 34, height: 34)
                            .background(Color(hex: "#FDFAF4"))
                            .cornerRadius(9)
                            .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5))
                    }
                    Text("\(usageMinutes) min")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 18))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .frame(minWidth: 70, alignment: .center)
                    Button(action: {
                        if usageMinutes < usageRange.upperBound {
                            usageMinutes = min(usageRange.upperBound, usageMinutes + 5)
                        }
                    }) {
                        Text("+")
                            .font(.system(size: 20))
                            .frame(width: 34, height: 34)
                            .background(Color(hex: "#FDFAF4"))
                            .cornerRadius(9)
                            .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5))
                    }
                }
            }
            .padding(16)
            .background(Color(hex: "#FDFAF4"))
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1))

            // Window stepper
            VStack(alignment: .leading, spacing: 10) {
                Text("Time window (how long unlock lasts)")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                    .foregroundColor(Color(hex: "#7a7060"))
                HStack(spacing: 10) {
                    Button(action: {
                        if windowHours > windowRange.lowerBound {
                            windowHours = max(windowRange.lowerBound, windowHours - 1)
                        }
                    }) {
                        Text("−")
                            .font(.system(size: 20))
                            .frame(width: 34, height: 34)
                            .background(Color(hex: "#FDFAF4"))
                            .cornerRadius(9)
                            .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5))
                    }
                    Text("\(windowHours)h")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 18))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .frame(minWidth: 70, alignment: .center)
                    Button(action: {
                        if windowHours < windowRange.upperBound {
                            windowHours = min(windowRange.upperBound, windowHours + 1)
                        }
                    }) {
                        Text("+")
                            .font(.system(size: 20))
                            .frame(width: 34, height: 34)
                            .background(Color(hex: "#FDFAF4"))
                            .cornerRadius(9)
                            .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5))
                    }
                }
            }
            .padding(16)
            .background(Color(hex: "#FDFAF4"))
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1))
        }
        .padding(18)
        .background(Color(hex: "#FDFAF4"))
        .cornerRadius(18)
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1))
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .environmentObject(NavigationRouter())
}