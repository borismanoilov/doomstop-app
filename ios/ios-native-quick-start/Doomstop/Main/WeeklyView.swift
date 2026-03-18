//
//  WeeklyView.swift
//  Doomstop
//

import SwiftUI

struct WeeklyView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationRouter: NavigationRouter

    @State private var showHeadline = false
    @State private var showStats = false
    @State private var showNote = false
    @State private var showButton = false

    var weeklyTasks: Int {
        appState.eventLog.filter { e in
            e.type == .task && Date().timeIntervalSince(e.timestamp) < 7 * 86400
        }.count
    }

    var weeklyEmergencies: Int {
        appState.eventLog.filter { e in
            e.type == .emergency && Date().timeIntervalSince(e.timestamp) < 7 * 86400
        }.count
    }

    var stats: [(String, String, String, Bool)] {[
        ("checkmark.circle.fill", "\(weeklyTasks)", "tasks completed", false),
        ("exclamationmark.triangle.fill", "\(weeklyEmergencies)", "emergency unlocks", weeklyEmergencies > 0),
        ("flame.fill", "\(appState.streak)", "day streak", false),
    ]}

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                // Label
                Text("END OF WEEK")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                    .kerning(2)
                    .foregroundColor(Color(hex: "#7a7060"))
                    .padding(.bottom, 16)
                    .opacity(showHeadline ? 1 : 0)
                    .offset(y: showHeadline ? 0 : 14)

                // Headline
                (Text("Here's your week,\n")
                    .font(.custom(Theme.Fonts.headlineBold, size: 36))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                + Text("honestly.")
                    .font(.custom(Theme.Fonts.headlineBold, size: 36))
                    .foregroundColor(Color(hex: "#F4A340")))
                .lineSpacing(3)
                .padding(.bottom, 28)
                .opacity(showHeadline ? 1 : 0)
                .offset(y: showHeadline ? 0 : 14)

                // Stats
                VStack(spacing: 12) {
                    ForEach(Array(stats.enumerated()), id: \.offset) { _, stat in
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(stat.3 ? Color(hex: "#d94f4f").opacity(0.1) : Color(hex: "#F4A340").opacity(0.12))
                                    .frame(width: 40, height: 40)
                                Image(systemName: stat.0)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(stat.3 ? Color(hex: "#d94f4f") : Color(hex: "#F4A340"))
                            }
                            Text(stat.2)
                                .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                            Spacer()
                            Text(stat.1)
                                .font(.custom(Theme.Fonts.headlineBold, size: 22))
                                .foregroundColor(stat.3 ? Color(hex: "#d94f4f") : Color(hex: "#1C1C1C"))
                        }
                        .padding(16)
                        .background(Color(hex: "#FDFAF4"))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(stat.3 ? Color(hex: "#d94f4f").opacity(0.2) : Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                        )
                    }
                }
                .opacity(showStats ? 1 : 0)
                .offset(y: showStats ? 0 : 14)
                .padding(.bottom, 16)

                // Honest note
                VStack(alignment: .leading, spacing: 0) {
                    Text("No estimates. No fake numbers. Just what actually happened this week.")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .lineSpacing(4)
                }
                .padding(16)
                .background(Color(hex: "#F4A340").opacity(0.13))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#F4A340").opacity(0.38), lineWidth: 1)
                )
                .opacity(showNote ? 1 : 0)
                .offset(y: showNote ? 0 : 14)

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)

            Button(action: {
                HapticManager.shared.buttonTap()
                navigationRouter.showWeeklySheet = false
            }) {
                Text("Start next week →")
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
            HapticManager.shared.medium()
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) { showHeadline = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) { showStats = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.6)) { showNote = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.2)) { showButton = true }
        }
    }
}

#Preview {
    WeeklyView()
        .environmentObject(AppState())
        .environmentObject(NavigationRouter())
}