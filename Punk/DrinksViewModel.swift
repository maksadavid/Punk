//
//  DrinksViewModel.swift
//  Punk
//
//  Created by David Maksa on 27.06.22.
//

import Foundation

@MainActor
class DrinksViewModel {
    
    enum TableViewItem: Equatable {
        case beer(Beer)
        case loadingItem
        case noResultsItem
    }
    
    private let punkService: PunkService
    private let pageSize = 20
    private var currentPage = 0
    private var isFetchingBeers = false
    private (set) var tableViewItems = [TableViewItem.loadingItem]
    var onUpdate: (()->())?
    
    init(punkService: PunkService) {
        self.punkService = punkService
    }
    
    func fetchMoreBeers() {
        guard !isFetchingBeers else { return }
        isFetchingBeers = true
        Task {
            do {
                let beers = try await punkService.fetchBeers(page: currentPage, pageSize: pageSize)
                tableViewItems = tableViewItems.filter { $0 != .loadingItem }
                tableViewItems.append(contentsOf: beers.map { TableViewItem.beer($0) })
                handleBeerFetchingSuccess(canFetchMore: beers.count >= pageSize)
            } catch let error {
                handleBeerFetchingError(error)
            }
        }
    }
    
    func refreshBeers() {
        guard !isFetchingBeers else { return }
        isFetchingBeers = true
        Task {
            do {
                currentPage = 0
                let beers = try await punkService.fetchBeers(page: currentPage, pageSize: pageSize)
                tableViewItems = beers.map { TableViewItem.beer($0) }
                handleBeerFetchingSuccess(canFetchMore: beers.count >= pageSize)
            } catch let error {
                handleBeerFetchingError(error)
            }
        }
    }
}

// MARK: - Private

extension DrinksViewModel {
    
    func handleBeerFetchingSuccess(canFetchMore: Bool) {
        if canFetchMore {
            tableViewItems.append(.loadingItem)
        }
        currentPage += 1
        isFetchingBeers = false
        onUpdate?()
    }
    
    func handleBeerFetchingError(_ error: Error) {
        if tableViewItems.count == 1 && tableViewItems.first == .loadingItem {
            tableViewItems = [.noResultsItem]
        }
        isFetchingBeers = false
        print("Failed to fetch beers. \(error.localizedDescription)")
        onUpdate?()
    }
    
}
