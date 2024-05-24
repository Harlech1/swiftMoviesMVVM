//
//  FilterVC.swift
//  Movies
//
//  Created by Türker Kızılcık on 23.05.2024.
//

import UIKit

class FilterVC: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let switchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()

    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    weak var delegate: FilterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Filter"

        addSubviews()
        setupStackView()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(switchStackView)
        scrollView.addSubview(saveButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            switchStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            switchStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            switchStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            switchStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -80),
            switchStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            saveButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }

    private func setupStackView() {
        let genresArray = Genre.allCases.map { $0.description }
        addLabelSwitchViews(with: genresArray)
    }

    private func addLabelSwitchViews(with titles: [String]) {
        for title in titles {
            let labelSwitchView = LabelSwitchView(title: title)
            switchStackView.addArrangedSubview(labelSwitchView)
        }
    }

    func getActivatedSwitchesInfo() -> [String] {
        var activatedSwitchesInfo: [String] = []

        for case let switchView as LabelSwitchView in switchStackView.arrangedSubviews {
            if switchView.toggleSwitch.isOn {
                activatedSwitchesInfo.append(switchView.titleLabel.text ?? "")
            }
        }

        return activatedSwitchesInfo
    }

    private func notifyDelegate() {
        var selectedGenres: [String] = []
        selectedGenres = getActivatedSwitchesInfo()
        delegate?.didSelectGenres(selectedGenres)
    }

    @objc func saveButtonTapped() {
        notifyDelegate()
        navigationController?.popViewController(animated: true)
    }
}

class LabelSwitchView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let toggleSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()

    init(title: String) {
        super.init(frame: .zero)
        setupView(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(title: String) {
        addSubview(titleLabel)
        addSubview(toggleSwitch)

        titleLabel.text = title

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.trailingAnchor.constraint(equalTo: toggleSwitch.leadingAnchor, constant: -16)
        ])
    }
}
