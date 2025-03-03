//  UserModelTests.swift
//  flicks_app
//

import XCTest
@testable import flicks_app

class UserModelTests: XCTestCase {
    func testUserModelInitialization() {
        let user = UserModel(id: "1", name: "John Doe", username: "johndoe", bio: "Lover of photos", musicService: "spotify")
        XCTAssertEqual(user.id, "1")
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.username, "johndoe")
        XCTAssertEqual(user.bio, "Lover of photos")
        XCTAssertEqual(user.musicService, "spotify")
    }
    
    func testUserModelEquality() {
        let user1 = UserModel(id: "1", name: "John Doe", username: "johndoe")
        let user2 = UserModel(id: "1", name: "John Doe", username: "johndoe")
        let user3 = UserModel(id: "2", name: "Jane Doe", username: "janedoe")
        XCTAssertEqual(user1, user2)
        XCTAssertNotEqual(user1, user3)
    }
    
    func testUserModelCodable() {
        let user = UserModel(id: "1", name: "John Doe", username: "johndoe", bio: "Lover of photos", musicService: "spotify")
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        do {
            let data = try encoder.encode(user)
            let decodedUser = try decoder.decode(UserModel.self, from: data)
            XCTAssertEqual(user, decodedUser)
        } catch {
            XCTFail("Encoding/Decoding failed: \(error.localizedDescription)")
        }
    }
}
