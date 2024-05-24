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
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
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
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 2.0
        label.layer.masksToBounds = false
        label.textAlignment = .center
        return label
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 1.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 15
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

            movieImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            movieImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 200),
            movieImageView.heightAnchor.constraint(equalToConstant: 300),

            movieTitleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 8),
            movieTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            movieTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            bookmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configure(movie: Movie) {
        isBookmarked = BookmarkManager.shared.isMovieBookmarked(title: movie.title)

        if isBookmarked {
            bookmarkButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            bookmarkButton.tintColor = .systemRed
        } else {
            bookmarkButton.setImage(UIImage(systemName: "heart"), for: .normal)
            bookmarkButton.tintColor = .white
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
