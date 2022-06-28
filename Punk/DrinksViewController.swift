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
    private let errorLabel = UILabel()
    private var errorDismissTimer: Timer?

    init(viewModel: DrinksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    deinit {
        errorDismissTimer?.invalidate()
    }
    
    @objc func refreshBeers() {
        viewModel.refreshBeers()
    }
    
    func showErrorMessage() {
        guard errorDismissTimer == nil else {
            scheduleErrorDismissal() // delay error dismissal
            return
        }
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut) { [weak self] in
                self?.errorLabel.transform = CGAffineTransform(translationX: 0, y: -60)
            } completion: { [weak self] _ in
                self?.scheduleErrorDismissal()
            }
    }
    
    func scheduleErrorDismissal() {
        errorDismissTimer?.invalidate()
        errorDismissTimer = Timer.scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(self.dismissErrorMessage),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc func dismissErrorMessage() {
        errorDismissTimer = nil
        errorLabel.transform = .identity
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

// MARK: - Private

private extension DrinksViewController {
    
    func setupViews() {
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
        
        errorLabel.text = "Something went wrong";
        errorLabel.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
        errorLabel.textColor = UIColor.darkGray
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.layer.cornerRadius = 10
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            errorLabel.heightAnchor.constraint(equalToConstant: 32),
            errorLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 32)
        ])

        viewModel.onUpdate = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
            self?.showErrorMessage()
        }
    }
}
