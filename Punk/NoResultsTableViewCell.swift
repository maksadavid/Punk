//
//  NoResultsTableViewCell.swift
//  Punk
//
//  Created by David Maksa on 28.06.22.
//

import UIKit

class NoResultsTableViewCell: UITableViewCell {
    
    static let reuseId = "NoResultsTableViewCell"
    private let noResultsTextLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private

private extension NoResultsTableViewCell {
    
    func setupViews() {
        noResultsTextLabel.text = NSLocalizedString("no_results", comment: "")
        noResultsTextLabel.textColor = UIColor.darkGray
        noResultsTextLabel.font = UIFont.systemFont(ofSize: 14)
        noResultsTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(noResultsTextLabel)
        NSLayoutConstraint.activate([
            noResultsTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            noResultsTextLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 30
            ),
            noResultsTextLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -30
            ),
        ])

    }
}
