//
//  NotificationManager.swift
//  Doomstop
//

import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    // MARK: - Permission
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async { completion(granted) }
        }
    }

    func checkPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    // MARK: - Schedule daily intention reminder
    func scheduleDailyIntentionReminder(hour: Int, minute: Int, enabled: Bool) {
        let id = "daily_intention"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        guard enabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "What's your one thing today?"
        content.body = "Set your intention before the day gets away from you."
        content.sound = .default

        var components = DateComponents()
        components.hour = hour
        components.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Schedule midday check-in
    func scheduleMiddayCheckin(streak: Int, gateAttempts: Int, enabled: Bool) {
        let id = "midday_checkin"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        guard enabled else { return }

        let messages: [(String, String)] = [
            ("How's your focus holding up?", "You've got \(gateAttempts) gate attempts today. Keep going."),
            ("Midday check-in", "Your \(streak)-day streak is counting on you."),
            ("Still locked in?", "One task is all it takes to earn your time back."),
            ("Halfway through the day", "Make the second half count."),
        ]
        let pick = messages[Int.random(in: 0..<messages.count)]

        let content = UNMutableNotificationContent()
        content.title = pick.0
        content.body = pick.1
        content.sound = .default

        var components = DateComponents()
        components.hour = 13
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Schedule unlock expired
    func scheduleUnlockExpired(at date: Date, enabled: Bool) {
        let id = "unlock_expired"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        guard enabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "Apps are locked again."
        content.body = "Your free time is up. Do another task to earn more."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: max(1, date.timeIntervalSinceNow),
            repeats: false
        )
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Schedule streak at risk
    func scheduleStreakAtRisk(streak: Int, enabled: Bool) {
        let id = "streak_at_risk"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        guard enabled && streak > 0 else { return }

        let content = UNMutableNotificationContent()
        content.title = "Your streak is at risk."
        content.body = "You haven't done a task today. Your \(streak)-day streak ends at midnight."
        content.sound = .default

        var components = DateComponents()
        components.hour = 21
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Schedule weekly reflection
    func scheduleWeeklyReflection(enabled: Bool) {
        let id = "weekly_reflection"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        guard enabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "Your week is ready to review."
        content.body = "See how you did this week — honestly."
        content.sound = .default

        var components = DateComponents()
        components.weekday = 1 // Sunday
        components.hour = 19
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Streak milestone
    func sendStreakMilestone(streak: Int, enabled: Bool) {
        let id = "streak_milestone_\(streak)"
        guard enabled else { return }

        let messages: [Int: (String, String)] = [
            7:   ("7 days. You're building something.", "Most people quit before this. You didn't."),
            14:  ("Two weeks straight.", "That's not luck. That's discipline."),
            30:  ("30 days.", "That's not a habit anymore. That's who you are."),
            60:  ("60 days of showing up.", "You've changed something real."),
            100: ("100 days.", "One hundred. That's elite.")
        ]

        guard let message = messages[streak] else { return }

        let content = UNMutableNotificationContent()
        content.title = message.0
        content.body = message.1
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - Cancel all
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - Cancel specific
    func cancel(_ id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}