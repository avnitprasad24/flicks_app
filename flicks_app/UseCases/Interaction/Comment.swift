//  AddCommentUseCase.swift
//  flicks_app
//
//  Created by Av on 3/2/25.

// 1000 chars for a comment is lowk wild but whatev . "comment cant be empty" (line 37) seems kinda sus? idek , i think its only when user actually types but could base this on keyboard where if numChars <1 , user !post ? 


import Foundation

struct Comment {
    let id: String
    let postId: String
    let userId: String
    let content: String
    let timestamp: Date
}

class AddCommentUseCase {
    private let interactionRepository: InteractionRepositoryProtocol
    private let validator: CommentValidator
    
    init(interactionRepository: InteractionRepositoryProtocol) {
        self.interactionRepository = interactionRepository
        self.validator = CommentValidator()
    }
    
    struct CommentValidator {
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
        
        func validateContent(_ content: String) throws {
            guard !content.trimmingCharacters(in: .whitespaces).isEmpty else {
                throw BusinessError.validationError(message: "Comment cannot be empty")
            }
            guard content.count <= 1000 else {
                throw BusinessError.validationError(message: "Comment must be 1000 characters or less")
            }
        }
    }
    
    func execute(postId: String, userId: String, content: String) async throws -> Comment {
        // Validate inputs
        try validator.validatePostId(postId)
        try validator.validateUserId(userId)
        try validator.validateContent(content)
        
        // Create comment model
        let comment = Comment(
            id: UUID().uuidString,
            postId: postId,
            userId: userId,
            content: content,
            timestamp: Date()
        )
        
        do {
            // Simulate saving comment to repository (placeholder for actual implementation)
            try await interactionRepository.likePost(postId: postId, userId: userId) // Placeholder; replace with comment-specific method
            return comment
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
extension AddCommentUseCase {
    func simulateSuccess(postId: String, userId: String, content: String) async throws -> Comment {
        // Mock success for testing
        return Comment(id: UUID().uuidString, postId: postId, userId: userId, content: content, timestamp: Date())
    }
}
