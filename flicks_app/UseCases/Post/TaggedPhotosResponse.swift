//  FetchTaggedPhotosUseCase.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 -

// 


// boilerplate code --> empty html links for image fetching 


import Foundation

struct TaggedPhotosResponse {
    let photos: [PhotoModel]
    let nextPageToken: String?
    let shardId: String
}

class FetchTaggedPhotosUseCase {
    private let postRepository: PostRepositoryProtocol
    private let paginationValidator: PaginationValidator
    
    init(postRepository: PostRepositoryProtocol) {
        self.postRepository = postRepository
        self.paginationValidator = PaginationValidator()
    }
    
    struct PaginationValidator {
        func validatePage(_ page: Int) throws {
            guard page > 0 else {
                throw BusinessError.validationError(message: "Page must be greater than 0")
            }
        }
        
        func validateLimit(_ limit: Int) throws {
            guard limit > 0 && limit <= 50 else {
                throw BusinessError.validationError(message: "Limit must be between 1 and 50")
            }
        }
        
        func validateUserId(_ userId: String) throws {
            guard !userId.trimmingCharacters(in: .whitespaces).isEmpty else {
                throw BusinessError.validationError(message: "User ID cannot be empty")
            }
        }
    }
    
    func execute(userId: String, page: Int, limit: Int, nextPageToken: String? = nil) async throws -> TaggedPhotosResponse {
        // Validate inputs
        try paginationValidator.validatePage(page)
        try paginationValidator.validateLimit(limit)
        try paginationValidator.validateUserId(userId)
        
        do {
            // Fetch tagged photos from repository with pagination
            let photos = try await postRepository.fetchPosts(userId: userId)
                .filter { $0.userId == userId } // Simulate tagged photos filter
                .dropFirst((page - 1) * limit)
                .prefix(limit)
                .map { $0 }
            let shardId = generateShardId() // Simulate sharding for scalability
            let nextToken = photos.count == limit ? "token_\(page + 1)_\(shardId)" : nil
            
            return TaggedPhotosResponse(photos: Array(photos), nextPageToken: nextToken, shardId: shardId)
        } catch {
            throw mapToBusinessError(error)
        }
    }
    
    private func generateShardId() -> String {
        // Simulate sharding logic (e.g., based on user ID or region)
        return "shard_\(UUID().uuidString.prefix(8))"
    }
    
    private func mapToBusinessError(_ error: Error) -> BusinessError {
        // Map underlying errors to BusinessError cases
        if let nsError = error as NSError?, nsError.domain == NSURLErrorDomain {
            return BusinessError.networkError(message: nsError.localizedDescription)
        } else if let businessError = error as? BusinessError {
            return businessError
        }
        return BusinessError.unknown(message: "An unexpected error occurred")
    }
}

// Extension for testing (to be moved to test target later)
extension FetchTaggedPhotosUseCase {
    func simulateSuccess(userId: String, page: Int, limit: Int) async throws -> TaggedPhotosResponse {
        // Mock success for testing
        let mockPhotos = [
            PhotoModel(id: UUID().uuidString, url: "https://example.com/photo1.jpg", caption: "Photo 1", userId: userId, timestamp: Date()),
            PhotoModel(id: UUID().uuidString, url: "https://example.com/photo2.jpg", caption: "Photo 2", userId: userId, timestamp: Date())
        ]
        let shardId = generateShardId()
        let nextToken = limit == 2 ? "token_\(page + 1)_\(shardId)" : nil
        return TaggedPhotosResponse(photos: mockPhotos, nextPageToken: nextToken, shardId: shardId)
    }
}
