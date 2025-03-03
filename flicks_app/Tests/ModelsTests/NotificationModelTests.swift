//  NotificationModelTests.swift
//  flicks_app
//
//  Created by Av on 3/2/25.

//
import XCTest
@testable import flicks_app

class NotificationModelTests: XCTestCase {
    func testNotificationModelInitialization() {
        let notification = NotificationModel(userId: "user123", message: "New like from @friend!")
        XCTAssertNotNil(notification.id)
        XCTAssertEqual(notification.userId, "user123")
        XCTAssertEqual(notification.message, "New like from @friend!")
        XCTAssertLessThan(abs(notification.timestamp.timeIntervalSinceNow), 1.0) // Within 1 second
        XCTAssertFalse(notification.isRead)
    }
    
    func testNotificationModelEquality() {
        let date = Date()
        let notification1 = NotificationModel(userId: "user123", message: "New like!", timestamp: date, isRead: false)
        let notification2 = NotificationModel(userId: "user123", message: "New like!", timestamp: date, isRead: false)
        let notification3 = NotificationModel(userId: "user124", message: "New comment!", timestamp: Date(), isRead: true)
        XCTAssertEqual(notification1, notification2)
        XCTAssertNotEqual(notification1, notification3)
    }
    
    func testNotificationModelCodableWithReadStatus() {
        let date = Date()
        let notification = NotificationModel(userId: "user123", message: "New like!", timestamp: date, isRead: true)
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        do {
            let data = try encoder.encode(notification)
            let decodedNotification = try decoder.decode(NotificationModel.self, from: data)
            XCTAssertEqual(notification, decodedNotification)
            XCTAssertTrue(decodedNotification.isRead)
        } catch {
            XCTFail("Encoding/Decoding failed: \(error.localizedDescription)")
        }
    }
    
    func testNotificationModelEdgeCaseEmptyMessage() {
        XCTAssertThrowsError(try JSONEncoder().encode(NotificationModel(userId: "user123", message: ""))) { error in
            if case .dataCorrupted(_) = (error as? DecodingError) {
                XCTAssertTrue(true) // Expected failure for empty message
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }
}
