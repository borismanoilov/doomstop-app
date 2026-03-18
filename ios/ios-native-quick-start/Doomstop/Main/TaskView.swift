//
//  TaskView.swift
//  Doomstop
//

import SwiftUI

// MARK: - Task Data
struct TaskItem {
    let title: String
    let desc: String
    let duration: String
}

let taskLibrary: [String: [String: [String: [TaskItem]]]] = [
    "Body": [
        "icon": [:],
        "quick": [
            "t1": [
                TaskItem(title: "15 pushups", desc: "Drop and do 15 pushups right now. Focus on form — chest to the floor, full extension. Rest 30s, then do 10 more.", duration: "3–4 min"),
                TaskItem(title: "Drink water + 10 squats", desc: "Fill a full glass of water and drink it completely. Then do 10 slow, deep squats — pause at the bottom.", duration: "3 min"),
                TaskItem(title: "Box breathing × 5", desc: "Inhale 4s → hold 4s → exhale 4s → hold 4s. Five complete rounds. Eyes closed, sitting upright.", duration: "3 min"),
                TaskItem(title: "Stretch your neck & shoulders", desc: "Roll your neck slowly in each direction. Pull each arm across your chest and hold 30 seconds each side.", duration: "4 min"),
            ],
            "t2": [
                TaskItem(title: "25 pushups + 15 squats", desc: "25 pushups, rest, then 15 deep squats. Full range of motion on every rep. No rushing.", duration: "5 min"),
                TaskItem(title: "5 min box breathing", desc: "4s in, hold, out, hold — 10 full rounds this time. If your mind wanders, start the count again.", duration: "5 min"),
                TaskItem(title: "Cold water face + 20 jumping jacks", desc: "Splash cold water on your face three times. Then do 20 jumping jacks at a controlled pace.", duration: "4 min"),
            ],
            "t3": [
                TaskItem(title: "50 pushups", desc: "50 pushups however many sets it takes. Count every rep, track how many sets. Note your time.", duration: "5–8 min"),
                TaskItem(title: "2 min cold shower", desc: "Get in the shower and turn it cold for 2 full minutes. No gradually easing in. Just do it.", duration: "5 min"),
                TaskItem(title: "Plank hold + breathing", desc: "Hold a plank for as long as you can. Rest 30s. Do it again. Focus on breathing steadily throughout.", duration: "5 min"),
            ]
        ],
        "deep": [
            "t1": [
                TaskItem(title: "Full body stretch routine", desc: "Work through every major muscle group: neck, shoulders, chest, back, hips, hamstrings, quads, calves. Hold each stretch for at least 30 seconds.", duration: "15 min"),
                TaskItem(title: "3 sets of 3 exercises", desc: "Pick any 3 exercises you know: pushups, squats, lunges, dips, situps. Do 3 sets of each with 30s rest between.", duration: "15–20 min"),
            ],
            "t2": [
                TaskItem(title: "20 min bodyweight circuit", desc: "Pushups, squats, lunges, plank, mountain climbers — 45s on, 15s off, repeat the circuit. No breaks longer than 30 seconds.", duration: "20 min"),
                TaskItem(title: "Follow a workout video", desc: "Open YouTube, search a 15–20 min beginner bodyweight workout. Press play and follow it start to finish. No skipping.", duration: "15–20 min"),
            ],
            "t3": [
                TaskItem(title: "100 pushups", desc: "100 pushups however many sets it takes. Keep track of your sets and rest times. This is your benchmark.", duration: "15–25 min"),
                TaskItem(title: "20 min HIIT", desc: "40 seconds on, 20 seconds off. 8 exercises: jumping jacks, pushups, squats, burpees, mountain climbers, lunges, plank, high knees. Two full rounds.", duration: "20 min"),
            ]
        ]
    ],
    "Mind": [
        "quick": [
            "t1": [
                TaskItem(title: "Write your one priority", desc: "Open a notebook or notes app. Write the single most important thing you need to get done today. Not a list — one thing.", duration: "3 min"),
                TaskItem(title: "Three specific gratitudes", desc: "Write three things you're genuinely grateful for right now. Be specific — not 'my family' but why, and what happened.", duration: "3 min"),
                TaskItem(title: "3 minutes of nothing", desc: "Set a timer. Sit still. No phone, no music, no fidgeting. Just exist for 3 minutes.", duration: "3 min"),
                TaskItem(title: "Read 3 pages", desc: "Pick up any book or open a long article. Read 3 full pages without stopping, skimming, or rereading.", duration: "4 min"),
            ],
            "t2": [
                TaskItem(title: "Brain dump", desc: "Open a blank page and write down every open thought, task, worry, or idea in your head. Keep writing until there's nothing left.", duration: "5 min"),
                TaskItem(title: "One honest thing", desc: "Write down one thing you've been avoiding thinking about. What is it actually? Why are you avoiding it?", duration: "4 min"),
                TaskItem(title: "5 min meditation", desc: "Sit comfortably, set a timer for 5 minutes. Focus on your breath. When your mind wanders, just return to the breath.", duration: "5 min"),
            ],
            "t3": [
                TaskItem(title: "Read the news", desc: "Open a real news source — not social, not headlines. Read two full articles on things happening in the world right now.", duration: "5 min"),
                TaskItem(title: "Write what you actually want", desc: "Open a blank page. Write honestly: what do you actually want your life to look like in one year?", duration: "5 min"),
            ]
        ],
        "deep": [
            "t1": [
                TaskItem(title: "Journal your day", desc: "Write about your day so far — what happened, how you're feeling, what's on your mind. No structure needed. Just write until something honest comes out.", duration: "10–15 min"),
                TaskItem(title: "Read a full chapter", desc: "Pick up any book. Read one complete chapter from start to finish without stopping.", duration: "15–20 min"),
            ],
            "t2": [
                TaskItem(title: "Plan your week", desc: "Write out what needs to happen in the next 7 days. What are you working toward? What's at risk of slipping?", duration: "15 min"),
                TaskItem(title: "Read today's news properly", desc: "Open a real newspaper or quality outlet. Read for 20 minutes — actual articles, not summaries.", duration: "20 min"),
            ],
            "t3": [
                TaskItem(title: "Deep journal entry", desc: "Write for 20 minutes. What do you want? What's actually blocking you? What have you been telling yourself that might not be true?", duration: "20 min"),
                TaskItem(title: "Watch something educational", desc: "A lecture, documentary, or long-form video on something you genuinely want to understand. No shorts. Watch it start to finish.", duration: "20 min"),
            ]
        ]
    ],
    "Space": [
        "quick": [
            "t1": [
                TaskItem(title: "Make your bed", desc: "Straighten your bed fully — sheets flat, pillows set, duvet even. It takes 2 minutes and changes the feel of the whole room.", duration: "2 min"),
                TaskItem(title: "Wash everything in the sink", desc: "Wash every dish, glass, and utensil currently in your sink. Dry them. Put them away. Leave the sink empty.", duration: "5 min"),
                TaskItem(title: "Clear your desk", desc: "Remove everything from your desk that doesn't belong there. Put each item where it actually lives. Wipe the surface.", duration: "4 min"),
                TaskItem(title: "Take out all the trash", desc: "Empty every bin in your space into a bag and take it out right now. Replace the liners.", duration: "3 min"),
            ],
            "t2": [
                TaskItem(title: "Tidy one full room", desc: "Pick the messiest room. Put everything back where it belongs — floor, surfaces, clothes. Leave it noticeably better.", duration: "5 min"),
                TaskItem(title: "Wipe down all surfaces", desc: "Kitchen counters, bathroom sink, desk, bedside table. Damp cloth, every surface.", duration: "5 min"),
            ],
            "t3": [
                TaskItem(title: "Reorganise one drawer or shelf", desc: "Pick the most chaotic drawer or shelf you own. Empty it completely, decide what stays, put it back organised.", duration: "5 min"),
            ]
        ],
        "deep": [
            "t1": [
                TaskItem(title: "Cook a proper meal", desc: "Cook something from scratch — real ingredients, actual preparation. Not instant, not reheated. A real meal that took effort.", duration: "20–30 min"),
                TaskItem(title: "Deep clean one room", desc: "Pick one room. Vacuum, mop or wipe the floor, clean surfaces, declutter. Leave it genuinely clean.", duration: "20–25 min"),
            ],
            "t2": [
                TaskItem(title: "Full laundry cycle", desc: "Gather all your dirty clothes, start the wash. While it runs, tidy the room they came from. When done, fold everything and put it away.", duration: "20 min"),
                TaskItem(title: "Bathroom deep clean", desc: "Toilet, sink, mirror, floor, shower. Everything. Use actual cleaning products. Leave it spotless.", duration: "20 min"),
            ],
            "t3": [
                TaskItem(title: "Declutter one category", desc: "Pick one category: clothes, books, papers, cables, products. Go through every item. Keep, donate, or bin. Be ruthless.", duration: "20–30 min"),
            ]
        ]
    ],
    "Social": [
        "quick": [
            "t1": [
                TaskItem(title: "Call someone", desc: "Call a parent, sibling, or friend. Just check in — no agenda, no reason needed. An actual call, not a voice note.", duration: "5 min"),
                TaskItem(title: "Send a real message", desc: "Write a genuine message to someone you haven't spoken to in a while. Something specific to them. Actual words.", duration: "3 min"),
            ],
            "t2": [
                TaskItem(title: "Tell someone you appreciate them", desc: "Pick one person. Send them a message or call them and tell them specifically what you appreciate about them. Mean it.", duration: "3–5 min"),
                TaskItem(title: "Check in on someone", desc: "Think of someone who might be going through something right now. Reach out and actually ask how they're doing.", duration: "4 min"),
            ],
            "t3": [
                TaskItem(title: "Apologise to someone", desc: "If there's someone you owe an apology to — even a small one — send it now. No explanation, no defence. Just a genuine sorry.", duration: "5 min"),
                TaskItem(title: "Plan something with a friend", desc: "Pick a friend. Suggest a specific thing to do together — not 'we should hang out sometime.' A real plan.", duration: "5 min"),
            ]
        ],
        "deep": [
            "t1": [
                TaskItem(title: "Have a real conversation", desc: "Call or sit with someone. Phone face down. Give them your complete, undivided attention for 20 minutes.", duration: "20 min"),
                TaskItem(title: "Write a long message", desc: "Write a proper message to someone who matters to you — the kind you've been meaning to send for weeks.", duration: "15–20 min"),
            ],
            "t2": [
                TaskItem(title: "Call a family member properly", desc: "Not a quick check-in. Call a parent, grandparent, or sibling and actually talk — about their life, not just yours. 20 minutes minimum.", duration: "20 min"),
            ],
            "t3": [
                TaskItem(title: "Write a letter", desc: "Handwrite or type a full letter to someone important to you. Tell them something you've been meaning to say. Send it.", duration: "20 min"),
            ]
        ]
    ],
    "Work": [
        "quick": [
            "t1": [
                TaskItem(title: "Do one real thing on your project", desc: "Open whatever you're working on. Do one concrete action that moves it forward — not organising, not reading back. Actual progress.", duration: "3–5 min"),
                TaskItem(title: "Write your 3 tasks for today", desc: "Write the three most important things you need to accomplish today. Be specific.", duration: "3 min"),
            ],
            "t2": [
                TaskItem(title: "Write down what's blocking you", desc: "Open a blank page. What is the one thing you keep avoiding? Write it down, then write the smallest possible first step.", duration: "4 min"),
                TaskItem(title: "Review what you did this week", desc: "Quickly write what you actually got done this week. Be honest. What moved? What didn't?", duration: "5 min"),
            ],
            "t3": [
                TaskItem(title: "Send the message you've been putting off", desc: "There's an email, a message, or a request you've been avoiding. Write it now and send it.", duration: "5 min"),
                TaskItem(title: "Fix one inefficiency", desc: "Identify one thing in your daily work that wastes time or causes friction. Fix it right now.", duration: "5 min"),
            ]
        ],
        "deep": [
            "t1": [
                TaskItem(title: "Work on your side project", desc: "Open your main project — business, app, essay, whatever you're building. Do 20 minutes of real work. Not admin, not planning. Making.", duration: "20 min"),
                TaskItem(title: "Plan the next 7 days", desc: "Write out what you want to accomplish in the next week. What are the priorities? What does a good week look like?", duration: "15 min"),
            ],
            "t2": [
                TaskItem(title: "Learn one thing you've been putting off", desc: "Pick one concept, tool, or skill you keep meaning to learn. Spend 20 minutes actually learning it.", duration: "20 min"),
                TaskItem(title: "Create something", desc: "Design, code, write, draw, build — make something that doesn't exist yet. 20 minutes of making.", duration: "20 min"),
            ],
            "t3": [
                TaskItem(title: "Write a full project plan", desc: "Pick your most important current project. Write a real plan: what's the goal, what are the steps, what are the obstacles, what's the timeline.", duration: "20–25 min"),
                TaskItem(title: "Deep work on the thing you keep avoiding", desc: "You know what it is. Open it. Set a timer for 30 minutes. Do nothing else.", duration: "30 min"),
            ]
        ]
    ]
]

