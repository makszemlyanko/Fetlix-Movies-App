//
//  MainTabBarViewController.swift
//  NetflixClone
//
//  Created by Maks Kokos on 29.10.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers([
            setupController(viewController: HomeViewController(), image: UIImage(systemName: "house"), title: "Home"),
            setupController(viewController: UpcomingViewController(), image: UIImage(systemName: "play.circle"), title: "Coming Soon"),
            setupController(viewController: SearchViewController(), image: UIImage(systemName: "magnifyingglass"), title: "Top Search"),
            setupController(viewController: DownloadsViewController(), image: UIImage(systemName: "arrow.down.to.line"), title: "Downloads")
        ], animated: true)

        tabBar.tintColor = .systemRed
    }
    
    private func setupController(viewController: UIViewController, image: UIImage?, title: String) -> UIViewController {
        let vc = UINavigationController(rootViewController: viewController)
        vc.tabBarItem.image = image
        vc.title = title
        return vc
    }
}
