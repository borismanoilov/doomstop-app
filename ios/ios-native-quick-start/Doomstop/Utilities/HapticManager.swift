//
//  HapticManager.swift
//  Doomstop
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    private init() {}

    // MARK: - Master toggle (read from UserDefaults directly for performance)
    var hapticsEnabled: Bool {
        get { UserDefaults.standard.object(forKey: "hapticsEnabled") as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: "hapticsEnabled") }
    }

    // MARK: - Impact
    func light() {
        guard hapticsEnabled else { return }
        let g = UIImpactFeedbackGenerator(style: .light)
        g.prepare()
        g.impactOccurred()
    }

    func medium() {
        guard hapticsEnabled else { return }
        let g = UIImpactFeedbackGenerator(style: .medium)
        g.prepare()
        g.impactOccurred()
    }

    func heavy() {
        guard hapticsEnabled else { return }
        let g = UIImpactFeedbackGenerator(style: .heavy)
        g.prepare()
        g.impactOccurred()
    }

    func soft() {
        guard hapticsEnabled else { return }
        let g = UIImpactFeedbackGenerator(style: .soft)
        g.prepare()
        g.impactOccurred()
    }

    func rigid() {
        guard hapticsEnabled else { return }
        let g = UIImpactFeedbackGenerator(style: .rigid)
        g.prepare()
        g.impactOccurred()
    }

    // MARK: - Notification
    func success() {
        guard hapticsEnabled else { return }
        let g = UINotificationFeedbackGenerator()
        g.prepare()
        g.notificationOccurred(.success)
    }

    func warning() {
        guard hapticsEnabled else { return }
        let g = UINotificationFeedbackGenerator()
        g.prepare()
        g.notificationOccurred(.warning)
    }

    func error() {
        guard hapticsEnabled else { return }
        let g = UINotificationFeedbackGenerator()
        g.prepare()
        g.notificationOccurred(.error)
    }

    // MARK: - Selection
    func selection() {
        guard hapticsEnabled else { return }
        let g = UISelectionFeedbackGenerator()
        g.prepare()
        g.selectionChanged()
    }

    // MARK: - Custom patterns
    func taskComplete() {
        guard hapticsEnabled else { return }
        success()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.medium()
        }
    }

    func streakMilestone() {
        guard hapticsEnabled else { return }
        heavy()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) { [weak self] in
            self?.heavy()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) { [weak self] in
            self?.heavy()
        }
    }

    func tierUnlock() {
        guard hapticsEnabled else { return }
        heavy()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.soft()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.success()
        }
    }

    func emergencyHoldTick() {
        guard hapticsEnabled else { return }
        rigid()
    }

    func counterTick() {
        guard hapticsEnabled else { return }
        soft()
    }

    func buttonTap() {
        guard hapticsEnabled else { return }
        medium()
    }

    func onboardingTextAppear() {
        guard hapticsEnabled else { return }
        light()
    }
}