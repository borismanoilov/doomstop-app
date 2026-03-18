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
        ZStack {
            TabView(selection: $navigationRouter.selectedTab) {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house.fill") }
                    .tag(MainTab.home)
                ProgressScreenView()
                    .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
                    .tag(MainTab.progress)
                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                    .tag(MainTab.settings)
            }
            .accentColor(Theme.Colors.accent)
        }
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NavigationRouter())
            .environmentObject(AppState())
    }
}