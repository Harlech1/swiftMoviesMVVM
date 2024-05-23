//
//  MovieCell.swift
//  Movies
//
//  Created by Türker Kızılcık on 16.05.2024.
//

import UIKit

class MovieCell: UITableViewCell {

    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    let movieBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.alpha = 0.5
        return imageView
    }()

    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        label.textAlignment = .center
        return label
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = UIColor.placeholderText
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()

    var bookmarkAction: (() -> Void)?

    var isBookmarked: Bool = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        contentView.addSubview(movieBackgroundImageView)
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(bookmarkButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            movieBackgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            movieBackgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            movieBackgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieBackgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            movieImageView.topAnchor.constraint(equalTo: movieBackgroundImageView.topAnchor, constant: 8),
            movieImageView.leadingAnchor.constraint(equalTo: movieBackgroundImageView.leadingAnchor, constant: 8),
            movieImageView.trailingAnchor.constraint(equalTo: movieBackgroundImageView.trailingAnchor, constant: -8),

            movieTitleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            movieTitleLabel.leadingAnchor.constraint(equalTo: movieBackgroundImageView.leadingAnchor, constant: 8),
            movieTitleLabel.trailingAnchor.constraint(equalTo: movieBackgroundImageView.trailingAnchor, constant: 8),
            movieTitleLabel.bottomAnchor.constraint(equalTo: movieBackgroundImageView.bottomAnchor, constant: -8),

            bookmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 50),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configure(movie: Movie) {
        isBookmarked = BookmarkManager.shared.isMovieBookmarked(title: movie.title)

        if isBookmarked {
            bookmarkButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            bookmarkButton.tintColor = .systemRed
        } else {
            bookmarkButton.setImage(UIImage(systemName: "heart"), for: .normal)
            bookmarkButton.tintColor = .placeholderText
        }
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)")
        let backdropURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.backdrop_path ?? "")")

        movieBackgroundImageView.kf.setImage(with: backdropURL)
        movieImageView.kf.setImage(with: posterURL)
        movieTitleLabel.text = movie.title
    }

    @objc private func bookmarkTapped() {
        bookmarkAction?()
    }
}
