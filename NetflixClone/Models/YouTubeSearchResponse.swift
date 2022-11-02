//
//  YouTubeSearchResponse.swift
//  NetflixClone
//
//  Created by Maks Kokos on 02.11.2022.
//

import Foundation

struct YouTubeSearchResponse: Codable {
    let items: [Video]
}

struct Video: Codable {
    let id: VideoId
}

struct VideoId: Codable {
    let kind: String
    let videoId: String
}
