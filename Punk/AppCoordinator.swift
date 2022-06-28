//
//  AppCoordinator.swift
//  Punk
//
//  Created by David Maksa on 27.06.22.
//

import UIKit

@MainActor
class AppCoordinator {
    
    private let punkService = PunkService()
    let rootViewController = UINavigationController()
    
    func start() {
        let viewModel = DrinksViewModel(punkService: punkService)
        rootViewController.viewControllers = [DrinksViewController(viewModel: viewModel)]
    }
}
