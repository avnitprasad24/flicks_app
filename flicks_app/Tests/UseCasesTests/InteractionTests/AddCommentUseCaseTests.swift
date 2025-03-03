//  AddCommentUseCaseTests.swift
//  flicks_appTests
//
//  Created by Av on 3/2/25.
//  Version 1.0


// testing . still idk about the empty chars error , should be moved up and restricted from posting based on numChars < 1 ? 


import XCTest
@testable import flicks_app

class MockInteractionRepository: InteractionRepositoryProtocol {
    var addCommentCalled = false
    var shouldThrowError = false
    var addedComment: Comment?
    var postId: String?
    var userId: String?
    var content: String?
    
    func addComment(postId: String, userId: String, content: String) async throws -> Comment {
        addCommentCalled = true
        self.postId = postId
        self.userId = userId
        self.content = content
        if shouldThrowError {
            throw NSError(domain: NSURLErrorDomain, code: -1009, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        }
        let comment = Comment(id: UUID().uuidString, postId: postId, userId: userId, content: content, timestamp: Date())
        addedComment = comment
        return comment
    }
    
    func likePost(postId: String, userId: String) async throws -> Bool {
        return true
    }
    
    func unlikePost(postId: String, userId: String) async throws -> Bool {
        return true
    }
}

class AddCommentUseCaseTests: XCTestCase {
    var useCase: AddCommentUseCase!
    var mockRepository: MockInteractionRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockInteractionRepository()
        useCase = AddCommentUseCase(interactionRepository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func testAddCommentSuccess() async {
        do {
            let expectation = XCTestExpectation(description: "Added comment completes successfully")
            let comment = try await useCase.execute(postId: "post1", userId: "user1", content: "Great post!")
            XCTAssertTrue(mockRepository.addCommentCalled, "addComment should be called")
            XCTAssertEqual(mockRepository.postId, "post1")
            XCTAssertEqual(mockRepository.userId, "user1")
            XCTAssertEqual(mockRepository.content, "Great post!")
            XCTAssertNotNil(mockRepository.addedComment)
            XCTAssertEqual(comment.content, "Great post!")
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        wait(for: [XCTestExpectation()], timeout: 1.0)
    }
    
    // MARK: - Validation Failure Tests
    func testAddCommentEmptyPostIdFailure() async {
        do {
            let _ = try await useCase.execute(postId: "", userId: "user1", content: "tuff gangy")
            XCTFail("Should throw validation error for empty post ID")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Post ID cannot be empty")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testAddCommentEmptyUserIdFailure() async {
        do {
            let _ = try await useCase.execute(postId: "post1", userId: "", content: "yuururrrr")
            XCTFail("Should throw validation error for empty user ID")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "User ID cannot be empty")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testAddCommentEmptyContentFailure() async {
        do {
            let _ = try await useCase.execute(postId: "post1", userId: "user1", content: "")
            XCTFail("Should throw validation error for empty content")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Comment cannot be empty")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testAddCommentLongContentFailure() async {
        do {
            let longContent = String(repeating: "a", count: 1001)
            let _ = try await useCase.execute(postId: "post1", userId: "user1", content: longContent)
            XCTFail("Should throw validation error for long content")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Comment must be 1000 characters or less")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Error Handling Tests
    func testAddCommentNetworkError() async {
        mockRepository.shouldThrowError = true
        do {
            let _ = try await useCase.execute(postId: "post1", userId: "user1", content: "yesssirskiii")
            XCTFail("Should throw network error")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Network error")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Performance Test
    func testAddCommentPerformance() async {
        measure(metrics: [XCTClockMetric()]) {
            do {
                let _ = try await useCase.execute(postId: "post1", userId: "user1", content: "Great post!")
            } catch {
                XCTFail("Performance test failed: \(error.localizedDescription)")
            }
        }
    }
}
