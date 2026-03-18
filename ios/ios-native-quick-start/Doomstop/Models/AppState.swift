//
//  AppState.swift
//  Doomstop
//

import SwiftUI
import Combine
import UserNotifications

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
    @Published var taskHistory: [String: [CompletedTask]] = [:]

    // MARK: - Task completion counts (for repeat tracking)
    @Published var taskCompletionCounts: [String: Int] = [:]

    // MARK: - Event log
    @Published var eventLog: [AppEvent] = []

    // MARK: - Unlock settings
    @Published var quickUsageMinutes: Int = 20
    @Published var quickWindowHours: Int = 2
    @Published var deepUsageMinutes: Int = 60
    @Published var deepWindowHours: Int = 24

    // MARK: - Hard mode
    @Published var hardModeEnabled: Bool = false

    // MARK: - Haptics
    @Published var hapticsEnabled: Bool = true {
        didSet { HapticManager.shared.hapticsEnabled = hapticsEnabled }
    }

    // MARK: - Notifications
    @Published var notificationsEnabled: Bool = false
    @Published var intentionReminderEnabled: Bool = true
    @Published var intentionReminderHour: Int = 8
    @Published var intentionReminderMinute: Int = 0
    @Published var middayCheckinEnabled: Bool = true
    @Published var streakAtRiskEnabled: Bool = true
    @Published var unlockExpiredEnabled: Bool = true
    @Published var weeklyReflectionEnabled: Bool = true
    @Published var milestoneNotificationsEnabled: Bool = true

    // MARK: - Streak freeze
    @Published var freezesAvailable: Int = 1
    @Published var lastFreezeGrantedWeek: Int = -1
    @Published var freezeUsedThisWeek: Bool = false

    // MARK: - Milestones
    @Published var seenMilestones: Set<Int> = []
    @Published var pendingMilestone: Int? = nil

    // MARK: - Tier unlock seen
    @Published var hasSeenT2Unlock: Bool = false
    @Published var hasSeenT3Unlock: Bool = false
    @Published var pendingTierUnlock: String? = nil

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

    // MARK: - Task repeat count
    func completionCount(for title: String) -> Int {
        taskCompletionCounts[title] ?? 0
    }

    // MARK: - Actions
    func completeTask(_ task: CompletedTask, type: String) {
        let key = todayDateKey()

        // Update history
        if taskHistory[key] == nil { taskHistory[key] = [] }
        taskHistory[key]?.append(task)

        // Update repeat count
        taskCompletionCounts[task.title, default: 0] += 1

        // Update counts
        tasksCompletedToday += 1
        tasksTotal += 1

        // Update streak
        updateStreak()

        // Set unlock
        let usage = type == "deep" ? deepUsageMinutes : quickUsageMinutes
        let window = type == "deep" ? deepWindowHours : quickWindowHours
        isUnlocked = true
        let expiryDate = Date().addingTimeInterval(TimeInterval(window * 3600))
        unlockExpiresAt = expiryDate
        minutesRemaining = usage

        // Schedule unlock expired notification
        if notificationsEnabled && unlockExpiredEnabled {
            NotificationManager.shared.scheduleUnlockExpired(at: expiryDate, enabled: true)
        }

        // Log event
        eventLog.insert(AppEvent(type: .task, label: task.title, category: task.category, timestamp: Date()), at: 0)

        // Haptics
        HapticManager.shared.taskComplete()
    }

    func triggerEmergency() {
        emergenciesToday += 1
        emergenciesTotal += 1
        gateAttemptsToday += 1
        if hardModeEnabled { streak = 0 }
        isUnlocked = true
        let expiryDate = Date().addingTimeInterval(3600)
        unlockExpiresAt = expiryDate
        minutesRemaining = 5

        if notificationsEnabled && unlockExpiredEnabled {
            NotificationManager.shared.scheduleUnlockExpired(at: expiryDate, enabled: true)
        }

        eventLog.insert(AppEvent(type: .emergency, label: nil, category: nil, timestamp: Date()), at: 0)
        HapticManager.shared.warning()
    }

    func triggerGate() {
        gateAttemptsToday += 1
        eventLog.insert(AppEvent(type: .gate, label: nil, category: nil, timestamp: Date()), at: 0)
    }

    func setIntention(_ text: String?) {
        todayIntention = text
        intentionDate = Date()
        HapticManager.shared.medium()
    }

    // MARK: - Streak freeze
    func grantWeeklyFreezeIfNeeded() {
        let currentWeek = Calendar.current.component(.weekOfYear, from: Date())
        if lastFreezeGrantedWeek != currentWeek {
            freezesAvailable = min(freezesAvailable + 1, 1)
            lastFreezeGrantedWeek = currentWeek
            freezeUsedThisWeek = false
        }
    }

    func applyStreakFreeze() {
        guard freezesAvailable > 0 && !freezeUsedThisWeek else { return }
        freezesAvailable -= 1
        freezeUsedThisWeek = true
        lastTaskDate = Date()
        NotificationManager.shared.sendStreakMilestone(streak: streak, enabled: false)
    }

    // MARK: - Update streak
    func updateStreak() {
        let calendar = Calendar.current
        let previousTier = currentTier

        if let last = lastTaskDate {
            let isToday = calendar.isDateInToday(last)
            let isYesterday = calendar.isDateInYesterday(last)
            if isToday {
                // already counted today, no change
            } else if isYesterday {
                streak += 1
                lastTaskDate = Date()
            } else {
                streak = 1
                lastTaskDate = Date()
            }
        } else {
            streak = 1
            lastTaskDate = Date()
        }

        // Check milestone
        let milestones = [7, 14, 30, 60, 100]
        for m in milestones {
            if streak == m && !seenMilestones.contains(m) {
                seenMilestones.insert(m)
                pendingMilestone = m
                HapticManager.shared.streakMilestone()
                if notificationsEnabled && milestoneNotificationsEnabled {
                    NotificationManager.shared.sendStreakMilestone(streak: m, enabled: true)
                }
            }
        }

        // Check tier unlock
        let newTier = currentTier
        if newTier == "t2" && previousTier == "t1" && !hasSeenT2Unlock {
            pendingTierUnlock = "t2"
            HapticManager.shared.tierUnlock()
        } else if newTier == "t3" && previousTier == "t2" && !hasSeenT3Unlock {
            pendingTierUnlock = "t3"
            HapticManager.shared.tierUnlock()
        }

        // Reschedule streak at risk notification
        if notificationsEnabled && streakAtRiskEnabled {
            NotificationManager.shared.scheduleStreakAtRisk(streak: streak, enabled: true)
        }
    }

    // MARK: - Check if streak should break overnight
    func checkStreakIntegrity() {
        guard let last = lastTaskDate else { return }
        let calendar = Calendar.current
        let isToday = calendar.isDateInToday(last)
        let isYesterday = calendar.isDateInYesterday(last)

        if !isToday && !isYesterday {
            // More than one day has passed
            grantWeeklyFreezeIfNeeded()
            if freezesAvailable > 0 && !freezeUsedThisWeek {
                applyStreakFreeze()
                // Notify user freeze was used
                let content = UNMutableNotificationContent()
                // Handled by NotificationManager
            } else {
                streak = 0
                lastTaskDate = nil
            }
        }
        grantWeeklyFreezeIfNeeded()
    }

    // MARK: - Schedule all notifications
    func scheduleAllNotifications() {
        guard notificationsEnabled else {
            NotificationManager.shared.cancelAll()
            return
        }
        NotificationManager.shared.scheduleDailyIntentionReminder(
            hour: intentionReminderHour,
            minute: intentionReminderMinute,
            enabled: intentionReminderEnabled
        )
        NotificationManager.shared.scheduleMiddayCheckin(
            streak: streak,
            gateAttempts: gateAttemptsToday,
            enabled: middayCheckinEnabled
        )
        NotificationManager.shared.scheduleStreakAtRisk(
            streak: streak,
            enabled: streakAtRiskEnabled
        )
        NotificationManager.shared.scheduleWeeklyReflection(
            enabled: weeklyReflectionEnabled
        )
    }

    // MARK: - Helpers
    func todayDateKey() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }
}

// MARK: - Models
struct CompletedTask: Identifiable, Codable {
    let id: UUID
    let title: String
    let category: String
    let type: String
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