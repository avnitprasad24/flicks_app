//  HomeRepositoryProtocol.swift
//  flicks_app
//
//  Created by Av.
//  Version 1.0 - Initial implementation for clean architecture.
//  This file defines the HomeRepositoryProtocol within the Domain layer, outlining home feed operations with pagination and seeding for the Flicks! app.
//  It is designed as a protocol to support scalable feed generation and sharding integration.
//  Future versions may add real-time feed updates or curated content filters, requiring protocol enhancements and schema adjustments.
//
import Foundation

/// Protocol defining home feed-related operations for the Flicks app.
protocol HomeRepositoryProtocol {
    /// Fetches the home feed posts with pagination.
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - limit: The number of posts per page.
    ///   - completion: Closure with Result containing the home feed data or an error.
    func fetchHomePosts(page: Int, limit: Int, completion: @escaping (Result<HomeModel, BusinessError>) -> Void)
    
    /// Seeds initial feed data for new users.
    /// - Parameter completion: Closure with Result indicating success or failure.
    func seedInitialFeed(completion: @escaping (Result<Void, BusinessError>) -> Void)
}
