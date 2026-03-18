//
//  CustomTabBar.swift
//  Doomstop
//

import SwiftUI

struct CustomTabBar: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tab) { item in
                Button(action: {
                    HapticManager.shared.selection()
                    navigationRouter.selectedTab = item.tab
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: navigationRouter.selectedTab == item.tab ? item.activeIcon : item.icon)
                            .font(.system(size: 22, weight: navigationRouter.selectedTab == item.tab ? .semibold : .regular))
                            .foregroundColor(navigationRouter.selectedTab == item.tab ? Color(hex: "#F4A340") : Color(hex: "#7a7060"))
                            .frame(height: 26)

                        Text(item.label)
                            .font(.custom(Theme.Fonts.bodyRegular, size: 10))
                            .foregroundColor(navigationRouter.selectedTab == item.tab ? Color(hex: "#F4A340") : Color(hex: "#7a7060"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(.horizontal, 8)
        .background(
            Color(hex: "#FDFAF4")
                .shadow(color: Color(hex: "#1C1C1C").opacity(0.06), radius: 16, x: 0, y: -4)
        )
        .overlay(
            Rectangle()
                .fill(Color(hex: "#1C1C1C").opacity(0.06))
                .frame(height: 1),
            alignment: .top
        )
    }

    var tabs: [(tab: MainTab, label: String, icon: String, activeIcon: String)] {[
        (.home,     "Home",     "house",          "house.fill"),
        (.progress, "Progress", "chart.bar",      "chart.bar.fill"),
        (.settings, "Settings", "gearshape",      "gearshape.fill"),
    ]}
}