//  AuthRepositoryProtocol.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial implementation for clean architecture.
//
import Foundation

/// Protocol defining the authentication-related operations for the Flicks app.
protocol AuthRepositoryProtocol {
    /// Authenticates a user with the provided credentials.
    /// - Parameters:
    ///   - credentials: User credentials (e.g., email, password).
    ///   - completion: Closure with Result containing the authenticated user or an error.
    func authenticate(credentials: AuthCredentials, completion: @escaping (Result<UserModel, BusinessError>) -> Void)
    
    /// Logs out the current user.
    /// - Parameter completion: Closure with Result indicating success or failure.
    func logout(completion: @escaping (Result<Void, BusinessError>) -> Void)
    
    /// Checks if a user is currently authenticated.
    /// - Returns: Boolean indicating authentication status.
    func isAuthenticated() -> Bool
}

/// Data structure for authentication credentials.
struct AuthCredentials {
    let email: String
    let password: String
}
