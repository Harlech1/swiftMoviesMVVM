//
//  ViewController.swift
//  Movies
//
//  Created by Türker Kızılcık on 1.05.2024.
//

import UIKit
import Kingfisher

class ListVC: UIViewController, UITableViewDelegate {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        return tableView
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Movies"
        return searchController
    }()

    private let movies = MovieManager.shared.getAllMovies()
    private let filters: [Genre] = Genre.allCases
    private lazy var filteredMovies: [Movie] = movies

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        addSubviews()
        setupFilterButton()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupFilterButton() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showPopup))
        navigationItem.rightBarButtonItem = filterButton
    }

    @objc private func showPopup() {
//        let popupView = FilterView(frame: CGRect(x: 50, y: 100, width: view.frame.width - 100, height: view.frame.height - 200))
//        view.addSubview(popupView)
    }

    private func filterMovies(with searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}

extension ListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return MovieCell() }

        let movie = filteredMovies[indexPath.row]
        cell.configure(movie: movie)

        let isBookmarked = cell.isBookmarked

        cell.bookmarkAction = {
            if isBookmarked {
                BookmarkManager.shared.unBookmarkMovie(title: movie.title)
            } else {
                BookmarkManager.shared.bookmarkMovie(title: movie.title)
            }
            BookmarkManager.shared.saveBookmarkedMovies()
            tableView.reloadData()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailsVC()
        detailVC.selectedMovie = filteredMovies[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMovies(with: searchText)
    }
}

extension ListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filterMovies(with: searchText)
    }
}

