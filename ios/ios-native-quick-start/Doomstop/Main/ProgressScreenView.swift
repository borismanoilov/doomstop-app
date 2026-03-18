//
//  ProgressScreenView.swift
//  Doomstop
//

import SwiftUI

struct ProgressScreenView: View {
    @EnvironmentObject var appState: AppState

    @State private var viewYear = Calendar.current.component(.year, from: Date())
    @State private var viewMonth = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedDayKey: String? = nil

    let monthNames = ["January","February","March","April","May","June",
                      "July","August","September","October","November","December"]
    let dayLabels = ["S","M","T","W","T","F","S"]

    var isAtCurrentMonth: Bool {
        let now = Date()
        let y = Calendar.current.component(.year, from: now)
        let m = Calendar.current.component(.month, from: now) - 1
        return viewYear == y && viewMonth == m
    }

    var body: some View {
        ZStack {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Color.clear.frame(height: 8)

                    Text("Progress")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 26))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .padding(.horizontal, 24)

                    // Calendar card
                    VStack(spacing: 0) {
                        // Month nav
                        HStack {
                            Button(action: { prevMonth() }) {
                                Text("‹")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color(hex: "#7a7060"))
                                    .frame(width: 36, height: 36)
                            }
                            Spacer()
                            Text("\(monthNames[viewMonth]) \(String(viewYear))")
                                .font(.custom(Theme.Fonts.headlineSemiBold, size: 15))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                            Spacer()
                            Button(action: { nextMonth() }) {
                                Text("›")
                                    .font(.system(size: 22))
                                    .foregroundColor(isAtCurrentMonth ? Color(hex: "#1C1C1C").opacity(0.15) : Color(hex: "#7a7060"))
                                    .frame(width: 36, height: 36)
                            }
                            .disabled(isAtCurrentMonth)
                        }
                        .padding(.bottom, 12)

                        // Day headers
                        HStack(spacing: 0) {
                            ForEach(dayLabels, id: \.self) { d in
                                Text(d)
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                    .foregroundColor(Color(hex: "#7a7060"))
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.bottom, 4)

                        // Day grid
                        let (firstWeekday, daysInMonth) = monthData()
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                            ForEach(0..<firstWeekday, id: \.self) { _ in
                                Color.clear.frame(height: 36)
                            }
                            ForEach(1...daysInMonth, id: \.self) { day in
                                let key = dateKey(year: viewYear, month: viewMonth, day: day)
                                let isToday = key == todayKey()
                                let isPast = isPastOrToday(year: viewYear, month: viewMonth, day: day)
                                let hasTask = (appState.taskHistory[key]?.count ?? 0) > 0
                                let taskCount = appState.taskHistory[key]?.count ?? 0

                                Button(action: {
                                    if isPast { selectedDayKey = key }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(
                                                isToday ? Color(hex: "#1C1C1C") :
                                                hasTask && isPast ? Color(hex: "#F4A340") :
                                                Color.clear
                                            )
                                            .frame(height: 36)

                                        Text("\(day)")
                                            .font(.custom(hasTask || isToday ? Theme.Fonts.bodyMedium : Theme.Fonts.bodyRegular, size: 12))
                                            .foregroundColor(
                                                isToday ? .white :
                                                hasTask && isPast ? Color(hex: "#1C1C1C") :
                                                isPast ? Color(hex: "#7a7060") :
                                                Color(hex: "#1C1C1C").opacity(0.18)
                                            )

                                        if taskCount > 1 && isPast && !isToday {
                                            Circle()
                                                .fill(Color(hex: "#1C1C1C").opacity(0.4))
                                                .frame(width: 5, height: 5)
                                                .offset(x: 10, y: -10)
                                        }
                                    }
                                }
                                .disabled(!isPast)
                            }
                        }

