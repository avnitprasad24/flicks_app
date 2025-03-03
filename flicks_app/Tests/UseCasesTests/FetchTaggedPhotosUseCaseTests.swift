//  FetchTaggedPhotosUseCaseTests.swift
//  flicks_appTests
//
//  Created by Av on 3/2/25.
//  Version 1.0


// testing tagged photos -- html blob for fetching png seemingly throws error down and to user when images <1 but idk . seems sus


import XCTest
@testable import flicks_app

class MockPostRepository: PostRepositoryProtocol {
    var fetchPostsCalled = false
    var shouldThrowError = false
    var mockPosts: [PhotoModel] = []
    var userId: String?
    
    func uploadPost(_ post: PostModel, mediaData: Data) async throws -> String {
        return UUID().uuidString
    }
    
    func fetchPosts(userId: String) async throws -> [PhotoModel] {
        fetchPostsCalled = true
        self.userId = userId
        if shouldThrowError {
            throw NSError(domain: NSURLErrorDomain, code: -1009, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        }
        return mockPosts
    }
}

class FetchTaggedPhotosUseCaseTests: XCTestCase {
    var useCase: FetchTaggedPhotosUseCase!
    var mockRepository: MockPostRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPostRepository()
        useCase = FetchTaggedPhotosUseCase(postRepository: mockRepository)
        // Mock some tagged photos for testing
        mockRepository.mockPosts = [
            PhotoModel(id: UUID().uuidString, url: "https://example.com/photo1.jpg", caption: "Photo 1", userId: "user1", timestamp: Date()),
            PhotoModel(id: UUID().uuidString, url: "https://example.com/photo2.jpg", caption: "Photo 2", userId: "user1", timestamp: Date()),
            PhotoModel(id: UUID().uuidString, url: "https://example.com/photo3.jpg", caption: "Photo 3", userId: "user2", timestamp: Date())
        ]
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func testFetchTaggedPhotosSuccess() async {
        do {
            let expectation = XCTestExpectation(description: "Fetch tagged photos completes successfully")
            let response = try await useCase.execute(userId: "user1", page: 1, limit: 2)
            XCTAssertTrue(mockRepository.fetchPostsCalled, "fetchPosts should be called")
            XCTAssertEqual(mockRepository.userId, "user1")
            XCTAssertEqual(response.photos.count, 2)
            XCTAssertEqual(response.photos[0].userId, "user1")
            XCTAssertNotNil(response.nextPageToken)
            XCTAssertNotNil(response.shardId)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        wait(for: [XCTestExpectation()], timeout: 1.0)
    }
    
    // MARK: - Validation Failure Tests
    func testFetchTaggedPhotosInvalidPageFailure() async {
        do {
            let _ = try await useCase.execute(userId: "user1", page: 0, limit: 2)
            XCTFail("Should throw validation error for invalid page")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Page must be greater than 0")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testFetchTaggedPhotosInvalidLimitFailure() async {
        do {
            let _ = try await useCase.execute(userId: "user1", page: 1, limit: 51)
            XCTFail("Should throw validation error for invalid limit")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Limit must be between 1 and 50")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testFetchTaggedPhotosInvalidUserIdFailure() async {
        do {
            let _ = try await useCase.execute(userId: "", page: 1, limit: 2)
            XCTFail("Should throw validation error for invalid user ID")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "User ID cannot be empty")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Pagination Tests
    func testFetchTaggedPhotosPagination() async {
        do {
            let expectation = XCTestExpectation(description: "Fetch tagged photos with pagination")
            let response = try await useCase.execute(userId: "user1", page: 1, limit: 1)
            XCTAssertEqual(response.photos.count, 1)
            let nextResponse = try await useCase.execute(userId: "user1", page: 2, limit: 1, nextPageToken: response.nextPageToken)
            XCTAssertEqual(nextResponse.photos.count, 1)
            XCTAssertNil(nextResponse.nextPageToken) // No more photos
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        wait(for: [XCTestExpectation()], timeout: 1.0)
    }
    
    // MARK: - Error Handling Tests
    func testFetchTaggedPhotosNetworkError() async {
        mockRepository.shouldThrowError = true
        do {
            let _ = try await useCase.execute(userId: "user1", page: 1, limit: 2)
            XCTFail("Should throw network error")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Network error")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Performance Test
    func testFetchTaggedPhotosPerformance() async {
        measure(metrics: [XCTClockMetric()]) {
            do {
                let _ = try await useCase.execute(userId: "user1", page: 1, limit: 2)
            } catch {
                XCTFail("Performance test failed: \(error.localizedDescription)")
            }
        }
    }
}
