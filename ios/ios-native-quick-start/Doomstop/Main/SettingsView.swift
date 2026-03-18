//
//  SettingsView.swift
//  Doomstop
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationRouter: NavigationRouter

    @State private var showBlockedApps = false
    @State private var showUnlockSettings = false
    @State private var showNotificationSettings = false
    @State private var showResetConfirm = false

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
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "#F4A340").opacity(0.15))
                                .frame(width: 48, height: 48)
                            Image(systemName: "lock.open.fill")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(Color(hex: "#F4A340"))
                        }
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
                        SFSettingsRow(
                            systemName: "shield.fill",
                            iconColor: Color(hex: "#d94f4f"),
                            title: "Blocked Apps",
                            subtitle: "\(appState.blockedApps.count) apps blocked"
                        ) { showBlockedApps = true }

                        Divider().padding(.leading, 58)

                        SFSettingsRow(
                            systemName: "timer",
                            iconColor: Color(hex: "#F4A340"),
                            title: "Unlock Settings",
                            subtitle: "Quick Reset & Deep Focus times"
                        ) { showUnlockSettings = true }

                        Divider().padding(.leading, 58)

                        SFSettingsRow(
                            systemName: "bell.fill",
                            iconColor: Color(hex: "#4f9e6a"),
                            title: "Notifications",
                            subtitle: appState.notificationsEnabled ? "Enabled" : "Disabled"
                        ) { showNotificationSettings = true }
                    }
                    .background(Color(hex: "#FDFAF4"))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                    // Toggles section
                    VStack(spacing: 0) {
                        // Haptics
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "#7a7060").opacity(0.12))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "hand.tap.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(hex: "#7a7060"))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Haptic Feedback")
                                    .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                                    .foregroundColor(Color(hex: "#1C1C1C"))
                                Text("Vibrations on interactions")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                    .foregroundColor(Color(hex: "#7a7060"))
                            }
                            .padding(.leading, 10)
                            Spacer()
                            Toggle("", isOn: $appState.hapticsEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#F4A340")))
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)

                        Divider().padding(.leading, 58)

                        // Hard mode
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: "#d94f4f").opacity(0.12))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(hex: "#d94f4f"))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Hard Mode")
                                    .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                                    .foregroundColor(Color(hex: "#1C1C1C"))
                                Text("Emergency unlock resets your streak")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                    .foregroundColor(Color(hex: "#7a7060"))
                            }
                            .padding(.leading, 10)
                            Spacer()
                            Toggle("", isOn: $appState.hardModeEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#d94f4f")))
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                    }
                    .background(Color(hex: "#FDFAF4"))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                    // Streak freeze info
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "#4f9e6a").opacity(0.12))
                                .frame(width: 32, height: 32)
                            Image(systemName: "snowflake")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "#4f9e6a"))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Streak Freeze")
                                .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                            Text(appState.freezesAvailable > 0 ? "1 freeze available this week" : "No freezes left this week")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                .foregroundColor(Color(hex: "#7a7060"))
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(appState.freezesAvailable > 0 ? Color(hex: "#4f9e6a").opacity(0.15) : Color(hex: "#1C1C1C").opacity(0.06))
                                .frame(width: 28, height: 28)
                            Text("\(appState.freezesAvailable)")
                                .font(.custom(Theme.Fonts.headlineBold, size: 14))
                                .foregroundColor(appState.freezesAvailable > 0 ? Color(hex: "#4f9e6a") : Color(hex: "#7a7060"))
                        }
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
                        SFSettingsRow(
                            systemName: "creditcard.fill",
                            iconColor: Color(hex: "#F4A340"),
                            title: "Subscription",
                            subtitle: "Manage plan"
                        ) {}

                        Divider().padding(.leading, 58)

                        SFSettingsRow(
                            systemName: "arrow.counterclockwise",
                            iconColor: Color(hex: "#d94f4f"),
                            title: "Reset Progress",
                            subtitle: "Clear all data",
                            isDestructive: true
                        ) { showResetConfirm = true }
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
            BlockedAppsSheet().environmentObject(appState)
        }
        .sheet(isPresented: $showUnlockSettings) {
            UnlockSettingsSheet().environmentObject(appState)
        }
        .sheet(isPresented: $showNotificationSettings) {
            NotificationSettingsSheet().environmentObject(appState)
        }
        .confirmationDialog(
            "Reset all progress?",
            isPresented: $showResetConfirm,
            titleVisibility: .visible
        ) {
            Button("Reset Everything", role: .destructive) { resetProgress() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will clear your streak, task history, and all stats. This cannot be undone.")
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
        appState.eventLog = [:]
        appState.taskCompletionCounts = [:]
        appState.isUnlocked = false
        appState.unlockExpiresAt = nil
        appState.todayIntention = nil
        appState.seenMilestones = []
        appState.lastTaskDate = nil
        HapticManager.shared.medium()
    }
}

// MARK: - SF Symbols Settings Row
struct SFSettingsRow: View {
    let systemName: String
    let iconColor: Color
    let title: String
    let subtitle: String
    var isDestructive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 32, height: 32)
                    Image(systemName: systemName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(iconColor)
                }
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
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#7a7060").opacity(0.5))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
        }
    }
}

// MARK: - Notification Settings Sheet
struct NotificationSettingsSheet: View {
    @EnvironmentObject var appState: AppState
    @State private var permissionGranted = false

    var body: some View {
        ZStack {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Color.clear.frame(height: 24)

                    Text("Notifications")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 26))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .padding(.horizontal, 26)

