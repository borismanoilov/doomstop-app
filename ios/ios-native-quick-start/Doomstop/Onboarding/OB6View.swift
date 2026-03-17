//
//  OB6View.swift
//  Doomstop
//

import SwiftUI

struct OB6View: View {
    let name: String
    let onNext: ([String]) -> Void

    @State private var selected: [String] = []
    @State private var showHeadline = false
    @State private var showSubtitle = false
    @State private var showApps = false
    @State private var showButton = false

    let apps = [
        "TikTok", "Instagram", "YouTube", "Reddit", "X / Twitter",
        "Snapchat", "Facebook", "LinkedIn", "Pinterest", "Twitch",
        "Discord", "Telegram", "WhatsApp", "Threads", "BeReal",
        "Netflix", "Spotify", "News apps", "Gaming apps", "Other"
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Top padding for progress bar
                    Color.clear.frame(height: 72)

                    Text("Which apps pull you in most?")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 32))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .lineSpacing(3)
                        .padding(.bottom, 8)
                        .opacity(showHeadline ? 1 : 0)
                        .offset(y: showHeadline ? 0 : 14)

                    Text("These become your default blocked list, \(name). In the real app, this reads from your installed apps. Adjustable anytime in Settings.")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 14))
                        .foregroundColor(Color(hex: "#7a7060"))
                        .lineSpacing(4)
                        .padding(.bottom, 22)
                        .opacity(showSubtitle ? 1 : 0)
                        .offset(y: showSubtitle ? 0 : 14)

                    VStack(spacing: 10) {
                        ForEach(apps, id: \.self) { app in
                            Button(action: { toggleApp(app) }) {
                                HStack {
                                    Text(app)
                                        .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                                        .foregroundColor(Color(hex: "#1C1C1C"))
                                    Spacer()
                                    if selected.contains(app) {
                                        Text("✓")
                                            .font(.system(size: 17))
                                            .foregroundColor(Color(hex: "#F4A340"))
                                    }
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 14)
                                .background(selected.contains(app) ? Color(hex: "#F4A340").opacity(0.13) : Color(hex: "#FDFAF4"))
                                .cornerRadius(13)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        .stroke(selected.contains(app) ? Color(hex: "#F4A340").opacity(0.38) : Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5)
                                )
                            }
                        }
                    }
                    .opacity(showApps ? 1 : 0)
                    .offset(y: showApps ? 0 : 14)

                    // Bottom padding for button
                    Color.clear.frame(height: 100)
                }
                .padding(.horizontal, 26)
            }

            // Pinned button
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [Color(hex: "#F5F2EA").opacity(0), Color(hex: "#F5F2EA")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 36)

                Button(action: { onNext(selected) }) {
                    Text(selected.isEmpty ? "Select apps" : "Block \(selected.count) app\(selected.count == 1 ? "" : "s") →")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(selected.isEmpty ? Color(hex: "#F4A340").opacity(0.35) : Color(hex: "#F4A340"))
                        .cornerRadius(14)
                }
                .disabled(selected.isEmpty)
                .padding(.horizontal, 26)
                .padding(.bottom, 40)
                .background(Color(hex: "#F5F2EA"))
            }
            .opacity(showButton ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) { showHeadline = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) { showSubtitle = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.8)) { showApps = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.2)) { showButton = true }
        }
    }

    func toggleApp(_ app: String) {
        if selected.contains(app) {
            selected.removeAll { $0 == app }
        } else {
            selected.append(app)
        }
    }
}

#Preview {
    OB6View(name: "Boris", onNext: { _ in })
}