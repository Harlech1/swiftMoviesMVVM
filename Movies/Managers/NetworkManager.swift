//
//  NetworkManager.swift
//  Movies
//
//  Created by Türker Kızılcık on 10.05.2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    func fetchDataFromAPI(completion: @escaping (Result<Data,Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=3bb875ed5e8718b4bac2281f900eabe9") else {
            completion(.failure(NSError(domain: "com.example", code: -1, userInfo: ["description": "Invalid API URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "com.example", code: -1, userInfo: ["description": "No data received"])))
                return
            }

            completion(.success(data))
        }.resume()
    }
}
