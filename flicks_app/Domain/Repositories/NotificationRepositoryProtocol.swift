//  NotificationRepositoryProtocol.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial implementation for clean architecture.
//  This file defines the NotificationRepositoryProtocol within the Domain layer, outlining notification-related operations for the Flicks! app.
//  It is designed as a protocol to support real-time notifications and scalability with WebSocket integration.
//  Future versions may add notification categorization or unread count tracking, requiring additional methods and data models.
//
import Foundation

/// Protocol defining notification-related operations for the Flicks app.
protocol NotificationRepositoryProtocol {
    /// Fetches notifications for the current user.
    /// - Parameters:
    ///   - userId: The ID of the user whose notifications to fetch.
    ///   - completion: Closure with Result containing the notification list or an error.
    func fetchNotifications(userId: String, completion: @escaping (Result<[Notification], BusinessError>) -> Void)
    
    /// Sends a notification to a user.
    /// - Parameters:
    ///   - userId: The ID of the recipient user.
    ///   - message: The notification message.
    ///   - completion: Closure with Result indicating success or failure.
    func sendNotification(userId: String, message: String, completion: @escaping (Result<Void, BusinessError>) -> Void)
}
