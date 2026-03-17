//
//  OB2View.swift
//  Doomstop
//

import SwiftUI

struct OB2View: View {
    let onNext: (String) -> Void
    
    @State private var name = ""
    @State private var showHeadline = false
    @State private var showSubtitle = false
    @State private var showInput = false
    @State private var showCard = false
    @State private var showButton = false
    @FocusState private var inputFocused: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                Text("First — who are we helping?")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 36))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .lineSpacing(2)
                    .padding(.bottom, 12)
                    .opacity(showHeadline ? 1 : 0)
                    .offset(y: showHeadline ? 0 : 14)
                
                Text("We'll use your name throughout. Because this is personal.")
                    .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                    .foregroundColor(Color(hex: "#7a7060"))
                    .lineSpacing(4)
                    .padding(.bottom, 24)
                    .opacity(showSubtitle ? 1 : 0)
                    .offset(y: showSubtitle ? 0 : 14)
                
                // Name input
                TextField("Your first name", text: $name)
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
                    .padding(.bottom, 24)
                    .opacity(showInput ? 1 : 0)
                    .offset(y: showInput ? 0 : 14)
                
                // Privacy card
                VStack(alignment: .leading, spacing: 0) {
                    Text("Doomstop doesn't collect personal data. Your name stays on your device — it's just here to make the app feel like it's actually for you.")
                        .font(.custom(Theme.Fonts.bodyRegular, size: 14))
                        .foregroundColor(Color(hex: "#7a7060"))
                        .lineSpacing(4)
                }
                .padding(18)
                .background(Color(hex: "#F4A340").opacity(0.13))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#F4A340").opacity(0.38), lineWidth: 1)
                )
                .opacity(showCard ? 1 : 0)
                .offset(y: showCard ? 0 : 14)
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
            
            // Button
            Button(action: {
                let trimmed = name.trimmingCharacters(in: .whitespaces)
                onNext(trimmed.isEmpty ? "there" : trimmed)
            }) {
                Text("That's me →")
                    .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                    .foregroundColor(Color(hex: "#1C1C1C"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(name.trimmingCharacters(in: .whitespaces).isEmpty ? Color(hex: "#F4A340").opacity(0.35) : Color(hex: "#F4A340"))
                    .cornerRadius(14)
            }
            .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.horizontal, 26)
            .padding(.bottom, 40)
            .opacity(showButton ? 1 : 0)
            .offset(y: showButton ? 0 : 14)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) { showHeadline = true }
            withAnimation(.easeOut(duration: 0.5).delay(0.7)) { showSubtitle = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.1)) { showInput = true }
            withAnimation(.easeOut(duration: 0.5).delay(1.6)) { showCard = true }
            withAnimation(.easeOut(duration: 0.5).delay(2.1)) { showButton = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                inputFocused = true
            }
        }
    }
}

#Preview {
    OB2View(onNext: { name in print("Name: \(name)") })
}