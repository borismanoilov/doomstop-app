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

// MARK: - Placeholder Views (temporary, will be replaced)
struct IntentionView: View {
    var body: some View {
        Text("Intention").foregroundColor(Theme.Colors.text)
    }
}

struct MainView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter

    var body: some View {
        TabView(selection: $navigationRouter.selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(MainTab.home)
            ProgressView()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
                .tag(MainTab.progress)
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                .tag(MainTab.settings)
        }
        .accentColor(Theme.Colors.accent)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NavigationRouter())
            .environmentObject(AppState())
    }
}