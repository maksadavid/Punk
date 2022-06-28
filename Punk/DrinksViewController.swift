//
//  ViewController.swift
//  Punk
//
//  Created by David Maksa on 27.06.22.
//

import UIKit

class DrinksViewController: UIViewController {
    
    private let viewModel: DrinksViewModel
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: DrinksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: BeerTableViewCell.reuseId)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.reuseId)
        tableView.register(NoResultsTableViewCell.self, forCellReuseIdentifier: NoResultsTableViewCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        refreshControl.addTarget(self, action: #selector(refreshBeers), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        viewModel.onUpdate = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    @objc func refreshBeers() {
        viewModel.refreshBeers()
    }
    
}

// MARK: - UITableViewDataSource

extension DrinksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableViewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.tableViewItems[indexPath.item]
        switch item {
        case let .beer(beer):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: BeerTableViewCell.reuseId,
                for: indexPath
            ) as? BeerTableViewCell else {
                return UITableViewCell()
            }
            cell.update(with: beer)
            return cell
        case .loadingItem:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: LoadingTableViewCell.reuseId,
                for: indexPath
            ) as? LoadingTableViewCell else {
                return UITableViewCell()
            }
            cell.update()
            return cell
        case .noResultsItem:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NoResultsTableViewCell.reuseId,
                for: indexPath
            ) as? NoResultsTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
}

// MARK: - UITableViewDelegate

extension DrinksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.tableViewItems[indexPath.item] == .loadingItem {
            viewModel.fetchMoreBeers()
        }
    }
}
