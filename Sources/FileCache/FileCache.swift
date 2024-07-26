//
//  FileCache.swift
//  ToDoApp
//
//  Created by Владимир on 21.06.2024.
//

import Foundation
import SwiftData

public final class FileCache {
    public typealias FetchResult = (items: [TodoItemPersistenceModel]?, error: CacheError?)
    
    private let container: ModelContainer?
    
    public init() {
        container = try? ModelContainer(
            for: TodoItemPersistenceModel.self,
            configurations: ModelConfiguration(for: TodoItemPersistenceModel.self)
        )
    }
    
    public func insert(_ todoItem: TodoItemPersistenceModel) {
        Task {
            await self.container?.mainContext.insert(todoItem)
        }
    }
    
    public func fetch(completion: @escaping (FetchResult) -> Void) {
        let descriptor = FetchDescriptor<TodoItemPersistenceModel>()
        Task {
            do {
                let result = try await container?.mainContext.fetch(descriptor)
                DispatchQueue.main.async {
                    completion((result, nil))
                }
            } catch {
                DispatchQueue.main.async {
                    completion((nil, .failedToLoad))
                }
            }
        }
    }
    
    public func fetchByEditedDate(completion: @escaping (FetchResult) -> Void) {
        let descriptor = FetchDescriptor<TodoItemPersistenceModel>(
            sortBy: [
                .init(\.editedDate)
            ]
        )
        Task {
            do {
                let result = try await container?.mainContext.fetch(descriptor)
                DispatchQueue.main.async {
                    completion((result, nil))
                }
            } catch {
                DispatchQueue.main.async {
                    completion((nil, .failedToLoad))
                }
            }
        }
    }
    
    public func fetchCompleted(completion: @escaping (FetchResult) -> Void) {
        let descriptor = FetchDescriptor<TodoItemPersistenceModel>(
            predicate: #Predicate { $0.isDone },
            sortBy: [
                .init(\.editedDate)
            ]
        )
        Task {
            do {
                let result = try await container?.mainContext.fetch(descriptor)
                DispatchQueue.main.async {
                    completion((result, nil))
                }
            } catch {
                DispatchQueue.main.async {
                    completion((nil, .failedToLoad))
                }
            }
        }
    }
    
    public func delete(_ todoItem: TodoItemPersistenceModel) {
        Task {
            await self.container?.mainContext.delete(todoItem)
        }
    }
    
    public func update(_ todoItem: TodoItemPersistenceModel) {
        Task {
            await self.container?.mainContext.insert(todoItem)
        }
    }
    
    public func setItems(_ items: [TodoItemPersistenceModel]) {
        self.fetch { result in
            if let error = result.error {
                return
            }
            guard let oldItems = result.items else {
                return
            }
            oldItems.forEach({
                self.delete($0)
            })
            items.forEach({ self.insert($0) })
        }
    }
}
