//  UserModel.swift
//  flicks_app
//
//  Created by Av on 3/2/25.
//  Version 1.0 - Initial implementation for clean architecture.
//  This file defines the UserModel within the Domain layer, representing user data for the Flicks! app.
//  It is designed as a Codable entity to support serialization and deserialization.
//  Future versions may add additional fields like preferences or friend lists, requiring model updates and tests.
//
import Foundation

struct UserModel: Codable, Equatable {
    let id: String
    let name: String
    let username: String
    let bio: String?
    let musicService: String?
    
    init(id: String, name: String, username: String, bio: String? = nil, musicService: String? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.bio = bio
        self.musicService = musicService
    }
}
