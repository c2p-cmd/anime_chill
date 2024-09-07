//
//  AppError.swift
//  AnimeChill
//
//  Created by Sharan Thakur on 07/09/24.
//

import Foundation

struct AppError: LocalizedError, CustomStringConvertible, Decodable {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    var errorDescription: String? { message }
    var description: String { message }
}
