//
//  PostError.swift
//  Reddit
//
//  Created by Andrew Acton on 2/14/23.
//

import Foundation

enum PostError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
            
        case .invalidURL:
            return "The server failed to reach the necessary URL."
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -- \(error)"
        case .noData:
            return "The server responded with no data"
        case .unableToDecode:
            return "Unable to decode the data"
        }
    }
    
} //End of enum
