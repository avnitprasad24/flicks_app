//  PhotoModelTests.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial implementation for unit testing.

import XCTest
@testable import flicks_app

class PhotoModelTests: XCTestCase {
    func testPhotoModelInitialization() {
        let url = URL(string: "https://example.com/beach.jpg")!
        let photo = PhotoModel(userId: "user123", url: url, likes: 500)
        XCTAssertNotNil(photo.id)
        XCTAssertEqual(photo.userId, "user123")
        XCTAssertEqual(photo.url, url)
        XCTAssertEqual(photo.likes, 500)
        XCTAssertLessThan(abs(photo.uploadedAt.timeIntervalSinceNow), 1.0) // Within 1 second
    }
    
    func testPhotoModelEquality() {
        let url1 = URL(string: "https://example.com/beach.jpg")!
        let url2 = URL(string: "https://example.com/football.jpg")!
        let photo1 = PhotoModel(userId: "user123", url: url1, likes: 100)
        let photo2 = PhotoModel(userId: "user123", url: url1, likes: 100)
        let photo3 = PhotoModel(userId: "user124", url: url2, likes: 200)
        XCTAssertEqual(photo1, photo2)
        XCTAssertNotEqual(photo1, photo3)
    }
    
    func testPhotoModelCodable() {
        let url = URL(string: "https://example.com/beach.jpg")!
        let photo = PhotoModel(userId: "user123", url: url, likes: 100)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        do {
            let data = try encoder.encode(photo)
            let decodedPhoto = try decoder.decode(PhotoModel.self, from: data)
            XCTAssertEqual(photo, decodedPhoto)
        } catch {
            XCTFail("Encoding/Decoding failed: \(error.localizedDescription)")
        }
    }
    
    func testPhotoModelMaxFileSizeConstant() {
        XCTAssertEqual(PhotoModel.maxFileSize, 10 * 1024 * 1024, "Max file size should be 10MB")
    }
}
