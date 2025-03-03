//  FetchHomePostsUseCaseTests.swift
//  flicks_appTests
//
//  Created by Av on 3/2/25.
//  Version 1.0

import XCTest
@testable import flicks_app // Adjust module name based on your target

class MockHomeRepository: HomeRepositoryProtocol {
    var fetchHomePostsCalled = false
    var shouldThrowError = false
    var mockPosts: [PhotoModel] = []
    var page: Int?
    var limit: Int?
    var nextPageToken: String?
    
    func fetchHomePosts(page: Int, limit: Int, nextPageToken: String?) async throws -> [PhotoModel] {
        fetchHomePostsCalled = true
        self.page = page
        self.limit = limit
        self.nextPageToken = nextPageToken
        if shouldThrowError {
            throw NSError(domain: NSURLErrorDomain, code: -1009, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        }
        return mockPosts
    }
}

class FetchHomePostsUseCaseTests: XCTestCase {
    var useCase: FetchHomePostsUseCase!
    var mockRepository: MockHomeRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockHomeRepository()
        useCase = FetchHomePostsUseCase(homeRepository: mockRepository)
        // Mock some posts for testing
        mockRepository.mockPosts = [
            PhotoModel(id: UUID().uuidString, url: "https://example.com/photo1.jpg", caption: "Photo 1", userId: "user1", timestamp: Date()),
            PhotoModel(id: UUID().uuidString, url: "https://example.com/photo2.jpg", caption: "Photo 2", userId: "user2", timestamp: Date())
        ]
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    func testFetchHomePostsSuccess() async {
        do {
            let expectation = XCTestExpectation(description: "Fetch home posts completes successfully")
            let response = try await useCase.execute(page: 1, limit: 10)
            XCTAssertTrue(mockRepository.fetchHomePostsCalled, "fetchHomePosts should be called")
            XCTAssertEqual(mockRepository.page, 1)
            XCTAssertEqual(mockRepository.limit, 10)
            XCTAssertEqual(mockRepository.nextPageToken, nil)
            XCTAssertEqual(response.posts.count, 2)
            XCTAssertNotNil(response.nextPageToken)
            XCTAssertNotNil(response.shardId)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        wait(for: [XCTestExpectation()], timeout: 1.0)
    }
    
    // MARK: - Validation Failure Tests
    func testFetchHomePostsInvalidPageFailure() async {
        do {
            let _ = try await useCase.execute(page: 0, limit: 10)
            XCTFail("Should throw validation error for invalid page")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Page must be greater than 0")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    func testFetchHomePostsInvalidLimitFailure() async {
        do {
            let _ = try await useCase.execute(page: 1, limit: 101)
            XCTFail("Should throw validation error for invalid limit")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Limit must be between 1 and 100")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Error Handling Tests
    func testFetchHomePostsNetworkError() async {
        mockRepository.shouldThrowError = true
        do {
            let _ = try await useCase.execute(page: 1, limit: 10)
            XCTFail("Should throw network error")
        } catch let error as BusinessError {
            XCTAssertEqual(error.localizedDescription, "Network error")
        } catch {
            XCTFail("Unexpected error type: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Pagination Tests
    func testFetchHomePostsWithNextPageToken() async {
        do {
            let expectation = XCTestExpectation(description: "Fetch home posts with next page token")
            let response = try await useCase.execute(page: 1, limit: 10, nextPageToken: "token_1")
            XCTAssertTrue(mockRepository.fetchHomePostsCalled)
            XCTAssertEqual(mockRepository.page, 1)
            XCTAssertEqual(mockRepository.limit, 10)
            XCTAssertEqual(mockRepository.nextPageToken, "token_1")
            XCTAssertEqual(response.posts.count, 2)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        wait(for: [XCTestExpectation()], timeout: 1.0)
    }
    
    // MARK: - Performance Test
    func testFetchHomePostsPerformance() async {
        measure(metrics: [XCTClockMetric()]) {
            do {
                let _ = try await useCase.execute(page: 1, limit: 10)
            } catch {
                XCTFail("Performance test failed: \(error.localizedDescription)")
            }
        }
    }
}
