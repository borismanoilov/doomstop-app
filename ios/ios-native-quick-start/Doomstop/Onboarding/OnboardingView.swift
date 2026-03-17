//
//  OnboardingView.swift
//  Doomstop
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationRouter: NavigationRouter

    @State private var step = 1
    @State private var userName = ""
    @State private var currentScreenTime: Double = 4
    @State private var desiredScreenTime: Double = 1
    @State private var selectedApps: [String] = []

    var body: some View {
        ZStack {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            Group {
                switch step {
                case 1:
                    OB1View(onNext: { nextStep() })
                case 2:
                    OB2View(onNext: { name in
                        userName = name
                        nextStep()
                    })
                case 3:
                    OB3View(name: userName, onNext: { nextStep() })
                case 4:
                    OB4View(name: userName, onNext: { current, desired in
                        currentScreenTime = current
                        desiredScreenTime = desired
                        nextStep()
                    })
                case 5:
                    OB5View(
                        name: userName,
                        currentScreenTime: currentScreenTime,
                        desiredScreenTime: desiredScreenTime,
                        onNext: { nextStep() }
                    )
                case 6:
                    OB6View(name: userName, onNext: { apps in
                        selectedApps = apps
                        nextStep()
                    })
                case 7:
                    OB7View(onNext: { nextStep() })
                case 8:
                    OB8View(onNext: { nextStep() })
                case 9:
                    OB9View(
                        name: userName,
                        currentScreenTime: currentScreenTime,
                        desiredScreenTime: desiredScreenTime,
                        onNext: { nextStep() }
                    )
                case 10:
                    OB10View(onNext: { nextStep() })
                case 11:
                    OB11View(name: userName, onNext: { finishOnboarding() })
                default:
                    OB11View(name: userName, onNext: { finishOnboarding() })
                }
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.3), value: step)

            // Progress bar overlay
            VStack {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(hex: "#1C1C1C").opacity(0.08))
                            .frame(height: 3)
                        Rectangle()
                            .fill(Color(hex: "#F4A340"))
                            .frame(width: geo.size.width * CGFloat(step) / 11.0, height: 3)
                            .animation(.easeInOut(duration: 0.4), value: step)
                    }
                }
                .frame(height: 3)
                .padding(.horizontal, 26)
                .padding(.top, 56)

                Spacer()
            }
        }
    }

    func nextStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            step += 1
        }
    }

    func finishOnboarding() {
        // Save everything to AppState
        appState.userName = userName
        appState.currentScreenTime = currentScreenTime
        appState.desiredScreenTime = desiredScreenTime
        appState.blockedApps = selectedApps

        // Move to app select phase
        withAnimation(.easeInOut(duration: 0.3)) {
            navigationRouter.currentPhase = .appSelect
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
        .environmentObject(NavigationRouter())
}