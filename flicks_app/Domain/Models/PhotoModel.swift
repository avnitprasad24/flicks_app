//  PhotoModel.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial implementation for clean architecture.

import Foundation

struct PhotoModel: Codable, Equatable {
    let id: String
    let userId: String
    let url: URL
    let likes: Int
    
    init(id: String, userId: String, url: URL, likes: Int = 0) {
        self.id = id
        self.userId = userId
        self.url = url
        self.likes = likes
    }
}
