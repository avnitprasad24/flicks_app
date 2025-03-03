//  LikeUseCaseTests.swift
//  flicks_appTests
//
//  Created by Av on 3/2/25.
//  Version 1.0
//

// testing interaction funcs ie , like/unlike etc . seems like thats all there is rn lol 

import XCTest
@testable import flicks_app

class MockInteractionRepository: InteractionRepositoryProtocol {
    var likePostCalled = false
    var unlikePostCalled = false
    var shouldThrowError = false
    var postId: String?
    var userId: String?
    
    func likePost(postId: String, userId: String) async throws -> Bool {
        likePostCalled = true
        self.postId = postId
        self.userId = userId
        if shouldThrowError {
            throw NSError(domain: NSURLErrorDomain, code: -1009, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        }
        return true
    }
    
    func unlikePost(postId: String, userId: String) async throws -> Bool {
        unlikePostCalled = true
        self.postId = postId
        self.userId = userId
        if shouldThrowError {
            throw NSError(domain: NSURLErrorDomain, code: -1009, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        }
        return true
    }
}

class LikeUseCaseTests: XCTestCase {
    var useCase: LikeUseCase!
    var mockRepository: MockInteractionRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockInteractionRepository()
        useCase = LikeUseCase(interactionRepository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func testLikePostSuccess() async {
        do {
            let expectation = XCTestExpectation(description: "Like post completes successfully")
            let success = try await useCase.execute(postId: "post1", userId: "user1")
            XCTAssertTrue(mockRepository.likePostCalled, "likePost should be called")
            XCTAssertEqual(mockRepository.postId, "post1")
            XCTAssertEqual(mockRepository.userId, "user1")
            XCTAssertTrue(success)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        wait(for: [XCTestExpectation()], timeout: 1.0)
    }
    
    func testUnlikePostSuccess() async {
        do {
            let expectation = XCTestExpectation(description: "Unlike post completes successfully")
            let success = try await useCase.undo(postId: "post1", userId: "user1")
            XCTAssertTrue(mockRepository.unlikePostCalled, "unlikePost should be called")
            XCTAssertEqual(mockRepository.postId, "post1")
            XCTAssertEqual(mockRepository.userId, "user1")
            XCTAssertTrue(success)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        wait(for: [XCTestExpectation()], timeout: 1.0)
    }
    
    // MARK: - Validation Failure Tests
    func testLikePostEmptyPostIdFailure() async {
        do {
            let _ = try await useCase.execute(postId: "", userId: "user1")
            XCTFail("Should throw validation error for empty post ID")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Post ID cannot be empty")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testLikePostEmptyUserIdFailure() async {
        do {
            let _ = try await useCase.execute(postId: "post1", userId: "")
            XCTFail("Should throw validation error for empty user ID")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "User ID cannot be empty")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Error Handling Tests
    func testLikePostNetworkError() async {
        mockRepository.shouldThrowError = true
        do {
            let _ = try await useCase.execute(postId: "post1", userId: "user1")
            XCTFail("Should throw network error")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Network error")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testUnlikePostNetworkError() async {
        mockRepository.shouldThrowError = true
        do {
            let _ = try await useCase.undo(postId: "post1", userId: "user1")
            XCTFail("Should throw network error")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Network error")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Performance Test
    func testLikePostPerformance() async {
        measure(metrics: [XCTClockMetric()]) {
            do {
                let _ = try await useCase.execute(postId: "post1", userId: "user1")
            } catch {
                XCTFail("Performance test failed: \(error.localizedDescription)")
            }
        }
    }
}
