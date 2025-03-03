//  UserRepositoryProtocol.swift
//  flicks_app
//
//  Created by Av.
//  Version 1.0 - Initial implementation for clean architecture.
//  This file defines the UserRepositoryProtocol within the Domain layer, outlining user profile and friend suggestion operations for the Flicks! app.
//  It is designed as a protocol to ensure loose coupling and support for cloud sync and sharding.
//  Future versions may add methods for user preferences or blocking functionality, requiring additional protocol methods.
//
import Foundation

/// Protocol defining user-related operations for the Flicks app.
protocol UserRepositoryProtocol {
    /// Fetches the current user's profile.
    /// - Parameter completion: Closure with Result containing the user model or an error.
    func fetchUserProfile(completion: @escaping (Result<UserModel, BusinessError>) -> Void)
    
    /// Updates the user's profile with new data.
    /// - Parameters:
    ///   - profile: Updated user profile data.
    ///   - completion: Closure with Result indicating success or failure.
    func updateUserProfile(profile: UserModel, completion: @escaping (Result<Void, BusinessError>) -> Void)
    
    /// Fetches a list of friend suggestions for the user.
    /// - Parameter completion: Closure with Result containing friend suggestions or an error.
    func fetchFriendSuggestions(completion: @escaping (Result<[UserModel], BusinessError>) -> Void)
}
