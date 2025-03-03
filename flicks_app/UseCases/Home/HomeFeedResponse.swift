//  FetchHomePostsUseCase.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0







import Foundation

struct HomeFeedResponse {
    let posts: [PhotoModel]
    let nextPageToken: String?
    let shardId: String
}

class FetchHomePostsUseCase {
    private let homeRepository: HomeRepositoryProtocol
    private let paginationValidator: PaginationValidator
    
    init(homeRepository: HomeRepositoryProtocol) {
        self.homeRepository = homeRepository
        self.paginationValidator = PaginationValidator()
    }
    
    struct PaginationValidator {
        func validatePage(_ page: Int) throws {
            guard page > 0 else {
                throw BusinessError.validationError(message: "Page must be greater than 0")
            }
        }
        
        func validateLimit(_ limit: Int) throws {
            guard limit > 0 && limit <= 100 else {
                throw BusinessError.validationError(message: "Limit must be between 1 and 100")
            }
        }
    }
    
    func execute(page: Int, limit: Int, nextPageToken: String? = nil) async throws -> HomeFeedResponse {
        // Validate pagination parameters
        try paginationValidator.validatePage(page)
        try paginationValidator.validateLimit(limit)
        
        do {
            // Fetch posts from repository with pagination
            let posts = try await homeRepository.fetchHomePosts(page: page, limit: limit, nextPageToken: nextPageToken)
            let shardId = generateShardId() // Simulate sharding for scalability
            let nextToken = posts.isEmpty ? nil : "token_\(page + 1)_\(shardId)"
            
            return HomeFeedResponse(posts: posts, nextPageToken: nextToken, shardId: shardId)
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
extension FetchHomePostsUseCase {
    func simulateSuccess(page: Int, limit: Int) async throws -> HomeFeedResponse {
        // Mock success for testing
        let mockPosts = [PhotoModel(id: UUID().uuidString, url: "https://example.com/photo.jpg", caption: "Test", userId: "user1", timestamp: Date())]
        let shardId = generateShardId()
        let nextToken = "token_\(page + 1)_\(shardId)"
        return HomeFeedResponse(posts: mockPosts, nextPageToken: nextToken, shardId: shardId)
    }
}
