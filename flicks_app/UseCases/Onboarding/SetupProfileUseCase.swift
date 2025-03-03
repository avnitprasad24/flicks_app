//  SetupProfileUseCase.swift
//  flicks_app
//
//  Created by Av on 3/2/25.



// 


import Foundation

class SetupProfileUseCase {
    private let userRepository: UserRepositoryProtocol
    private let validationRules: ProfileValidationRules
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
        self.validationRules = ProfileValidationRules()
    }
    
    struct ProfileValidationRules {
        func validateName(_ name: String) throws {
            guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
                throw BusinessError.validationError(message: "Name cannot be empty")
            }
            guard name.count <= 50 else {
                throw BusinessError.validationError(message: "Name must be 50 characters or less")
            }
        }
        
        func validateUsername(_ username: String) throws {
            let usernameRegex = "^[a-zA-Z0-9_]{3,20}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
            guard predicate.evaluate(with: username) else {
                throw BusinessError.validationError(message: "Username must be 3-20 characters with letters, numbers, or underscores")
            }
        }
        
        func validateBio(_ bio: String?) throws {
            guard bio?.count ?? 0 <= 160 else {
                throw BusinessError.validationError(message: "Bio must be 160 characters or less")
            }
        }
    }
    
    func execute(name: String, username: String, bio: String?, musicService: String?) async throws {
        // Validate inputs
        try validationRules.validateName(name)
        try validationRules.validateUsername(username)
        try validationRules.validateBio(bio)
        
        // Create user profile data
        let profile = UserModel(
            id: UUID().uuidString,
            name: name,
            username: username,
            bio: bio,
            musicService: musicService,
            createdAt: Date()
        )
        
        do {
            // Simulate API call to save profile
            try await userRepository.saveProfile(profile)
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
extension SetupProfileUseCase {
    func simulateSuccess() async throws {
        // Mock success for testing
        let profile = UserModel(id: UUID().uuidString, name: "Test User", username: "testuser", bio: nil, musicService: nil, createdAt: Date())
        try await userRepository.saveProfile(profile)
    }
}
