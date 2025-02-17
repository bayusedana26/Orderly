//
//  TaskViewModel.swift
//  Orderly
//
//  Created by Bayu Sedana on 14/02/25.
//


import SwiftUI

struct WeekDay: Identifiable {
    let id = UUID()
    let date: Date
}

class TaskViewModel: ObservableObject {
    // Sample data
    @Published var tasks: [Task] = [
        // Feb 16, 2025
        Task(taskTitle: "Make breakfast", taskDescription: "Bread, eggs, and milk", taskDate: Date(timeIntervalSince1970: 1739721600)), // 08:00 AM
        Task(taskTitle: "Morning jog", taskDescription: "Run for 30 minutes", taskDate: Date(timeIntervalSince1970: 1739725200)), // 09:00 AM
        Task(taskTitle: "Check emails", taskDescription: "Respond to important emails", taskDate: Date(timeIntervalSince1970: 1739732400)), // 11:00 AM
        Task(taskTitle: "Lunch with friend", taskDescription: "Meet at a café", taskDate: Date(timeIntervalSince1970: 1739743200)), // 02:00 PM
        Task(taskTitle: "Grocery shopping", taskDescription: "Buy fresh vegetables", taskDate: Date(timeIntervalSince1970: 1739750400)), // 04:00 PM
        Task(taskTitle: "Work on project", taskDescription: "Complete pending tasks", taskDate: Date(timeIntervalSince1970: 1739757600)), // 06:00 PM
        Task(taskTitle: "Dinner with family", taskDescription: "Enjoy a meal together", taskDate: Date(timeIntervalSince1970: 1739764800)), // 08:00 PM
        Task(taskTitle: "Read a book", taskDescription: "Read a novel before bed", taskDate: Date(timeIntervalSince1970: 1739772000)), // 10:00 PM

        // Feb 17, 2025
        Task(taskTitle: "Go to gym", taskDescription: "Workout for 1 hour", taskDate: Date(timeIntervalSince1970: 1739808000)), // 08:00 AM
        Task(taskTitle: "Call family", taskDescription: "Catch up with parents", taskDate: Date(timeIntervalSince1970: 1739811600)), // 09:00 AM
        Task(taskTitle: "Attend team meeting", taskDescription: "Project update discussion", taskDate: Date(timeIntervalSince1970: 1739822400)), // 12:00 PM
        Task(taskTitle: "Lunch break", taskDescription: "Try a new restaurant", taskDate: Date(timeIntervalSince1970: 1739833200)), // 03:00 PM
        Task(taskTitle: "Prepare presentation", taskDescription: "Finalize slides", taskDate: Date(timeIntervalSince1970: 1739840400)), // 05:00 PM
        Task(taskTitle: "Cook dinner", taskDescription: "Try a new recipe", taskDate: Date(timeIntervalSince1970: 1739847600)), // 07:00 PM
        Task(taskTitle: "Evening walk", taskDescription: "Walk around the park", taskDate: Date(timeIntervalSince1970: 1739854800)), // 09:00 PM
        Task(taskTitle: "Watch documentary", taskDescription: "Learn something new", taskDate: Date(timeIntervalSince1970: 1739862000)), // 11:00 PM

        // Feb 18, 2025
        Task(taskTitle: "Go to school", taskDescription: "Study for exams", taskDate: Date(timeIntervalSince1970: 1739894400)), // 08:00 AM
        Task(taskTitle: "Submit assignment", taskDescription: "Complete homework", taskDate: Date(timeIntervalSince1970: 1739898000)), // 09:00 AM
        Task(taskTitle: "Group study session", taskDescription: "Meet with classmates", taskDate: Date(timeIntervalSince1970: 1739908800)), // 12:00 PM
        Task(taskTitle: "Lunch at cafeteria", taskDescription: "Eat with friends", taskDate: Date(timeIntervalSince1970: 1739919600)), // 03:00 PM
        Task(taskTitle: "Write report", taskDescription: "Complete research paper", taskDate: Date(timeIntervalSince1970: 1739926800)), // 05:00 PM
        Task(taskTitle: "Attend online lecture", taskDescription: "Watch recorded class", taskDate: Date(timeIntervalSince1970: 1739934000)), // 07:00 PM
        Task(taskTitle: "Practice coding", taskDescription: "Solve Leetcode problems", taskDate: Date(timeIntervalSince1970: 1739941200)), // 09:00 PM
        Task(taskTitle: "Sleep early", taskDescription: "Get enough rest", taskDate: Date(timeIntervalSince1970: 1739948400)), // 11:00 PM

        // Feb 19, 2025
        Task(taskTitle: "Morning meditation", taskDescription: "Relax before starting the day", taskDate: Date(timeIntervalSince1970: 1739980800)), // 08:00 AM
        Task(taskTitle: "Go to work", taskDescription: "Complete daily tasks", taskDate: Date(timeIntervalSince1970: 1739984400)), // 09:00 AM
        Task(taskTitle: "Team meeting", taskDescription: "Discuss project progress", taskDate: Date(timeIntervalSince1970: 1739995200)), // 12:00 PM
        Task(taskTitle: "Lunch with colleagues", taskDescription: "Eat at a nearby place", taskDate: Date(timeIntervalSince1970: 1740006000)), // 03:00 PM
        Task(taskTitle: "Client presentation", taskDescription: "Showcase project updates", taskDate: Date(timeIntervalSince1970: 1740013200)), // 05:00 PM
        Task(taskTitle: "Go to shop", taskDescription: "Buy some essentials", taskDate: Date(timeIntervalSince1970: 1740020400)), // 07:00 PM
        Task(taskTitle: "Evening workout", taskDescription: "Exercise at home", taskDate: Date(timeIntervalSince1970: 1740027600)), // 09:00 PM
        Task(taskTitle: "Relax with music", taskDescription: "Listen to a playlist", taskDate: Date(timeIntervalSince1970: 1740034800)), // 11:00 PM
    ]

    // MARK: - Current week days
    @Published var currentWeek: [WeekDay] = []
    
    // MARK: - Current day
    @Published var currentDay: Date = Date() {
        didSet {
            fetchCurrentWeek()
            filterTodayTasks()
        }
    }
    
    // MARK: - Filtering today task
    @Published var filteredTasks: [Task]?
    
    // MARK: - Init
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    // MARK: - Filter today task
    func filterTodayTasks() {
        let calendar = Calendar.current
        let filtered = tasks.filter {
            calendar.isDate($0.taskDate, inSameDayAs: currentDay)
        }
        withAnimation {
            filteredTasks = filtered
        }
    }
    
    // MARK: - Fetch Current Week
    func fetchCurrentWeek() {
        let today = currentDay
        let calendar = Calendar.current
        
        if let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: today) {
            let firstWeekDay = weekInterval.start
            currentWeek = (0..<7).map { WeekDay(date: calendar.date(byAdding: .day, value: $0, to: firstWeekDay)!) }
        }
    }
    
    // MARK: - Extracting date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // MARK: - Check current date = today
    func isToday(date: Date) -> Bool {
        Calendar.current.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: - Check if the current hour is task hour
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date()) // Compare with current time
        return hour == currentHour
    }
}
