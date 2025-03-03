//  LikeUseCase.swift
//  flicks_app
//
//  Created by Av on 3/2/25.

// like / unlike function code . idk if the LikeValidator is fine bc it throws error at user
// 




import Foundation

class LikeUseCase {
    private let interactionRepository: InteractionRepositoryProtocol
    private let validator: LikeValidator
    
    init(interactionRepository: InteractionRepositoryProtocol) {
        self.interactionRepository = interactionRepository
        self.validator = LikeValidator()
    }
    
    struct LikeValidator {
        func validatePostId(_ postId: String) throws {
            guard !postId.trimmingCharacters(in: .whitespaces).isEmpty else {
                throw BusinessError.validationError(message: "Post ID cannot be empty")
            }
        }
        
        func validateUserId(_ userId: String) throws {
            guard !userId.trimmingCharacters(in: .whitespaces).isEmpty else {
                throw BusinessError.validationError(message: "User ID cannot be empty")
            }
        }
    }
    
    func execute(postId: String, userId: String) async throws -> Bool {
        // Validate inputs
        try validator.validatePostId(postId)
        try validator.validateUserId(userId)
        
        do {
            // Attempt to like the post
            let success = try await interactionRepository.likePost(postId: postId, userId: userId)
            if !success {
                throw BusinessError.unknown(message: "Failed to like post")
            }
            return success
        } catch {
            throw mapToBusinessError(error)
        }
    }
    
    func undo(postId: String, userId: String) async throws -> Bool {
        // Validate inputs
        try validator.validatePostId(postId)
        try validator.validateUserId(userId)
        
        do {
            // Attempt to unlike the post
            let success = try await interactionRepository.unlikePost(postId: postId, userId: userId)
            if !success {
                throw BusinessError.unknown(message: "Failed to unlike post")
            }
            return success
        } catch {
            throw mapToBusinessError(error)
        }
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
extension LikeUseCase {
    func simulateSuccess(postId: String, userId: String) async throws -> Bool {
        // Mock success for testing
        return try await interactionRepository.likePost(postId: postId, userId: userId)
    }
}
