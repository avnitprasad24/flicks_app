//  UploadPostUseCaseTests.swift
//  flicks_appTests
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial FAANG CTO-level unit tests for UploadPostUseCase.
//  This file defines unit tests for the UploadPostUseCase within the UseCases layer for the Flicks! app.
//  It is designed with XCTest, targeting 95%+ code coverage, using mocks and async/await.
//  Future versions may add performance benchmarks or edge case expansions, requiring test case updates.
//
//  - Coverage: Targets 95%+ with success, failure, and edge cases.
//  - Performance: Benchmarks sub-200ms test execution.
//  - Scalability: Supports parallel test execution for CI/CD.
import XCTest
@testable import flicks_app // Adjust module name based on your target

class MockPostRepository: PostRepositoryProtocol {
    var uploadPostCalled = false
    var shouldThrowError = false
    var uploadedPostId: String?
    var uploadedPost: PostModel?
    var uploadedMediaData: Data?
    
    func uploadPost(_ post: PostModel, mediaData: Data) async throws -> String {
        uploadPostCalled = true
        uploadedPost = post
        uploadedMediaData = mediaData
        if shouldThrowError {
            throw NSError(domain: NSURLErrorDomain, code: -1009, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        }
        uploadedPostId = UUID().uuidString
        return uploadedPostId!
    }
    
    func fetchPosts(userId: String) async throws -> [PostModel] {
        return []
    }
}

class UploadPostUseCaseTests: XCTestCase {
    var useCase: UploadPostUseCase!
    var mockRepository: MockPostRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPostRepository()
        useCase = UploadPostUseCase(postRepository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func testUploadPostSuccess() async {
        let mediaData = UIImage(named: "flicks1")?.jpegData(compressionQuality: 0.8) ?? Data()
        do {
            let expectation = XCTestExpectation(description: "Post upload completes successfully")
            let postId = try await useCase.execute(caption: "Test caption", mediaData: mediaData, userId: "user1")
            XCTAssertTrue(mockRepository.uploadPostCalled, "uploadPost should be called")
            XCTAssertNotNil(mockRepository.uploadedPost)
            XCTAssertNotNil(mockRepository.uploadedMediaData)
            XCTAssertEqual(mockRepository.uploadedPost?.caption, "Test caption")
            XCTAssertEqual(mockRepository.uploadedPost?.userId, "user1")
            XCTAssertNotNil(postId)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        wait(for: [XCTestExpectation()], timeout: 1.0)
    }
    
    // MARK: - Validation Failure Tests
    func testUploadPostEmptyCaptionFailure() async {
        let mediaData = UIImage(named: "flicks1")?.jpegData(compressionQuality: 0.8) ?? Data()
        do {
            let _ = try await useCase.execute(caption: "", mediaData: mediaData, userId: "user1")
            XCTFail("Should throw validation error for empty caption")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Caption cannot be empty")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testUploadPostLongCaptionFailure() async {
        let mediaData = UIImage(named: "flicks1")?.jpegData(compressionQuality: 0.8) ?? Data()
        let longCaption = String(repeating: "a", count: 501)
        do {
            let _ = try await useCase.execute(caption: longCaption, mediaData: mediaData, userId: "user1")
            XCTFail("Should throw validation error for long caption")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Caption must be 500 characters or less")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testUploadPostLargeFileFailure() async {
        let largeData = Data(count: 11 * 1024 * 1024) // 11MB
        do {
            let _ = try await useCase.execute(caption: "Test caption", mediaData: largeData, userId: "user1")
            XCTFail("Should throw validation error for large file")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "File size exceeds 10MB limit")
            if case let BusinessError.uploadFailed(_, fileSize) = error {
                XCTAssertGreaterThanOrEqual(fileSize, 11 * 1024 * 1024)
            }
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testUploadPostInvalidImageFailure() async {
        let invalidData = Data(count: 1024) // Invalid image data
        do {
            let _ = try await useCase.execute(caption: "Test caption", mediaData: invalidData, userId: "user1")
            XCTFail("Should throw validation error for invalid image")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Invalid image data")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Error Handling Tests
    func testUploadPostNetworkError() async {
        let mediaData = UIImage(named: "flicks1")?.jpegData(compressionQuality: 0.8) ?? Data()
        mockRepository.shouldThrowError = true
        do {
            let _ = try await useCase.execute(caption: "Test caption", mediaData: mediaData, userId: "user1")
            XCTFail("Should throw network error")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Network error")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Performance Test
    func testUploadPostPerformance() async {
        let mediaData = UIImage(named: "flicks1")?.jpegData(compressionQuality: 0.8) ?? Data()
        measure(metrics: [XCTClockMetric()]) {
            do {
                let _ = try await useCase.execute(caption: "Test caption", mediaData: mediaData, userId: "user1")
            } catch {
                XCTFail("Performance test failed: \(error.localizedDescription)")
            }
        }
    }
}
