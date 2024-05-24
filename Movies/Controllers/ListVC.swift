//
//  ViewController.swift
//  Movies
//
//  Created by Türker Kızılcık on 1.05.2024.
//

import UIKit
import Kingfisher

protocol FilterDelegate: AnyObject {
    func didSelectGenres(_ genres: [String])
}

class ListVC: UIViewController, UITableViewDelegate, FilterDelegate {

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
    private lazy var searchFilteredMovies: [Movie] = movies
    private lazy var genreFilteredMovies: [Movie] = movies

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
        let filterImage = UIImage(systemName: "line.horizontal.3.decrease.circle")
        let filterButton = UIBarButtonItem(image: filterImage, style: .plain, target: self, action: #selector(navigateToFilterVC))
        navigationItem.rightBarButtonItem = filterButton
    }

    @objc private func navigateToFilterVC() {
        let filterVC = FilterVC()
        filterVC.delegate = self
        navigationController?.pushViewController(filterVC, animated: true)
    }

    private func filterMovies(by genres: [String]) {
        if genres.isEmpty {
            genreFilteredMovies = movies
        } else {
            genreFilteredMovies = movies.filter { movie in
                let movieGenreIDs = movie.genre_ids
                let movieGenres = movieGenreIDs.compactMap { Genre(rawValue: $0)?.description }
                return !Set(movieGenres).isDisjoint(with: genres)
            }
        }
        filterMovies(with: searchController.searchBar.text ?? "")
    }


    private func filterMovies(with searchText: String) {
        if searchText.isEmpty {
            searchFilteredMovies = genreFilteredMovies
        } else {
            searchFilteredMovies = genreFilteredMovies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }


    func didSelectGenres(_ genres: [String]) {
        filterMovies(by: genres)
    }
}

extension ListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFilteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else { return MovieCell() }

        let movie = searchFilteredMovies[indexPath.row]
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
        return 354.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailsVC()
        detailVC.selectedMovie = searchFilteredMovies[indexPath.row]
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

