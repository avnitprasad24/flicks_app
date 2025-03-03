//  SetupProfileUseCaseTests.swift
//  flicks_appTests
//
//  Created by Av on 3/2/25.
//  Version 1.0 -

import XCTest
@testable import flicks_app // Adjust module name based on your target

class MockUserRepository: UserRepositoryProtocol {
    var saveProfileCalled = false
    var shouldThrowError = false
    var savedProfile: UserModel?
    
    func saveProfile(_ profile: UserModel) async throws {
        saveProfileCalled = true
        savedProfile = profile
        if shouldThrowError {
            throw NSError(domain: NSURLErrorDomain, code: -1009, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        }
    }
}

class SetupProfileUseCaseTests: XCTestCase {
    var useCase: SetupProfileUseCase!
    var mockRepository: MockUserRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        useCase = SetupProfileUseCase(userRepository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func testSetupProfileSuccess() async {
        do {
            let expectation = XCTestExpectation(description: "Profile setup completes successfully")
            try await useCase.execute(name: "John Doe", username: "johndoe", bio: "Test bio", musicService: "appleMusic")
            XCTAssertTrue(mockRepository.saveProfileCalled, "saveProfile should be called")
            XCTAssertNotNil(mockRepository.savedProfile, "Profile should be saved")
            XCTAssertEqual(mockRepository.savedProfile?.name, "John Doe")
            XCTAssertEqual(mockRepository.savedProfile?.username, "johndoe")
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        wait(for: [XCTestExpectation()], timeout: 1.0)
    }
    
    // MARK: - Validation Failure Tests
    func testSetupProfileEmptyNameFailure() async {
        do {
            try await useCase.execute(name: "", username: "johndoe", bio: nil, musicService: nil)
            XCTFail("Should throw validation error for empty name")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Name cannot be empty")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testSetupProfileInvalidUsernameFailure() async {
        do {
            try await useCase.execute(name: "John Doe", username: "jo", bio: nil, musicService: nil)
            XCTFail("Should throw validation error for invalid username")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Username must be 3-20 characters with letters, numbers, or underscores")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testSetupProfileLongBioFailure() async {
        do {
            let longBio = String(repeating: "a", count: 161)
            try await useCase.execute(name: "John Doe", username: "johndoe", bio: longBio, musicService: nil)
            XCTFail("Should throw validation error for long bio")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Bio must be 160 characters or less")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Error Handling Tests
    func testSetupProfileNetworkError() async {
        mockRepository.shouldThrowError = true
        do {
            try await useCase.execute(name: "John Doe", username: "johndoe", bio: nil, musicService: nil)
            XCTFail("Should throw network error")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Network error")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Performance Test
    func testSetupProfilePerformance() async {
        measure(metrics: [XCTClockMetric()]) {
            do {
                try await useCase.execute(name: "John Doe", username: "johndoe", bio: "Test bio", musicService: "appleMusic")
            } catch {
                XCTFail("Performance test failed: \(error.localizedDescription)")
            }
        }
    }
}
