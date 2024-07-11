//
//  File.swift
//  
//
//  Created by Владимир on 11.07.2024.
//

import Foundation

public protocol Cashable: Identifiable where ID == String {
    var json: Any? { get }
    var csv: String { get }
    static var csvHeader: String { get }
    static func parse(json: Any) -> Self?
    static func parse(csv: String) -> Self?
}
