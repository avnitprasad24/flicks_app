//
//  MusicDTO.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//


//  MusicDTO.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial implementation for clean architecture.

import Foundation

struct MusicDTO: Codable {
    let id: String
    let title: String
    let artist: String
    let url: URL
    let duration: Int? // Duration in seconds, optional for API variability
    
    init(id: String, title: String, artist: String, url: URL, duration: Int? = nil) {
        self.id = id
        self.title = title
        self.artist = artist
        self.url = url
        self.duration = duration
    }
}

struct PostDTO: Codable {
    let id: String
    let userId: String
    let url: URL
    let likes: Int
    let caption: String?
    let uploadedAt: Date
    
    init(id: String, userId: String, url: URL, likes: Int, caption: String? = nil, uploadedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.url = url
        self.likes = likes
        self.caption = caption
        self.uploadedAt = uploadedAt
    }
}

struct UserDTO: Codable {
    let id: String
    let name: String
    let username: String
    let bio: String?
    let musicService: String? // "appleMusic" or "spotify"
    let friendCount: Int?
    
    init(id: String, name: String, username: String, bio: String? = nil, musicService: String? = nil, friendCount: Int? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.bio = bio
        self.musicService = musicService
        self.friendCount = friendCount
    }
}
