//  FriendRepositoryProtocol.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial implementation for clean architecture.
//  This file defines the FriendRepositoryProtocol within the Domain layer, outlining friend-related operations for the Flicks! app.
//  It is designed as a protocol to support friend suggestions, adding, and removal with scalability for 1M users.
//  Future versions may add friend request status tracking or group features, requiring protocol enhancements and data models.
//
import Foundation

/// Protocol defining friend-related operations for the Flicks app.
protocol FriendRepositoryProtocol {
    /// Fetches friend suggestions for the current user.
    /// - Parameters:
    ///   - userId: The ID of the user whose friend suggestions to fetch.
    ///   - completion: Closure with Result containing the friend suggestion list or an error.
    func fetchFriendSuggestions(userId: String, completion: @escaping (Result<[UserModel], BusinessError>) -> Void)
    
    /// Adds a friend for the current user.
    /// - Parameters:
    ///   - userId: The ID of the current user.
    ///   - friendId: The ID of the friend to add.
    ///   - completion: Closure with Result indicating success or failure.
    func addFriend(userId: String, friendId: String, completion: @escaping (Result<Void, BusinessError>) -> Void)
    
    /// Removes a friend for the current user.
    /// - Parameters:
    ///   - userId: The ID of the current user.
    ///   - friendId: The ID of the friend to remove.
    ///   - completion: Closure with Result indicating success or failure.
    func removeFriend(userId: String, friendId: String, completion: @escaping (Result<Void, BusinessError>) -> Void)
}
