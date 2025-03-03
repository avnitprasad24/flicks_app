//  PhotoRepositoryProtocol.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial implementation for clean architecture.
//  This file defines the PhotoRepositoryProtocol within the Domain layer, outlining photo-related operations for the Flicks! app.
//  It is designed as a protocol to support photo fetching, uploading, and deletion with scalability in mind.
//  Future versions may add tagging or filtering methods, requiring protocol extensions and schema updates.
//
import Foundation

/// Protocol defining photo-related operations for the Flicks app.
protocol PhotoRepositoryProtocol {
    /// Fetches photos for a given user with pagination.
    /// - Parameters:
    ///   - userId: The ID of the user whose photos to fetch.
    ///   - page: The page number to fetch.
    ///   - limit: The number of photos per page.
    ///   - completion: Closure with Result containing the photo list or an error.
    func fetchPhotos(userId: String, page: Int, limit: Int, completion: @escaping (Result<[Photo], BusinessError>) -> Void)
    
    /// Uploads a photo for a user.
    /// - Parameters:
    ///   - userId: The ID of the user uploading the photo.
    ///   - data: The photo data to upload.
    ///   - caption: Optional caption for the photo.
    ///   - completion: Closure with Result containing the photo ID or an error.
    func uploadPhoto(userId: String, data: Data, caption: String?, completion: @escaping (Result<String, BusinessError>) -> Void)
    
    /// Deletes a photo by its ID.
    /// - Parameters:
    ///   - photoId: The ID of the photo to delete.
    ///   - completion: Closure with Result indicating success or failure.
    func deletePhoto(photoId: String, completion: @escaping (Result<Void, BusinessError>) -> Void)
}
