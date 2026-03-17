//
//  NavigationRouter.swift
//  Doomstop
//
//  Created by Boris Manoilov on 15/03/2026.
//  Copyright © 2026 Boris Manoilov. All rights reserved.
//

import SwiftUI

// MARK: - App Phases
enum AppPhase: CaseIterable {
    case onboarding
    case appSelect
    case intention
    case main
}

// MARK: - Main Tabs
enum MainTab: String, CaseIterable {
    case home = "home"
    case progress = "progress"
    case settings = "settings"
}

// MARK: - Modal Screens
enum ModalScreen: String, CaseIterable {
    case gate = "gate"
    case task = "task"
    case completion = "completion"
    case weekly = "weekly"
}

// MARK: - Navigation State Manager
@MainActor
class NavigationRouter: ObservableObject {
    
    // MARK: - Published Properties
    @Published var currentPhase: AppPhase = .onboarding
    @Published var selectedTab: MainTab = .home
    @Published var presentedModal: ModalScreen?
    
    // MARK: - Phase Navigation
    func navigateToPhase(_ phase: AppPhase) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPhase = phase
            // Reset to default tab when entering main phase
            if phase == .main {
                selectedTab = .home
            }
            // Clear any presented modals when changing phases
            presentedModal = nil
        }
    }
    
    // MARK: - Tab Navigation
    func selectTab(_ tab: MainTab) {
        guard currentPhase == .main else { return }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedTab = tab
            // Clear modal when switching tabs
            presentedModal = nil
        }
    }
    
    // MARK: - Modal Presentation
    func presentModal(_ modal: ModalScreen) {
        guard currentPhase == .main else { return }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            presentedModal = modal
        }
    }
    
    func dismissModal() {
        withAnimation(.easeInOut(duration: 0.2)) {
            presentedModal = nil
        }
    }
    
    // MARK: - Modal State
    var isModalPresented: Bool {
        presentedModal != nil
    }
    
    // MARK: - Convenience Methods
    func goToMain() {
        navigateToPhase(.main)
    }
    
    func goToOnboarding() {
        navigateToPhase(.onboarding)
    }
    
    func goToAppSelect() {
        navigateToPhase(.appSelect)
    }
    
    func goToIntention() {
        navigateToPhase(.intention)
    }
}

// MARK: - Navigation Router Key for Environment
struct NavigationRouterKey: EnvironmentKey {
    static let defaultValue = NavigationRouter()
}

extension EnvironmentValues {
    var navigationRouter: NavigationRouter {
        get { self[NavigationRouterKey.self] }
        set { self[NavigationRouterKey.self] = newValue }
    }
}
