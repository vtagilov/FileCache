//
//  FileCache.swift
//  ToDoApp
//
//  Created by Владимир on 21.06.2024.
//

import Foundation

public final class FileCache<T: Cashable> {
    public enum FileType {
        case json
        case csv
    }
    
    public private(set) var items: [T] = []

    private let errorHandler: (_ error: CacheError) -> Void
    
    public init(errorHandler: @escaping (CacheError) -> Void) {
        self.errorHandler = errorHandler
    }
    
    private var cacheDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    public func addItem(_ item: T) {
        if !items.contains(where: { $0.id == item.id }) {
            items.append(item)
        }
    }
    
    @discardableResult
    public func removeItem(_ itemId: String) -> T? {
        let index = items.firstIndex(where: { $0.id == itemId })
        if let index = index {
            return items.remove(at: index)
        }
        return nil
    }
    
    public func updateItem(_ newItem: T) {
        if let index = items.firstIndex(where: { $0.id == newItem.id }) {
            items[index] = newItem
        }
    }
    
    public func saveItemsToFile(_ fileName: String, fileType: FileType = .json) {
        switch fileType {
        case .json:
            saveItemsToJSONFile(fileName)
        case .csv:
            saveItemsToCSVFile(fileName)
        }
    }
    
    public func loadItemsFromFile(_ fileName: String, fileType: FileType = .json) {
        items = []
        switch fileType {
        case .json:
            loadItemsFromJSONFile(fileName)
        case .csv:
            loadItemsFromCSVFile(fileName)
        }
    }
}

extension FileCache {
    private func saveItemsToJSONFile(_ fileName: String) {
        let jsonObjects: [Any] = items.compactMap({ $0.json })
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObjects)
            guard let directoryPath = cacheDirectory else {
                errorHandler(.invalidPath)
                return
            }
            let fileURL = directoryPath.appending(component: "\(fileName).json")
            try data.write(to: fileURL)
        } catch {
            errorHandler(.failedToSave)
            return
        }
    }
    
    private func loadItemsFromJSONFile(_ fileName: String) {
        guard let directoryPath = cacheDirectory else {
            errorHandler(.invalidPath)
            return
        }
        let fileURL = directoryPath.appending(component: "\(fileName).json")
        do {
            let data = try Data(contentsOf: fileURL)
            guard let json = try JSONSerialization.jsonObject(with: data) as? [Any] else {
                errorHandler(.emptyFile)
                return
            }
            for jsonObject in json {
                if let item = T.parse(json: jsonObject) {
                    addItem(item)
                }
            }
        } catch {
            errorHandler(.emptyFile)
            return
        }
    }
}

extension FileCache {
    private func saveItemsToCSVFile(_ fileName: String) {
        let csvObjects = items.map { $0.csv }.joined(separator: "\n")
        let csvString = T.csvHeader + csvObjects
        guard let directoryPath = cacheDirectory else {
            errorHandler(.invalidPath)
            return
        }
        let fileURL = directoryPath.appendingPathComponent("\(fileName).csv")

        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            errorHandler(.failedToSave)
            return
        }
    }
    
    private func loadItemsFromCSVFile(_ fileName: String) {
        guard let directoryPath = cacheDirectory else {
            errorHandler(.invalidPath)
            return
        }
        let fileURL = directoryPath.appendingPathComponent("\(fileName).csv")
        do {
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = csvString.split(separator: "\n").map { String($0) }
            for i in 1 ..< lines.count {
                if let item = T.parse(csv: lines[i]) {
                    addItem(item)
                }
            }
        } catch {
            errorHandler(.failedToLoad)
            return
        }
    }
}
