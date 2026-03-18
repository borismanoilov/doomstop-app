//
//  ContentView.swift
//  Doomstop
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Color(hex: "#F5F2EA")
                .ignoresSafeArea()

            Group {
                switch navigationRouter.currentPhase {
                case .onboarding:
                    OnboardingView()
                case .appSelect:
                    AppSelectView(initialApps: appState.blockedApps)
                case .intention:
                    IntentionView()
                case .main:
                    MainView()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: navigationRouter.currentPhase)
        }
    }
}

struct MainView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            // Page content
            ZStack {
                switch navigationRouter.selectedTab {
                case .home:
                    HomeView()
                        .environmentObject(appState)
                        .environmentObject(navigationRouter)
                case .progress:
                    ProgressScreenView()
                        .environmentObject(appState)
                case .settings:
                    SettingsView()
                        .environmentObject(appState)
                        .environmentObject(navigationRouter)
                }
            }
            .padding(.bottom, 80)

            // Milestone overlay
            if let milestone = appState.pendingMilestone {
                MilestoneView(streak: milestone) {
                    appState.pendingMilestone = nil
                }
                .transition(.opacity)
                .zIndex(100)
            }

            // Tier unlock overlay
            if let tier = appState.pendingTierUnlock {
                TierUnlockView(tier: tier) {
                    if tier == "t2" { appState.hasSeenT2Unlock = true }
                    if tier == "t3" { appState.hasSeenT3Unlock = true }
                    appState.pendingTierUnlock = nil
                }
                .transition(.opacity)
                .zIndex(99)
            }

            // Custom tab bar
            VStack(spacing: 0) {
                Spacer()
                CustomTabBar()
                    .environmentObject(navigationRouter)
                    .environmentObject(appState)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .animation(.easeInOut(duration: 0.4), value: appState.pendingMilestone)
        .animation(.easeInOut(duration: 0.4), value: appState.pendingTierUnlock)
        .sheet(isPresented: $navigationRouter.showTaskSheet) {
            TaskView()
                .environmentObject(appState)
                .environmentObject(navigationRouter)
        }
        .sheet(isPresented: $navigationRouter.showCompletionSheet) {
            CompletionView()
                .environmentObject(appState)
                .environmentObject(navigationRouter)
        }
        .sheet(isPresented: $navigationRouter.showGateSheet) {
            GateView()
                .environmentObject(appState)
                .environmentObject(navigationRouter)
        }
        .sheet(isPresented: $navigationRouter.showIntentionSheet) {
            IntentionView()
                .environmentObject(appState)
                .environmentObject(navigationRouter)
        }
        .sheet(isPresented: $navigationRouter.showWeeklySheet) {
            WeeklyView()
                .environmentObject(appState)
                .environmentObject(navigationRouter)
        }
        .onAppear {
            appState.checkStreakIntegrity()
            appState.grantWeeklyFreezeIfNeeded()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NavigationRouter())
            .environmentObject(AppState())
    }
}