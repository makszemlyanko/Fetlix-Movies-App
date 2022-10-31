//
//  Movie.swift
//  NetflixClone
//
//  Created by Maks Kokos on 30.10.2022.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let media_type: String?
    let title: String?
    let original_title: String?
    let name: String?
    let original_name: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let vote_average: Double
    let release_date: String?
}

