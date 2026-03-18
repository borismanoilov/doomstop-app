//
//  CompletionView.swift
//  Doomstop
//

import SwiftUI

struct CompletionView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationRouter: NavigationRouter

    @State private var showIcon = false
    @State private var showTitle = false
    @State private var showTaskLabel = false
    @State private var showUnlockCard = false
    @State private var showBadges = false
    @State private var showButton = false

    var taskTitle: String { navigationRouter.completedTaskTitle }
    var taskType: String { navigationRouter.completedTaskType }
    var usageMinutes: Int { taskType == "deep" ? appState.deepUsageMinutes : appState.quickUsageMinutes }
    var windowHours: Int { taskType == "deep" ? appState.deepWindowHours : appState.quickWindowHours }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Celebration icon
                ZStack {
                    RoundedRectangle(cornerRadius: 34)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#F4A340"), Color(hex: "#d4871a")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    Text("🎉")
                        .font(.system(size: 52))
                }
                .padding(.bottom, 22)
                .scaleEffect(showIcon ? 1 : 0.82)
                .opacity(showIcon ? 1 : 0)

                // Title
                Text("Well done, \(appState.userName.isEmpty ? "you" : appState.userName)!")
                    .font(.custom(Theme.Fonts.headlineBold, size: 40))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 6)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 14)

                // Task label
                Text("\"\(taskTitle)\"")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                    .foregroundColor(Color(hex: "#7a7060"))
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 18)
                    .opacity(showTaskLabel ? 1 : 0)
                    .offset(y: showTaskLabel ? 0 : 14)

                // Unlock card
                VStack(alignment: .leading, spacing: 8) {
                    Text("Apps are now unlocked")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                        .foregroundColor(Color(hex: "#7a7060"))
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            HStack(alignment: .lastTextBaseline, spacing: 6) {
                                Text("\(usageMinutes) min")
                                    .font(.custom(Theme.Fonts.headlineBold, size: 24))
                                    .foregroundColor(Color(hex: "#1C1C1C"))
                                Text("usage")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 14))
                                    .foregroundColor(Color(hex: "#F4A340"))
                            }
                            Text("\(windowHours)h window from now")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                                .foregroundColor(Color(hex: "#7a7060"))
                        }
                        Spacer()
                        Text("🔓")
                            .font(.system(size: 28))
                    }
                }
                .padding(18)
                .background(Color(hex: "#FDFAF4"))
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                )
                .padding(.horizontal, 26)
                .padding(.bottom, 14)
                .opacity(showUnlockCard ? 1 : 0)
                .offset(y: showUnlockCard ? 0 : 14)

                // Badge row
                HStack(spacing: 10) {
                    ForEach([
                        ("🔥", "\(appState.streak)", "day streak"),
                        ("✅", "Task", "done"),
                        ("⏱", taskType == "deep" ? "~20 min" : "~5 min", "focused")
                    ], id: \.1) { badge in
                        VStack(spacing: 5) {
                            Text(badge.0)
                                .font(.system(size: 22))
                            Text(badge.1)
                                .font(.custom(Theme.Fonts.headlineSemiBold, size: 13))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                            Text(badge.2)
                                .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                .foregroundColor(Color(hex: "#7a7060"))
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
                .padding(.horizontal, 26)
                .opacity(showBadges ? 1 : 0)
                .offset(y: showBadges ? 0 : 14)

                Spacer()
                Spacer()
            }

            // Button
            Button(action: {
                navigationRouter.showCompletionSheet = false
            }) {
                Text("Back to Home")
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
        }
        .onAppear {
            withAnimation(.spring(response: 0.46, dampingFraction: 0.7).delay(0.1)) { showIcon = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) { showTitle = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) { showTaskLabel = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.1)) { showUnlockCard = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.5)) { showBadges = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.0)) { showButton = true }
        }
    }
}

#Preview {
    CompletionView()
        .environmentObject(AppState())
        .environmentObject(NavigationRouter())
}