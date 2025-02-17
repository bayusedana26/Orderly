//
//  HomeView.swift
//  Orderly
//
//  Created by Bayu Sedana on 14/02/25.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Attributes
    @StateObject var taskModel = TaskViewModel()
    @Namespace var animation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: - Lazy stack with pinned header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    
                    // MARK: - Current week view
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            
                            ForEach(taskModel.currentWeek) { weekDay in
                                let day = weekDay.date
                                
                                VStack(spacing: 10) {
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 15, height: 30)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                // MARK: - Foreground style
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundStyle(taskModel.isToday(date: day) ? .white : .black)
                                // MARK: - Capsule shape
                                .frame(width: 75, height: 120)
                                .background(
                                    
                                    ZStack {
                                        // MARK: - Match effect
                                        if taskModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Update current day
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    TaskView()
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    
    // MARK: - Task view
    func TaskView() -> some View {
        LazyVStack(spacing: 18) {
            if let tasks = taskModel.filteredTasks {
                if tasks.isEmpty {
                    Text("No task today")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                } else {
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
            }
        }
        .padding()
        .padding(.top)
        .onChange(of: taskModel.currentDay) { oldValue, newValue in
            taskModel.filterTodayTasks()
        }
    }
    
    // MARK: - TaskCardView
    func TaskCardView(task: Task) -> some View {
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Circle()
                    .fill(taskModel.isCurrentHour(date: task.taskDate) ? .black : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!taskModel.isCurrentHour(date: task.taskDate) ? 0.8 : 1)
                
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        
                        Text(task.taskDescription)
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                    .hLeading()
                    
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
                
                if taskModel.isCurrentHour(date: task.taskDate) {
                    HStack(spacing: 0) {
                        HStack(spacing: -8) {
                            ForEach(["profile1", "profile2", "profile3"], id: \.self) { profile in
                                Image(profile)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .background(
                                        Circle()
                                            .stroke(.white, lineWidth: 5)
                                    )
                            }
                        }
                        .hLeading()
                        
                        Button {
                            // Handle checkmark action
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.top)
                }
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(date: task.taskDate) ? 0 : 10)
            .hLeading()
            .background(.black.opacity(taskModel.isCurrentHour(date: task.taskDate) ? 1 : 0))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .hLeading()
    }
    
    // MARK: - Header view
    func HeaderView() -> some View {
        HStack(spacing: 15) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Week")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let firstDay = taskModel.currentWeek.first?.date,
                   let lastDay = taskModel.currentWeek.last?.date {
                    Text("Week of \(taskModel.extractDate(date: firstDay, format: "dd MMM yyyy")) - \(taskModel.extractDate(date: lastDay, format: "dd MMM yyyy"))")
                        .font(.headline)
                        .foregroundStyle(.gray)
                } else {
                    Text("Week not available")
                        .font(.headline)
                        .foregroundStyle(.red)
                }
                
                Text("Today")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.gray)
            }
            .hLeading()
            
            // MARK: - Button
            Button {
                
            } label: {
                Image("profile1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
            }
            
        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(.white)
    }
}


#Preview {
    HomeView()
}


// MARK: - View helper
extension View {
    
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: - Safe Area
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        return safeArea
    }
}
