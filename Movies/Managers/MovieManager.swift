//
//  MovieManager.swift
//  Movies
//
//  Created by Türker Kızılcık on 16.05.2024.
//

import Foundation

class MovieManager {
    static let shared = MovieManager()

    private init() {}

    var movies: [Movie] = []

    func addMovie(_ movie: Movie) {
        movies.append(movie)
    }
    
    func getAllMovies() -> [Movie] {
        return movies
    }
}
