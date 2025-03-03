//  BusinessError.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial implementation for clean architecture.

//
import Foundation

enum BusinessError: Error {
    case validationError(message: String)
    case networkError(message: String)
    case rateLimitExceeded(retryAfter: Int?) // Seconds to wait, optional
    case unauthorized
    case notFound(resource: String)
    case dataConflict(message: String)
    case uploadFailed(message: String, fileSize: Int?)
    case permissionDenied(service: String) // e.g., "appleMusic" or "spotify"
    
    var localizedDescription: String {
        switch self {
        case .validationError(let message):
            return "Validation Error: \(message)"
        case .networkError(let message):
            return "Network Error: \(message)"
        case .rateLimitExceeded(let retryAfter):
            return "Rate limit exceeded. Retry after \(retryAfter ?? 0) seconds."
        case .unauthorized:
            return "Unauthorized access. Please log in."
        case .notFound(let resource):
            return "Resource not found: \(resource)"
        case .dataConflict(let message):
            return "Data conflict: \(message)"
        case .uploadFailed(let message, let fileSize):
            return "Upload failed: \(message) (File size: \(fileSize ?? 0) bytes)"
        case .permissionDenied(let service):
            return "Permission denied for \(service) service."
        }
    }
}