                    // Master toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Enable Notifications")
                                .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                            Text("Allow Doomstop to send you reminders")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                .foregroundColor(Color(hex: "#7a7060"))
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { appState.notificationsEnabled },
                            set: { val in
                                if val {
                                    NotificationManager.shared.requestPermission { granted in
                                        appState.notificationsEnabled = granted
                                        if granted { appState.scheduleAllNotifications() }
                                    }
                                } else {
                                    appState.notificationsEnabled = false
                                    NotificationManager.shared.cancelAll()
                                }
                            }
                        ))
                        .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#F4A340")))
                    }
                    .padding(18)
                    .background(Color(hex: "#FDFAF4"))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 26)

                    if appState.notificationsEnabled {
                        // Individual toggles
                        VStack(spacing: 0) {
                            NotifToggleRow(
                                systemName: "sunrise.fill",
                                iconColor: Color(hex: "#F4A340"),
                                title: "Daily Intention",
                                subtitle: "Morning reminder to set your intention",
                                isOn: $appState.intentionReminderEnabled
                            )
                            Divider().padding(.leading, 58)
                            NotifToggleRow(
                                systemName: "clock.fill",
                                iconColor: Color(hex: "#7a7060"),
                                title: "Midday Check-in",
                                subtitle: "1pm focus reminder",
                                isOn: $appState.middayCheckinEnabled
                            )
                            Divider().padding(.leading, 58)
                            NotifToggleRow(
                                systemName: "flame.fill",
                                iconColor: Color(hex: "#d94f4f"),
                                title: "Streak at Risk",
                                subtitle: "9pm alert if no task done today",
                                isOn: $appState.streakAtRiskEnabled
                            )
                            Divider().padding(.leading, 58)
                            NotifToggleRow(
                                systemName: "lock.fill",
                                iconColor: Color(hex: "#1C1C1C"),
                                title: "Apps Locked Again",
                                subtitle: "When your unlock window expires",
                                isOn: $appState.unlockExpiredEnabled
                            )
                            Divider().padding(.leading, 58)
                            NotifToggleRow(
                                systemName: "calendar",
                                iconColor: Color(hex: "#4f9e6a"),
                                title: "Weekly Reflection",
                                subtitle: "Sunday evening summary",
                                isOn: $appState.weeklyReflectionEnabled
                            )
                            Divider().padding(.leading, 58)
                            NotifToggleRow(
                                systemName: "trophy.fill",
                                iconColor: Color(hex: "#F4A340"),
                                title: "Streak Milestones",
                                subtitle: "Celebrate 7, 14, 30, 60, 100 days",
                                isOn: $appState.milestoneNotificationsEnabled
                            )
                        }
                        .background(Color(hex: "#FDFAF4"))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                        )
                        .padding(.horizontal, 26)

                        // Intention time picker
                        if appState.intentionReminderEnabled {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("INTENTION REMINDER TIME")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                    .kerning(1.5)
                                    .foregroundColor(Color(hex: "#7a7060"))

                                DatePicker(
                                    "",
                                    selection: Binding(
                                        get: {
                                            var c = DateComponents()
                                            c.hour = appState.intentionReminderHour
                                            c.minute = appState.intentionReminderMinute
                                            return Calendar.current.date(from: c) ?? Date()
                                        },
                                        set: { date in
                                            appState.intentionReminderHour = Calendar.current.component(.hour, from: date)
                                            appState.intentionReminderMinute = Calendar.current.component(.minute, from: date)
                                            appState.scheduleAllNotifications()
                                        }
                                    ),
                                    displayedComponents: .hourAndMinute
                                )
                                .labelsHidden()
                                .accentColor(Color(hex: "#F4A340"))
                            }
                            .padding(18)
                            .background(Color(hex: "#FDFAF4"))
                            .cornerRadius(18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
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

// MARK: - Notification Toggle Row
struct NotifToggleRow: View {
    let systemName: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: systemName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                Text(subtitle)
                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                    .foregroundColor(Color(hex: "#7a7060"))
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#F4A340")))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
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
                                        HapticManager.shared.selection()
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

            StepperRow(
                label: "Usage limit (time in app)",
                value: $usageMinutes,
                step: 5,
                range: usageRange,
                unit: "min"
            )

            StepperRow(
                label: "Time window (how long unlock lasts)",
                value: $windowHours,
                step: 1,
                range: windowRange,
                unit: "h"
            )
        }
        .padding(18)
        .background(Color(hex: "#FDFAF4"))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - Stepper Row
struct StepperRow: View {
    let label: String
    @Binding var value: Int
    let step: Int
    let range: ClosedRange<Int>
    let unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                .foregroundColor(Color(hex: "#7a7060"))
            HStack(spacing: 10) {
                Button(action: {
                    if value > range.lowerBound {
                        value = max(range.lowerBound, value - step)
                        HapticManager.shared.selection()
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 34, height: 34)
                        .background(Color(hex: "#F5F2EA"))
                        .cornerRadius(9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5)
                        )
                        .foregroundColor(Color(hex: "#1C1C1C"))
                }
                Text("\(value)\(unit)")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 18))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .frame(minWidth: 70, alignment: .center)
                Button(action: {
                    if value < range.upperBound {
                        value = min(range.upperBound, value + step)
                        HapticManager.shared.selection()
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 34, height: 34)
                        .background(Color(hex: "#F5F2EA"))
                        .cornerRadius(9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 9)
                                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5)
                        )
                        .foregroundColor(Color(hex: "#1C1C1C"))
                }
            }
        }
        .padding(16)
        .background(Color(hex: "#FDFAF4"))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
        .environmentObject(NavigationRouter())
}