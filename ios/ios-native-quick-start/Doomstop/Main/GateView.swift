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
    @State private var lastHapticThreshold: Int = 0

    @State private var showIcon = false
    @State private var showTitle = false
    @State private var showAttempts = false
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

                // Lock icon
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(hex: "#1C1C1C"))
                        .frame(width: 90, height: 90)
                    Image(systemName: "lock.fill")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(Color.white)
                }
                .padding(.bottom, 20)
                .scaleEffect(showIcon ? 1 : 0.82)
                .opacity(showIcon ? 1 : 0)

                // Title
                Text("\(blockedApp) is blocked.")
                    .font(.custom(Theme.Fonts.headlineBold, size: 32))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 14)

                // Gate attempt counter
                if appState.gateAttemptsToday > 1 {
                    Text("You've tried to open this \(appState.gateAttemptsToday) times today.")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                        .foregroundColor(Color(hex: "#7a7060"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 8)
                        .opacity(showAttempts ? 1 : 0)
                }

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
                    Color.clear.frame(height: 16)
                }

                // Task tier cards
                HStack(spacing: 10) {
                    // Quick Reset
                    Button(action: {
                        HapticManager.shared.medium()
                        navigationRouter.showTaskSheet = true
                        navigationRouter.showGateSheet = false
                    }) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#F4A340").opacity(0.2))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(hex: "#F4A340"))
                            }
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
                        .padding(.vertical, 16)
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
                        HapticManager.shared.medium()
                        navigationRouter.showTaskSheet = true
                        navigationRouter.showGateSheet = false
                    }) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#1C1C1C").opacity(0.08))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(hex: "#1C1C1C"))
                            }
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
                        .padding(.vertical, 16)
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
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(hex: "#d94f4f").opacity(0.08))
                        .frame(width: UIScreen.main.bounds.width - 52, height: 56)

                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(hex: "#d94f4f").opacity(0.18))
                        .frame(width: max(0, (UIScreen.main.bounds.width - 52) * holdProgress), height: 56)
                        .animation(.linear(duration: 0.06), value: holdProgress)

                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(hex: "#d94f4f"))
                        Text(isHolding
                            ? "Hold… \(Int(holdProgress * 100))%"
                            : "Hold 3s for emergency\(appState.hardModeEnabled ? " — resets streak" : "")"
                        )
                        .font(.custom(Theme.Fonts.bodyRegular, size: 13))
                        .foregroundColor(Color(hex: "#d94f4f"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(height: 56)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#d94f4f").opacity(0.32), lineWidth: 1.5)
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in if !isHolding { startHold() } }
                        .onEnded { _ in stopHold() }
                )
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 40)
            .opacity(showEmergency ? 1 : 0)
        }
        .onAppear {
            appState.triggerGate()
            HapticManager.shared.medium()
            withAnimation(.spring(response: 0.46, dampingFraction: 0.7).delay(0.05)) { showIcon = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) { showTitle = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) { showAttempts = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.5)) { showCards = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.0)) { showEmergency = true }
        }
        .onDisappear { stopHold() }
    }

    func startHold() {
        isHolding = true
        lastHapticThreshold = 0
        holdTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            DispatchQueue.main.async {
                holdProgress += 0.033
                // Haptic tick every 25%
                let threshold = Int(holdProgress * 4)
                if threshold > lastHapticThreshold {
                    lastHapticThreshold = threshold
                    HapticManager.shared.emergencyHoldTick()
                }
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
        lastHapticThreshold = 0
        withAnimation(.easeOut(duration: 0.2)) { holdProgress = 0 }
    }

    func triggerEmergency() {
        HapticManager.shared.error()
        appState.triggerEmergency()
        navigationRouter.showGateSheet = false
    }
}

#Preview {
    GateView()
        .environmentObject(AppState())
        .environmentObject(NavigationRouter())
}