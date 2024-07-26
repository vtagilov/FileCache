//
//  File.swift
//
//
//  Created by Владимир on 25.07.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
public class TodoItemPersistenceModel {
    public enum Importance: String, Codable {
        case unimportant
        case common
        case important
    }
    
    public enum Category: String, Codable {
        case work
        case study
        case hobby
        case other
    }
    
    @Attribute(.unique) public let id: String
    @Attribute public let text: String
    @Attribute public let importance: Importance?
    @Attribute public let isDone: Bool
    @Attribute public let category: Category
    @Attribute public let creationDate: Date
    @Attribute public let deadline: Date?
    @Attribute public let editedDate: Date?
    
    public init(
        id: String,
        text: String,
        importance: Importance?,
        isDone: Bool,
        category: Category,
        creationDate: Date,
        deadline: Date?,
        editedDate: Date?
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.isDone = isDone
        self.creationDate = creationDate
        self.deadline = deadline
        self.editedDate = editedDate
        self.category = category
    }
}
