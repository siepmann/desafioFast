//
//  TabBarViewController.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 26/04/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.layoutTabs()
        self.viewControllers = [
            self.createHome(),
            self.createFavorite(),
            self.createCart()
        ]
    }
    
    private func layoutTabs() {
        let appearance = UITabBarAppearance()
        
        appearance.backgroundColor = .white
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .white
        
        appearance.stackedLayoutAppearance.normal.iconColor = .darkGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        
        appearance.stackedLayoutAppearance.selected.iconColor = .blue.withAlphaComponent(0.5)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue.withAlphaComponent(0.5)]
        
        self.tabBar.standardAppearance = appearance
        
    }
    
    private func createHome() -> UINavigationController {
        let presenter = HomeViewControllerPresenter(service: ComicsService())
        let homeController = HomeViewController(presenter: presenter)
        
        presenter.attachView(comicsView: homeController)
        
        let tabBarItemHome = UITabBarItem(title: "Home",
                                          image: UIImage(named: "home"),
                                          selectedImage: nil)
        
        let homeNavigationController = UINavigationController(rootViewController: homeController)
        homeNavigationController.tabBarItem = tabBarItemHome
        
        return homeNavigationController
    }
    
    private func createFavorite() -> UINavigationController {
        let presenter = FavoritesPresenter(service: ComicsService())
        let favoriteViewController = FavoritesViewController(presenter: presenter)
        presenter.attachView(favoritesView: favoriteViewController)
        
        let tabBarItemFavorites = UITabBarItem(title: "Favorites",
                                               image: UIImage(named: "favoriteTab"),
                                               selectedImage: nil)
        
        let favoritesNavigationController = UINavigationController(rootViewController: favoriteViewController)
        favoritesNavigationController.tabBarItem = tabBarItemFavorites
        
        return favoritesNavigationController
    }
    
    private func createCart() -> UINavigationController {
        let presenter = CartPresenter()
        let controller = CartResumeViewController(presenter: presenter)
        
        presenter.attachView(view: controller)
        
        let tabBarItemCart = UITabBarItem(title: "Cart",
                                          image: UIImage(named: "cart"),
                                          selectedImage: nil)
        
        let cartNavigationController = UINavigationController(rootViewController: controller)
        cartNavigationController.tabBarItem = tabBarItemCart
        
        return cartNavigationController
    }
}