                        Text("🟠 = task completed · ⬛ = today · tap any past day for details")
                            .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                            .foregroundColor(Color(hex: "#7a7060"))
                            .padding(.top, 12)
                    }
                    .padding(18)
                    .background(Color(hex: "#FDFAF4"))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                    // Stats row
                    HStack(spacing: 10) {
                        MiniStatCard(value: "\(appState.streak) 🔥", label: "Streak")
                        MiniStatCard(value: "\(appState.tasksTotal)", label: "Total tasks")
                        MiniStatCard(value: "\(appState.emergenciesTotal)", label: "Emergency", isRed: appState.emergenciesTotal > 0)
                    }
                    .padding(.horizontal, 24)

                    // Weekly bar chart
                    VStack(alignment: .leading, spacing: 14) {
                        Text("TASKS THIS WEEK")
                            .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                            .kerning(1.5)
                            .foregroundColor(Color(hex: "#7a7060"))

                        let bars = weekBars()
                        let maxVal = max(bars.map { $0.1 }.max() ?? 1, 1)

                        HStack(alignment: .bottom, spacing: 8) {
                            ForEach(bars, id: \.0) { bar in
                                VStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(bar.2 ? Color(hex: "#F4A340") : Color(hex: "#F4A340").opacity(0.28))
                                        .frame(height: bar.1 > 0 ? CGFloat(bar.1) / CGFloat(maxVal) * 72 : 4)
                                    Text(bar.0)
                                        .font(.custom(Theme.Fonts.bodyRegular, size: 10))
                                        .foregroundColor(bar.2 ? Color(hex: "#F4A340") : Color(hex: "#7a7060"))
                                        .fontWeight(bar.2 ? .semibold : .regular)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 90)
                    }
                    .padding(18)
                    .background(Color(hex: "#FDFAF4"))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                    // Event log
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ACTIVITY LOG")
                            .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                            .kerning(1.5)
                            .foregroundColor(Color(hex: "#7a7060"))
                            .padding(.horizontal, 24)

                        if appState.eventLog.isEmpty {
                            VStack(spacing: 10) {
                                Text("🔒")
                                    .font(.system(size: 32))
                                Text("No events yet. Your activity will appear here.")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                                    .foregroundColor(Color(hex: "#7a7060"))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                        } else {
                            ForEach(groupedEvents(), id: \.0) { group in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(group.0)
                                        .font(.custom(Theme.Fonts.bodyMedium, size: 12))
                                        .foregroundColor(Color(hex: "#7a7060"))
                                        .kerning(1.2)
                                        .textCase(.uppercase)
                                        .padding(.horizontal, 24)

                                    ForEach(group.1) { event in
                                        HStack {
                                            Text(event.type == .task ? "✅" : event.type == .emergency ? "🚨" : "🔒")
                                                .font(.system(size: 18))
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(event.type == .task ? (event.label ?? "Task") : event.type == .emergency ? "Emergency unlock" : "Gate shown")
                                                    .font(.custom(Theme.Fonts.bodyMedium, size: 14))
                                                    .foregroundColor(event.type == .emergency ? Color(hex: "#d94f4f") : Color(hex: "#1C1C1C"))
                                                if let cat = event.category {
                                                    Text(cat)
                                                        .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                                        .foregroundColor(Color(hex: "#7a7060"))
                                                }
                                            }
                                            Spacer()
                                            Text(formatTime(event.timestamp))
                                                .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                                .foregroundColor(Color(hex: "#7a7060"))
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color(hex: "#FDFAF4"))
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                                        )
                                        .padding(.horizontal, 24)
                                    }
                                }
                            }
                        }
                    }

                    Color.clear.frame(height: 24)
                }
            }

            // Day detail modal
            if let key = selectedDayKey {
                DayDetailModal(dateKey: key, onClose: { selectedDayKey = nil })
                    .environmentObject(appState)
            }
        }
    }

    // MARK: - Helpers
    func monthData() -> (Int, Int) {
        var components = DateComponents()
        components.year = viewYear
        components.month = viewMonth + 1
        components.day = 1
        let firstDay = Calendar.current.date(from: components)!
        let weekday = Calendar.current.component(.weekday, from: firstDay) - 1
        let days = Calendar.current.range(of: .day, in: .month, for: firstDay)!.count
        return (weekday, days)
    }

    func dateKey(year: Int, month: Int, day: Int) -> String {
        String(format: "%04d-%02d-%02d", year, month + 1, day)
    }

    func todayKey() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    func isPastOrToday(year: Int, month: Int, day: Int) -> Bool {
        let cal = Calendar.current
        var c = DateComponents()
        c.year = year; c.month = month + 1; c.day = day
        guard let d = cal.date(from: c) else { return false }
        let today = cal.startOfDay(for: Date())
        let target = cal.startOfDay(for: d)
        return target <= today
    }

    func prevMonth() {
        if viewMonth == 0 { viewMonth = 11; viewYear -= 1 }
        else { viewMonth -= 1 }
    }

    func nextMonth() {
        if isAtCurrentMonth { return }
        if viewMonth == 11 { viewMonth = 0; viewYear += 1 }
        else { viewMonth += 1 }
    }

    func weekBars() -> [(String, Int, Bool)] {
        let cal = Calendar.current
        let today = Date()
        let weekday = cal.component(.weekday, from: today)
        let mondayOffset = weekday == 1 ? -6 : 2 - weekday
        let labels = ["M","T","W","T","F","S","S"]
        var bars: [(String, Int, Bool)] = []
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        for i in 0..<7 {
            let d = cal.date(byAdding: .day, value: mondayOffset + i, to: today)!
            let key = f.string(from: d)
            let count = appState.taskHistory[key]?.count ?? 0
            let isToday = cal.isDateInToday(d)
            bars.append((labels[i], count, isToday))
        }
        return bars
    }

    func groupedEvents() -> [(String, [AppEvent])] {
        let cal = Calendar.current
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        var groups: [(String, [AppEvent])] = []
        var seen: [String: [AppEvent]] = [:]
        for event in appState.eventLog.prefix(30) {
            let key: String
            if cal.isDateInToday(event.timestamp) { key = "Today" }
            else if cal.isDateInYesterday(event.timestamp) { key = "Yesterday" }
            else {
                key = event.timestamp.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day())
            }
            if seen[key] == nil { seen[key] = [] }
            seen[key]?.append(event)
        }
        // preserve order
        var addedKeys: [String] = []
        for event in appState.eventLog.prefix(30) {
            let key: String
            if cal.isDateInToday(event.timestamp) { key = "Today" }
            else if cal.isDateInYesterday(event.timestamp) { key = "Yesterday" }
            else { key = event.timestamp.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day()) }
            if !addedKeys.contains(key) {
                addedKeys.append(key)
                groups.append((key, seen[key] ?? []))
            }
        }
        return groups
    }

    func formatTime(_ date: Date) -> String {
        date.formatted(.dateTime.hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits))
    }
}

