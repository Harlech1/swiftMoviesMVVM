//
//  DetailsVC.swift
//  Movies
//
//  Created by Türker Kızılcık on 17.05.2024.
//

import UIKit

class DetailsVC: UIViewController {

//    genişlik/boy
//    500x750 poster
//    500x281 backdrop

    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    let adultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    let originalLangLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let userScoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.alpha = 0.3
        return imageView
    }()

    let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    var selectedMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemGroupedBackground

        title = "Details"

        addSubviews()
        setupConstraints()
        setupPosterImage()
        setupTitleLabel()
        setupAdultLabel()
        setupGenresLabel()
        setupOriginalLangLabel()
        setupOriginalTitleLabel()
        setupReleaseDateLabel()
        setupUserScoreLabel()
        setupOverviewLabel()
        setupBackdropImageView()
    }

    private func addSubviews() {
        view.addSubview(posterImageView)
        view.addSubview(titleLabel)
        view.addSubview(stackView)

        stackView.addArrangedSubview(adultLabel)
        stackView.addArrangedSubview(genresLabel)
        stackView.addArrangedSubview(originalLangLabel)
        stackView.addArrangedSubview(originalTitleLabel)
        stackView.addArrangedSubview(releaseDateLabel)
        stackView.addArrangedSubview(userScoreLabel)

        view.addSubview(backdropImageView)
        view.addSubview(overviewLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 150),
            posterImageView.heightAnchor.constraint(equalToConstant: 225),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),

            backdropImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            backdropImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backdropImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            backdropImageView.heightAnchor.constraint(equalToConstant: 200),

            overviewLabel.topAnchor.constraint(equalTo: backdropImageView.topAnchor),
            overviewLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor)
        ])
    }

    private func roundNumber(_ number: Double) -> Int {
        return Int((number * 10).rounded())
    }

    private func setupPosterImage() {
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(selectedMovie?.poster_path ?? "/gKkl37BQuKTanygYQG1pyYgLVgf.jpg")")
        posterImageView.kf.setImage(with: posterURL)
    }

    private func setupTitleLabel() {
        titleLabel.text = selectedMovie?.title
    }

    private func setupAdultLabel() {
        adultLabel.text = "Adults Only: \(selectedMovie?.adult ?? false ? "✅" : "❌")"
    }

    private func setupGenresLabel() {
        var genresDescription = ""
        if let genreIds = selectedMovie?.genre_ids {
            let genres = genreIds.map { genreID -> String in
                if let genre = Genre(rawValue: genreID) {
                    return genre.description
                } else {
                    return "Unknown Genre"
                }
            }
            genresDescription = genres.joined(separator: ", ")
        } else {
            genresDescription = "No Genres"
        }
        genresLabel.text = "Genres: \(genresDescription)"
    }

    private func setupOriginalLangLabel() {
        let langCode = LanguageFlag(rawValue: selectedMovie?.original_language ?? "unknown") ?? .unknown
        originalLangLabel.text = "Original Language: \(langCode.flagEmoji)"
    }

    private func setupOriginalTitleLabel() {
        originalTitleLabel.text = "Original Title: \(selectedMovie?.original_title ?? "unknown")"
    }

    private func setupReleaseDateLabel() {
        releaseDateLabel.text = "Release Date: \(selectedMovie?.release_date ?? "unknown")"
    }

    private func setupUserScoreLabel() {
        let userScore = roundNumber(selectedMovie?.vote_average ?? 0)
        userScoreLabel.text = "User Score: %\(userScore)"
    }

    private func setupOverviewLabel() {
        let overviewText = "Overview: \(selectedMovie?.overview ?? "unknown")"
        let overviewText1 = """
        Overview:
        \(selectedMovie?.overview ?? "unknown")
        """
        overviewLabel.text = overviewText1
    }

    private func setupBackdropImageView() {
        let backdropURL = URL(string: "https://image.tmdb.org/t/p/w500\(selectedMovie?.backdrop_path ?? "")")
        backdropImageView.kf.setImage(with: backdropURL)
    }
}
