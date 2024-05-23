//
//  SplashVC.swift
//  Movies
//
//  Created by Türker Kızılcık on 2.05.2024.
//

import UIKit

protocol DataDelegate: AnyObject{
    func didFetchMovies(data: Data)
}

class SplashVC: UIViewController {

    var delegate: DataDelegate?

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

    lazy var tryAgainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Try Again", for: .normal)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(fetchData), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemGroupedBackground

        self.delegate = TabBarController()

        addSubviews()
        setupConstraints()
        fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func addSubviews() {
        view.addSubview(containerView)
        containerView.addArrangedSubview(moviesImage)
        containerView.addArrangedSubview(loadingLabel)
        containerView.addArrangedSubview(tryAgainButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            containerView.widthAnchor.constraint(equalToConstant: 100),
            containerView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }

    @objc private func fetchData() {
        NetworkManager.shared.fetchDataFromAPI { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.delegate?.didFetchMovies(data: data)
                    self.navigateToTabBar()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }

    private func navigateToTabBar() {
        let tabVC = TabBarController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabVC
            window.makeKeyAndVisible()
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
