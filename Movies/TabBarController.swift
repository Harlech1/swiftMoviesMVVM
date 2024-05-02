//
//  TabBarController.swift
//  Movies
//
//  Created by Türker Kızılcık on 2.05.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    private func setupTabBar() {
        let firstVC = FirstVC()
        firstVC.title = "First"
        firstVC.tabBarItem.image = UIImage(systemName: "heart")

        let secondVC = SecondVC()
        secondVC.title = "Second"
        secondVC.tabBarItem.image = UIImage(systemName: "heart")

        self.viewControllers = [firstVC, secondVC]
    }

}
