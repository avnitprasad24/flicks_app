//  PhotoModelTests.swift
//  flicks_app
//
//  Created by Av on 3/2/25.

import XCTest
@testable import flicks_app

class PhotoModelTests: XCTestCase {
    func testPhotoModelInitialization() {
        let url = URL(string: "https://example.com/photo.jpg")!
        let photo = PhotoModel(id: "1", userId: "user123", url: url, likes: 100)
        XCTAssertEqual(photo.id, "1")
        XCTAssertEqual(photo.userId, "user123")
        XCTAssertEqual(photo.url, url)
        XCTAssertEqual(photo.likes, 100)
    }
    
    func testPhotoModelEquality() {
        let url1 = URL(string: "https://example.com/photo.jpg")!
        let url2 = URL(string: "https://example.com/photo2.jpg")!
        let photo1 = PhotoModel(id: "1", userId: "user123", url: url1, likes: 100)
        let photo2 = PhotoModel(id: "1", userId: "user123", url: url1, likes: 100)
        let photo3 = PhotoModel(id: "2", userId: "user124", url: url2, likes: 200)
        XCTAssertEqual(photo1, photo2)
        XCTAssertNotEqual(photo1, photo3)
    }
    
    func testPhotoModelCodable() {
        let url = URL(string: "https://example.com/photo.jpg")!
        let photo = PhotoModel(id: "1", userId: "user123", url: url, likes: 100)
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
}
