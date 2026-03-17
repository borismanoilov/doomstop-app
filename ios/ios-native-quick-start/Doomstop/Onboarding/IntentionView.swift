//
//  IntentionView.swift
//  Doomstop
//

import SwiftUI

struct IntentionView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationRouter: NavigationRouter

    @State private var intentionText = ""
    @State private var showGreeting = false
    @State private var showHeadline = false
    @State private var showSubtitle = false
    @State private var showInput = false
    @State private var showButtons = false
    @FocusState private var inputFocused: Bool

    var greeting: String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 12 { return "Good morning" }
        if h < 17 { return "Good afternoon" }
        return "Good evening"
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                // Greeting
                Text("\(greeting), \(appState.userName)")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                    .kerning(2)
                    .foregroundColor(Color(hex: "#7a7060"))
                    .textCase(.uppercase)
                    .padding(.bottom, 18)
                    .opacity(showGreeting ? 1 : 0)
                    .offset(y: showGreeting ? 0 : 14)

                // Headline
                (Text("What's the ")
                    .font(.custom(Theme.Fonts.headlineBold, size: 36))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                + Text("one thing")
                    .font(.custom(Theme.Fonts.headlineBold, size: 36))
                    .foregroundColor(Color(hex: "#F4A340"))
                + Text(" you want to get done today?")
                    .font(.custom(Theme.Fonts.headlineBold, size: 36))
                    .foregroundColor(Color(hex: "#1C1C1C")))
                .lineSpacing(3)
                .padding(.bottom, 18)
                .opacity(showHeadline ? 1 : 0)
                .offset(y: showHeadline ? 0 : 14)

                // Subtitle
                Text("Not a list. One thing. The thing that would make today feel worthwhile.")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                    .foregroundColor(Color(hex: "#7a7060"))
                    .lineSpacing(4)
                    .padding(.bottom, 24)
                    .opacity(showSubtitle ? 1 : 0)
                    .offset(y: showSubtitle ? 0 : 14)

                // Input
                TextField("e.g. Finish the first draft", text: $intentionText)
                    .font(.custom(Theme.Fonts.bodyRegular, size: 16))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .padding(16)
                    .background(Color(hex: "#FDFAF4"))
                    .cornerRadius(13)
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(inputFocused ? Color(hex: "#F4A340") : Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5)
                    )
                    .focused($inputFocused)
                    .opacity(showInput ? 1 : 0)
                    .offset(y: showInput ? 0 : 14)

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)

            // Buttons
            VStack(spacing: 10) {
                Button(action: {
                    let trimmed = intentionText.trimmingCharacters(in: .whitespaces)
                    appState.setIntention(trimmed.isEmpty ? nil : trimmed)
                    withAnimation(.easeInOut(duration: 0.3)) {
                        navigationRouter.currentPhase = .main
                    }
                }) {
                    Text("Set my intention")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(intentionText.trimmingCharacters(in: .whitespaces).isEmpty ? Color(hex: "#F4A340").opacity(0.35) : Color(hex: "#F4A340"))
                        .cornerRadius(14)
                }
                .disabled(intentionText.trimmingCharacters(in: .whitespaces).isEmpty)

                Button(action: {
                    appState.setIntention(nil)
                    withAnimation(.easeInOut(duration: 0.3)) {
                        navigationRouter.currentPhase = .main
                    }
                }) {
                    Text("Skip for today")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                        .foregroundColor(Color(hex: "#7a7060"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(Color.clear)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5)
                        )
                }
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 40)
            .opacity(showButtons ? 1 : 0)
            .offset(y: showButtons ? 0 : 14)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) { showGreeting = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.6)) { showHeadline = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.0)) { showSubtitle = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.3)) { showInput = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.7)) { showButtons = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                inputFocused = true
            }
        }
    }
}

#Preview {
    IntentionView()
        .environmentObject(AppState())
        .environmentObject(NavigationRouter())
}