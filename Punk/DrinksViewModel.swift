//
//  DrinksViewModel.swift
//  Punk
//
//  Created by David Maksa on 27.06.22.
//

import Foundation

class DrinksViewModel {
    
    enum TableViewItem {
        case beer(Beer)
        case loading
    }
    
    private let punkService: PunkService
    private var nextPage = 0
    
    var tableViewItems = [TableViewItem]()

    init(punkService: PunkService) {
        self.punkService = punkService
    }

    func fetchBeers() async throws {
        let beers = try await punkService.fetchBeers(page: nextPage)
        let items = beers.map { TableViewItem.beer($0) }
        tableViewItems.append(contentsOf: items)
    }
    
}
