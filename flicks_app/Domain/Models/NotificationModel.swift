//
//  NotificationModel.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//


//  NotificationModel.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial implementation for clean architecture.

import Foundation

struct NotificationModel: Codable, Equatable {
    let id: String
    let userId: String
    let message: String
    let timestamp: Date
    
    init(id: String, userId: String, message: String, timestamp: Date = Date()) {
        self.id = id
        self.userId = userId
        self.message = message
        self.timestamp = timestamp
    }
}
