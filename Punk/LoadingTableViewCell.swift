//
//  LoadingTableViewCell.swift
//  Punk
//
//  Created by David Maksa on 28.06.22.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    
    static let reuseId = "LoadingTableViewCell"
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicatorView.stopAnimating()
    }
    
    func update() {
        activityIndicatorView.startAnimating()
    }
    
}

private extension LoadingTableViewCell {
    
    func setupViews() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicatorView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 30
            ),
            activityIndicatorView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -30
            ),
        ])

    }
}
