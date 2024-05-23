//
//  Model.swift
//  Movies
//
//  Created by Türker Kızılcık on 2.05.2024.
//

import Foundation
struct Movie: Codable { // TODO: Variables should be in camel case, not this type
    let vote_average: Double
    let vote_count: Int
    let poster_path: String
    let video: Bool
    let original_title: String
    let backdrop_path: String?
    let overview: String
    let title: String
    let release_date: String
    let genre_ids: [Int]
    let adult: Bool
    let original_language: String
    let popularity: Double
    let id: Int
}