let categoryIcons: [String: String] = [
    "Body": "💪",
    "Mind": "🧠",
    "Space": "🧹",
    "Social": "🤝",
    "Work": "💻"
]

// MARK: - TaskView
struct TaskView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var navigationRouter: NavigationRouter

    @State private var selectedType: String = "quick"
    @State private var selectedCategory: String? = nil
    @State private var currentTask: TaskItem? = nil
    @State private var lastCompletedTask: TaskItem? = nil
    @State private var lastCompletedCategory: String? = nil

    let categories = ["Body", "Mind", "Space", "Social", "Work"]

    var availableTasks: [TaskItem] {
        guard let cat = selectedCategory,
              let catData = taskLibrary[cat],
              let sideData = catData[selectedType] as? [String: [TaskItem]] else { return [] }
        let tiers = appState.currentTier == "t3" ? ["t1","t2","t3"] :
                    appState.currentTier == "t2" ? ["t1","t2"] : ["t1"]
        return tiers.flatMap { sideData[$0] ?? [] }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F5F2EA").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Color.clear.frame(height: 24)

                    // Type selector
                    HStack(spacing: 10) {
                        ForEach(["quick", "deep"], id: \.self) { type in
                            Button(action: {
                                selectedType = type
                                currentTask = nil
                            }) {
                                VStack(spacing: 2) {
                                    Text(type == "quick" ? "Quick Reset" : "Deep Focus")
                                        .font(.custom(Theme.Fonts.headlineSemiBold, size: 13))
                                        .foregroundColor(selectedType == type ? Color(hex: "#1C1C1C") : Color(hex: "#7a7060"))
                                    Text(type == "quick" ? "~5 min" : "~20 min")
                                        .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                        .foregroundColor(Color(hex: "#7a7060"))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 11)
                                .background(selectedType == type ? Color(hex: "#F4A340").opacity(0.13) : Color(hex: "#FDFAF4"))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedType == type ? Color(hex: "#F4A340") : Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 22)

                    // Category picker or task display
                    if currentTask == nil {
                        // Category picker
                        VStack(alignment: .leading, spacing: 0) {
                            Text("PICK A CATEGORY")
                                .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                .kerning(2)
                                .foregroundColor(Color(hex: "#7a7060"))
                                .padding(.bottom, 14)
                                .padding(.horizontal, 26)

                            VStack(spacing: 10) {
                                ForEach(categories, id: \.self) { cat in
                                    Button(action: {
                                        selectedCategory = cat
                                        pickRandomTask(cat: cat)
                                    }) {
                                        HStack(spacing: 14) {
                                            Text(categoryIcons[cat] ?? "")
                                                .font(.system(size: 24))
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(cat)
                                                    .font(.custom(Theme.Fonts.bodyMedium, size: 15))
                                                    .foregroundColor(Color(hex: "#1C1C1C"))
                                                let count = availableCount(cat: cat)
                                                Text("\(count) task\(count == 1 ? "" : "s") available")
                                                    .font(.custom(Theme.Fonts.bodyRegular, size: 12))
                                                    .foregroundColor(Color(hex: "#7a7060"))
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 13))
                                                .foregroundColor(Color(hex: "#7a7060"))
                                        }
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 14)
                                        .background(Color(hex: "#FDFAF4"))
                                        .cornerRadius(14)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                                        )
                                    }
                                    .padding(.horizontal, 26)
                                }
                            }
                        }
                    } else if let task = currentTask, let cat = selectedCategory {
                        // Task display
                        VStack(alignment: .leading, spacing: 0) {
                            // Back + category row
                            HStack {
                                Button(action: { currentTask = nil }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 13))
                                        Text("Back")
                                            .font(.custom(Theme.Fonts.bodyRegular, size: 14))
                                    }
                                    .foregroundColor(Color(hex: "#F4A340"))
                                }
                                Spacer()
                                HStack(spacing: 6) {
                                    Text(categoryIcons[cat] ?? "")
                                        .font(.system(size: 18))
                                    Text("\(cat) · \(task.duration)")
                                        .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                        .foregroundColor(Color(hex: "#7a7060"))
                                        .kerning(1)
                                        .textCase(.uppercase)
                                }
                            }
                            .padding(.horizontal, 26)
                            .padding(.bottom, 10)

                            // Task title
                            Text(task.title)
                                .font(.custom(Theme.Fonts.headlineBold, size: 34))
                                .foregroundColor(Color(hex: "#1C1C1C"))
                                .lineSpacing(3)
                                .padding(.horizontal, 26)
                                .padding(.bottom, 14)

                            // Task description card
                            Text(task.desc)
                                .font(.custom(Theme.Fonts.bodyRegular, size: 15))
                                .foregroundColor(Color(hex: "#7a7060"))
                                .lineSpacing(5)
                                .padding(18)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(hex: "#FDFAF4"))
                                .cornerRadius(18)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                                )
                                .padding(.horizontal, 26)
                                .padding(.bottom, 14)

                            // Unlock summary
                            HStack(spacing: 0) {
                                VStack(spacing: 4) {
                                    Text(selectedType == "quick" ? "\(appState.quickUsageMinutes) min" : "\(appState.deepUsageMinutes) min")
                                        .font(.custom(Theme.Fonts.headlineBold, size: 22))
                                        .foregroundColor(Color(hex: "#1C1C1C"))
                                    Text("usage earned")
                                        .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                        .foregroundColor(Color(hex: "#7a7060"))
                                }
                                .frame(maxWidth: .infinity)

                                Rectangle()
                                    .fill(Color(hex: "#1C1C1C").opacity(0.08))
                                    .frame(width: 1, height: 40)

                                VStack(spacing: 4) {
                                    Text(selectedType == "quick" ? "\(appState.quickWindowHours)h" : "\(appState.deepWindowHours)h")
                                        .font(.custom(Theme.Fonts.headlineBold, size: 22))
                                        .foregroundColor(Color(hex: "#1C1C1C"))
                                    Text("time window")
                                        .font(.custom(Theme.Fonts.bodyRegular, size: 11))
                                        .foregroundColor(Color(hex: "#7a7060"))
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(18)
                            .background(Color(hex: "#FDFAF4"))
                            .cornerRadius(18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1)
                            )
                            .padding(.horizontal, 26)
                            .padding(.bottom, 14)

                            // Reroll button
                            Button(action: { pickRandomTask(cat: cat) }) {
                                Text("Give me a different task ↻")
                                    .font(.custom(Theme.Fonts.bodyRegular, size: 14))
                                    .foregroundColor(Color(hex: "#7a7060"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(hex: "#1C1C1C").opacity(0.08), lineWidth: 1.5)
                                            .cornerRadius(12)
                                    )
                            }
                            .padding(.horizontal, 26)
                        }
                    }

                    Color.clear.frame(height: 100)
                }
            }

            // Done button
            if currentTask != nil {
                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [Color(hex: "#F5F2EA").opacity(0), Color(hex: "#F5F2EA")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 36)

                    Button(action: { completeTask() }) {
                        Text("I've done it ✓")
                            .font(.custom(Theme.Fonts.headlineSemiBold, size: 16))
                            .foregroundColor(Color(hex: "#1C1C1C"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(Color(hex: "#F4A340"))
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 40)
                    .background(Color(hex: "#F5F2EA"))
                }
            }
        }
    }

    func availableCount(cat: String) -> Int {
        guard let catData = taskLibrary[cat],
              let sideData = catData[selectedType] as? [String: [TaskItem]] else { return 0 }
        let tiers = appState.currentTier == "t3" ? ["t1","t2","t3"] :
                    appState.currentTier == "t2" ? ["t1","t2"] : ["t1"]
        return tiers.flatMap { sideData[$0] ?? [] }.count
    }

    func pickRandomTask(cat: String) {
        guard let catData = taskLibrary[cat],
              let sideData = catData[selectedType] as? [String: [TaskItem]] else { return }
        let tiers = appState.currentTier == "t3" ? ["t1","t2","t3"] :
                    appState.currentTier == "t2" ? ["t1","t2"] : ["t1"]
        let pool = tiers.flatMap { sideData[$0] ?? [] }
        guard !pool.isEmpty else { return }
        currentTask = pool.randomElement()
    }

    func completeTask() {
        guard let task = currentTask, let cat = selectedCategory else { return }
        let completed = CompletedTask(title: task.title, category: cat, type: selectedType)
        appState.completeTask(completed, type: selectedType)
        lastCompletedTask = task
        lastCompletedCategory = cat
        navigationRouter.showTaskSheet = false
        navigationRouter.completedTaskTitle = task.title
        navigationRouter.completedTaskType = selectedType
        navigationRouter.showCompletionSheet = true
    }
}

#Preview {
    TaskView()
        .environmentObject(AppState())
        .environmentObject(NavigationRouter())
}