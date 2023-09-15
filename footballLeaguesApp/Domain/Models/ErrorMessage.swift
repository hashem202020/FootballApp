//
//  ErrorMessage.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 29/04/2022.
//

import Foundation

public struct ErrorMessage: Error {
    
    // MARK: - Properties
    public let id: UUID
    public let title: String
    public var message: String
    
    public enum Errors: Error {
        case firstError
        case secondError
    }
    
    // MARK: - Methods
    public init(title: String, message: String) {
        self.id = UUID()
        self.title = title
        self.message = message
    }
    
    public init(error: Error) {
        self.id = UUID()
        self.title = ""
        self.message = error.localizedDescription
    }
}

extension ErrorMessage: LocalizedError {
    public var errorDescription: String? {
        return message
    }
}

extension ErrorMessage: Equatable {
    
    public static func == (lhs: ErrorMessage, rhs: ErrorMessage) -> Bool {
        return lhs.id == rhs.id
    }
}
