//
//  TabBarController.swift
//  Movies
//
//  Created by Türker Kızılcık on 2.05.2024.
//

import UIKit

class TabBarController: UITabBarController, DataDelegate, UITableViewDelegate {
    private var recievedData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    private func setupTabBar() {
        let firstVC = ListVC()
        let firstNavigationController = UINavigationController(rootViewController: firstVC)
        firstVC.title = "Movies"
        firstVC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "list.bullet.clipboard"), tag: 0)

        let secondVC = BookmarksVC()
        let secondNavigationController = UINavigationController(rootViewController: secondVC)
        secondVC.title = "Bookmarks"
        secondVC.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), tag: 1)

        self.viewControllers = [firstNavigationController, secondNavigationController]
    }

    func didFetchMovies(data: Data) {
        recievedData = data
        decodeAndAddMovies(data: data)
    }

    private func decodeAndAddMovies(data: Data) {
        do {
            struct Response: Codable {
                let results: [Movie]
            }

            let response = try JSONDecoder().decode(Response.self, from: data)
            let movies = response.results
            for movie in movies {
                MovieManager.shared.addMovie(movie)
            }
        } catch {
            print("JSON çevrimi başarısız: \(error.localizedDescription)")
        }
    }
}
