//
//  ToDoList.swift
//  SeSACRxThreads
//
//  Created by Jisoo Ham on 8/4/24.
//

import Foundation

struct ToDoList: Hashable, Identifiable {
    let id = UUID()
    let title: String
    var isFinished: Bool
    var highPriority: Bool
}

var mockList: [ToDoList] = [
    ToDoList(title: "운동하기", isFinished: false, highPriority: true),
    ToDoList(title: "수정하기", isFinished: false, highPriority: true),
    ToDoList(title: "이불정리하기", isFinished: true, highPriority: false),
]
