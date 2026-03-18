//
//  GateView.swift
//  Doomstop
//

import SwiftUI

struct GateView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationRouter: NavigationRouter

    @State private var holdProgress: CGFloat = 0
    @State private var isHolding: Bool = false
    @State private var holdTimer: Timer? = nil

    @State private var showIcon = false
    @State private var showTitle = false
    @State private var showCards = false
    @State private var showEmergency = false

    var isLateNight: Bool {
        let h = Calendar.current.component(.hour, from: Date())
        return h >= 22 || h < 6
    }

    var timeString: String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: Date())
    }

    var blockedApp: String {
        appState.blockedApps.first ?? "this app"
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // App icon
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(hex: "#1C1C1C"))
                        .frame(width: 90, height: 90)
                    Text("🔒")
                        .font(.system(size: 44))
                }
                .padding(.bottom, 20)
                .scaleEffect(showIcon ? 1 : 0.82)
                .opacity(showIcon ? 1 : 0)

                // Title
                Text("\(blockedApp) is blocked.")
                    .font(.custom(Theme.Fonts.headlineBold, size: 32))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 14)

                // Late night callout
                if isLateNight {
                    Text("It's \(timeString). What are you actually looking for right now?")
                        .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                        .foregroundColor(Color(hex: "#F4A340"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 20)
                        .opacity(showTitle ? 1 : 0)
                } else {
                    Color.clear.frame(height: 20)
                }

                // Task tier cards
                HStack(spacing: 10) {
                    // Quick Reset
                    Button(action: {
                        navigationRouter.showTaskSheet = true
                        navigationRouter.showGateSheet = false
                    }) {
                        VStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: "#F4A340"))
                                .frame(width: 8, height: 8)
                            Text("Quick Reset")
                                .font(.custom(Theme.Fonts.headlineSemiBold, size: 13))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                            Text("~5 min")
                                .font(.custom(Theme.Fonts.bodyMedium, size: 11))
                                .foregroundColor(Color(hex: "#F4A340"))
                            Text("\(appState.quickUsageMinutes) min usage")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 10))
                                .foregroundColor(Color(hex: "#7a7060"))
                            Text("\(appState.quickWindowHours)h window")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 10))
                                .foregroundColor(Color(hex: "#7a7060"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 8)
                        .background(Color(hex: "#F4A340").opacity(0.13))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "#F4A340"), lineWidth: 2)
                        )
                    }

                    // Deep Focus
                    Button(action: {
                        navigationRouter.showTaskSheet = true
                        navigationRouter.showGateSheet = false
                    }) {
                        VStack(spacing: 6) {
                            Circle()
                                .fill(Color(hex: "#1C1C1C"))
                                .frame(width: 8, height: 8)
                            Text("Deep Focus")
                                .font(.custom(Theme.Fonts.headlineSemiBold, size: 13))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                            Text("~20 min")
                                .font(.custom(Theme.Fonts.bodyMedium, size: 11))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                            Text("\(appState.deepUsageMinutes) min usage")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 10))
                                .foregroundColor(Color(hex: "#7a7060"))
                            Text("\(appState.deepWindowHours)h window")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 10))
                                .foregroundColor(Color(hex: "#7a7060"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 8)
                        .background(Color(hex: "#FDFAF4"))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5)
                        )
                    }
                }
                .padding(.horizontal, 26)
                .opacity(showCards ? 1 : 0)
                .offset(y: showCards ? 0 : 14)

                Spacer()
                Spacer()
            }

            // Emergency hold button
            VStack(spacing: 0) {
                ZStack(alignment: .leading) {
                    // Button background fill
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(hex: "#d94f4f").opacity(0.22))
                        .frame(width: UIScreen.main.bounds.width - 52)

                    // Progress fill
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(hex: "#d94f4f").opacity(0.22))
                        .frame(width: max(0, (UIScreen.main.bounds.width - 52) * holdProgress))

                    // Label
                    HStack(spacing: 6) {
                        Text("🚨")
                        Text(isHolding ? "Hold… \(Int(holdProgress * 100))%" : "Hold 3s for emergency\(appState.hardModeEnabled ? " (resets streak)" : " (no streak today)")")
                            .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                            .foregroundColor(Color(hex: "#d94f4f"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 17)
                }
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#d94f4f").opacity(0.32), lineWidth: 1.5)
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isHolding { startHold() }
                        }
                        .onEnded { _ in
                            stopHold()
                        }
                )
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 40)
            .opacity(showEmergency ? 1 : 0)
        }
        .onAppear {
            appState.triggerGate()
            withAnimation(.spring(response: 0.46, dampingFraction: 0.7).delay(0.05)) { showIcon = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) { showTitle = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.5)) { showCards = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.0)) { showEmergency = true }
        }
        .onDisappear {
            stopHold()
        }
    }

    func startHold() {
        isHolding = true
        holdTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            DispatchQueue.main.async {
                holdProgress += 0.033
                if holdProgress >= 1.0 {
                    stopHold()
                    triggerEmergency()
                }
            }
        }
    }

    func stopHold() {
        isHolding = false
        holdTimer?.invalidate()
        holdTimer = nil
        withAnimation(.easeOut(duration: 0.2)) {
            holdProgress = 0
        }
    }

    func triggerEmergency() {
        appState.triggerEmergency()
        navigationRouter.showGateSheet = false
    }
}

#Preview {
    GateView()
        .environmentObject(AppState())
        .environmentObject(NavigationRouter())
}