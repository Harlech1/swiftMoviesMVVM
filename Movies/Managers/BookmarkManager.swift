//
//  BookmarkManager.swift
//  Movies
//
//  Created by Türker Kızılcık on 18.05.2024.
//

import Foundation

struct MovieBookmark: Codable {
    let title: String
}

class BookmarkManager {
    static let shared = BookmarkManager()

    private init() {
        loadBookmarkedMovies()
    }

    var bookmarkedMovies: [MovieBookmark] = []

    func getBookmarkedMovies() -> [MovieBookmark] {
        return bookmarkedMovies
    }

    func bookmarkMovie(title: String) {
        let newBookmark = MovieBookmark(title: title)
        bookmarkedMovies.append(newBookmark)
    }

    func unBookmarkMovie(title: String) {
        if let index = bookmarkedMovies.firstIndex(where: { $0.title == title }) {
            bookmarkedMovies.remove(at: index)
        }
    }

    func isMovieBookmarked(title: String) -> Bool {
        return bookmarkedMovies.contains(where: { $0.title == title })
    }

    func saveBookmarkedMovies() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(bookmarkedMovies) {
            UserDefaults.standard.set(encodedData, forKey: "bookmarkedMovies")
        }
    }

    func loadBookmarkedMovies() {
        if let bookmarkedData = UserDefaults.standard.data(forKey: "bookmarkedMovies") {
            let decoder = JSONDecoder()
            if let decodedMovies = try? decoder.decode([MovieBookmark].self, from: bookmarkedData) {
                bookmarkedMovies = decodedMovies
            }
        }
    }
}

