//
//  File.swift
//  
//
//  Created by Владимир on 11.07.2024.
//

import Foundation

public enum CacheError: LocalizedError {
    case invalidPath
    case failedToSave
    case failedToLoad
    case emptyFile
    
    public var errorDescription: String {
        switch self {
        case .invalidPath:
            return "Filed to open cache directory."
        case .failedToSave:
            return "Failed to save the item to the cache."
        case .failedToLoad:
            return "Failed to load the item from the cache."
        case .emptyFile:
            return "Cache file is empty."
        }
    }
}
