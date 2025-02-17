//
//  Task.swift
//  Orderly
//
//  Created by Bayu Sedana on 14/02/25.
//

import SwiftUI

struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}