// MARK: - Mini Stat Card
struct MiniStatCard: View {
    let value: String
    let label: String
    var isRed: Bool = false

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.custom(Theme.Fonts.headlineBold, size: 22))
                .foregroundColor(isRed ? Color(hex: "#d94f4f") : Color(hex: "#1C1C1C"))
            Text(label)
                .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                .foregroundColor(Color(hex: "#7a7060"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(hex: "#FDFAF4"))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - Day Detail Modal
struct DayDetailModal: View {
    @EnvironmentObject var appState: AppState
    let dateKey: String
    let onClose: () -> Void

    var tasks: [CompletedTask] {
        appState.taskHistory[dateKey] ?? []
    }

    var emergencies: Int {
        appState.eventLog.filter { event in
            event.type == .emergency &&
            DateFormatter.localizedString(from: event.timestamp, dateStyle: .short, timeStyle: .none) ==
            DateFormatter.localizedString(from: dateFromKey(), dateStyle: .short, timeStyle: .none)
        }.count
    }

    var dateLabel: String {
        let d = dateFromKey()
        return d.formatted(.dateTime.weekday(.wide).month(.wide).day())
    }

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1C").opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 0) {
                    // Handle
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(hex: "#1C1C1C").opacity(0.15))
                            .frame(width: 40, height: 4)
                        Spacer()
                    }
                    .padding(.bottom, 20)

                    Text(dateLabel)
                        .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                        .kerning(1.5)
                        .foregroundColor(Color(hex: "#7a7060"))
                        .textCase(.uppercase)
                        .padding(.bottom, 4)

                    let total = tasks.count + emergencies
                    Text(total == 0 ? "No activity" : total == 1 ? "1 event" : "\(total) events")
                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 24))
                        .foregroundColor(Color(hex: "#1C1C1C"))
                        .padding(.bottom, 18)

                    if tasks.isEmpty && emergencies == 0 {
                        Text("No tasks completed, no gate events on this day.")
                            .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                            .foregroundColor(Color(hex: "#7a7060"))
                            .italic()
                    }

                    VStack(spacing: 10) {
                        ForEach(tasks) { task in
                            HStack(spacing: 14) {
                                Text("✅")
                                    .font(.system(size: 20))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(task.title)
                                        .font(.custom(Theme.Fonts.bodyMedium, size: 14))
                                        .foregroundColor(Color(hex: "#1C1C1C"))
                                    Text("\(task.category) · \(task.type == "deep" ? "Deep Focus" : "Quick Reset")")
                                        .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                        .foregroundColor(Color(hex: "#7a7060"))
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "#FDFAF4"))
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                            )
                        }

                        ForEach(0..<emergencies, id: \.self) { _ in
                            HStack(spacing: 14) {
                                Text("🚨")
                                    .font(.system(size: 20))
                                Text("Emergency unlock used")
                                    .font(.custom(Theme.Fonts.bodyMedium, size: 14))
                                    .foregroundColor(Color(hex: "#d94f4f"))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "#d94f4f").opacity(0.1))
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(hex: "#d94f4f").opacity(0.32), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(24)
                .padding(.bottom, 16)
                .background(Color(hex: "#F5F2EA"))
                .cornerRadius(26)
            }
        }
    }

    func dateFromKey() -> Date {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.date(from: dateKey) ?? Date()
    }
}

#Preview {
    ProgressScreenView()
        .environmentObject(AppState())
}