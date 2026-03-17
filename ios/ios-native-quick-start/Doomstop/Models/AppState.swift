//
//  AppState.swift
//  Doomstop
//

import SwiftUI
import Combine

class AppState: ObservableObject {

    // MARK: - User
    @Published var userName: String = ""
    @Published var currentScreenTime: Double = 4
    @Published var desiredScreenTime: Double = 1
    @Published var blockedApps: [String] = []

    // MARK: - Streak
    @Published var streak: Int = 0
    @Published var lastTaskDate: Date? = nil

    // MARK: - Today
    @Published var tasksCompletedToday: Int = 0
    @Published var gateAttemptsToday: Int = 0
    @Published var emergenciesToday: Int = 0

    // MARK: - Totals
    @Published var tasksTotal: Int = 0
    @Published var emergenciesTotal: Int = 0

    // MARK: - Lock state
    @Published var isUnlocked: Bool = false
    @Published var unlockExpiresAt: Date? = nil
    @Published var minutesRemaining: Int = 0

    // MARK: - Intention
    @Published var todayIntention: String? = nil
    @Published var intentionDate: Date? = nil

    // MARK: - Task history
    // Key: "YYYY-MM-DD", Value: array of completed tasks
    @Published var taskHistory: [String: [CompletedTask]] = [:]

    // MARK: - Event log
    @Published var eventLog: [AppEvent] = []

    // MARK: - Unlock settings
    @Published var quickUsageMinutes: Int = 20
    @Published var quickWindowHours: Int = 2
    @Published var deepUsageMinutes: Int = 60
    @Published var deepWindowHours: Int = 24

    // MARK: - Hard mode
    @Published var hardModeEnabled: Bool = false

    // MARK: - Tier
    var currentTier: String {
        if streak >= 30 { return "t3" }
        if streak >= 7  { return "t2" }
        return "t1"
    }

    var tierLabel: String {
        switch currentTier {
        case "t3": return "Committed"
        case "t2": return "Consistent"
        default:   return "Starter"
        }
    }

    var nextTierStreak: Int? {
        if streak < 7  { return 7 }
        if streak < 30 { return 30 }
        return nil
    }

    // MARK: - Lock helpers
    var lockStatusLabel: String {
        guard isUnlocked, let expires = unlockExpiresAt else { return "Locked" }
        let mins = Int(expires.timeIntervalSinceNow / 60)
        if mins <= 0 { return "Locked" }
        return "\(mins)m left"
    }

    // MARK: - Actions
    func completeTask(_ task: CompletedTask, type: String) {
        let key = todayDateKey()

        // Update history
        if taskHistory[key] == nil { taskHistory[key] = [] }
        taskHistory[key]?.append(task)

        // Update counts
        tasksCompletedToday += 1
        tasksTotal += 1

        // Update streak
        updateStreak()

        // Set unlock
        let usage = type == "deep" ? deepUsageMinutes : quickUsageMinutes
        let window = type == "deep" ? deepWindowHours : quickWindowHours
        isUnlocked = true
        unlockExpiresAt = Date().addingTimeInterval(TimeInterval(window * 3600))
        minutesRemaining = usage

        // Log event
        eventLog.insert(AppEvent(type: .task, label: task.title, category: task.category, timestamp: Date()), at: 0)
    }

    func triggerEmergency() {
        emergenciesToday += 1
        emergenciesTotal += 1
        gateAttemptsToday += 1
        if hardModeEnabled { streak = 0 }
        isUnlocked = true
        unlockExpiresAt = Date().addingTimeInterval(3600)
        minutesRemaining = 5
        eventLog.insert(AppEvent(type: .emergency, label: nil, category: nil, timestamp: Date()), at: 0)
    }

    func triggerGate() {
        gateAttemptsToday += 1
        eventLog.insert(AppEvent(type: .gate, label: nil, category: nil, timestamp: Date()), at: 0)
    }

    func setIntention(_ text: String?) {
        todayIntention = text
        intentionDate = Date()
    }

    // MARK: - Helpers
    func todayDateKey() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    func updateStreak() {
        let key = todayDateKey()
        let calendar = Calendar.current
        if let last = lastTaskDate {
            let isToday = calendar.isDateInToday(last)
            let isYesterday = calendar.isDateInYesterday(last)
            if isToday {
                // already counted today
            } else if isYesterday {
                streak += 1
                lastTaskDate = Date()
            } else {
                // streak broken
                streak = 1
                lastTaskDate = Date()
            }
        } else {
            streak = 1
            lastTaskDate = Date()
        }
        _ = key
    }
}

// MARK: - Models
struct CompletedTask: Identifiable, Codable {
    let id: UUID
    let title: String
    let category: String
    let type: String // "quick" or "deep"
    let timestamp: Date

    init(title: String, category: String, type: String) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.type = type
        self.timestamp = Date()
    }
}

struct AppEvent: Identifiable {
    let id = UUID()
    let type: EventType
    let label: String?
    let category: String?
    let timestamp: Date

    enum EventType {
        case task, emergency, gate
    }
}