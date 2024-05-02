//
//  SplashVC.swift
//  Movies
//
//  Created by Türker Kızılcık on 2.05.2024.
//

import UIKit

class SplashVC: UIViewController {

    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Loading..."
        return label
    }()

    private let moviesImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "movieclapper")
        image.tintColor = .red
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemGroupedBackground

        addSubviews()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIApplication.shared.windows.first?.rootViewController = TabBarController()
        }
    }

    private func addSubviews() {
        view.addSubview(containerView)
        containerView.addArrangedSubview(moviesImage)
        containerView.addArrangedSubview(loadingLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            containerView.widthAnchor.constraint(equalToConstant: 100),
            containerView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}
