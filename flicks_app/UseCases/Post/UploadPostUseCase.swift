//  UploadPostUseCase.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - 



// codebase for uploading pngs onto profiles and homepage -- mb size lowk can be changed bc most fullscreen pics are ~50mb ? i think - idk but ballpark its 50mb 

import Foundation



class UploadPostUseCase {
    private let postRepository: PostRepositoryProtocol
    private let fileValidator: FileValidator
    private let maxFileSize: Int64 = 20 * 1024 * 1024 // 20MB limit
    
    init(postRepository: PostRepositoryProtocol) {
        self.postRepository = postRepository
        self.fileValidator = FileValidator(maxSize: maxFileSize)
    }
    
    struct FileValidator {
        private let maxSize: Int64
        
        init(maxSize: Int64) {
            self.maxSize = maxSize
        }
        
        func validateFile(_ data: Data) throws {
            guard data.count <= maxSize else {
                throw BusinessError.uploadFailed(message: "File size exceeds storage limit", fileSize: data.count)
            }
            guard let _ = UIImage(data: data) else {
                throw BusinessError.validationError(message: "Invalid image data")
            }
        }
    }
    
    func execute(caption: String, mediaData: Data, userId: String) async throws -> String {
        // Validate inputs
        try fileValidator.validateFile(mediaData)
        guard !caption.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw BusinessError.validationError(message: "Caption cannot be empty")
        }
        guard caption.count <= 500 else {
            throw BusinessError.validationError(message: "Caption must be 500 characters or less")
        }
        
        // Create post model
        let post = PostModel(
            id: UUID().uuidString,
            userId: userId,
            caption: caption,
            mediaUrl: "", // Placeholder, to be updated post-upload
            timestamp: Date(),
            mediaType: "image/jpeg" // Assume JPEG for now
        )
        
        do {
            // Upload post to repository with progress tracking
            let postId = try await postRepository.uploadPost(post, mediaData: mediaData)
            return postId
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
extension UploadPostUseCase {
    func simulateSuccess(caption: String, mediaData: Data) async throws -> String {
        // Mock success for testing
        let post = PostModel(id: UUID().uuidString, userId: "user1", caption: caption, mediaUrl: "", timestamp: Date(), mediaType: "image/jpeg")
        return try await postRepository.uploadPost(post, mediaData: mediaData)
    }
}
