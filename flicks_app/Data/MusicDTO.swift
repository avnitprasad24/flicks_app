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
//  This file defines the MusicDTO within the Data layer, representing music data for the Flicks! app.
//  It is designed as a Codable DTO to map API responses to domain models.
//  Future versions may add playlist or artist fields, requiring DTO extensions and API updates.
//
import Foundation

struct MusicDTO: Codable {
    let id: String
    let title: String
    let artist: String
    let url: URL
    
    init(id: String, title: String, artist: String, url: URL) {
        self.id = id
        self.title = title
        self.artist = artist
        self.url = url
    }
}