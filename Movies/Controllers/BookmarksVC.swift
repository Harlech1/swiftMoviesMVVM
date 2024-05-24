//
//  SecondVC.swift
//  Movies
//
//  Created by Türker Kızılcık on 2.05.2024.
//

import UIKit

class BookmarksVC: UIViewController, UITableViewDataSource {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var bookmarkedMovies = BookmarkManager.shared.getBookmarkedMovies()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true

        addSubviews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        bookmarkedMovies = BookmarkManager.shared.getBookmarkedMovies()
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension BookmarksVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = bookmarkedMovies[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedMovie = bookmarkedMovies.remove(at: indexPath.row)
            BookmarkManager.shared.unBookmarkMovie(title: removedMovie.title)
            BookmarkManager.shared.saveBookmarkedMovies()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
