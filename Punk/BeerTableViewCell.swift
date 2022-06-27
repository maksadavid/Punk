//
//  BeerTableViewCell.swift
//  Punk
//
//  Created by David Maksa on 27.06.22.
//

import UIKit
import Kingfisher

class BeerTableViewCell: UITableViewCell {
    
    static let reuseId = "BeerTableViewCell"
    
    private let beerImageView = UIImageView()
    private let nameLabel = UILabel()
    private let taglineLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with beer: Beer) {
        if let url = URL(string: beer.imageUrl) {
            beerImageView.kf.setImage(
                with: url,
            options: [
                .transition(.fade(0.25))
            ])
        }
        nameLabel.text = beer.name
        taglineLabel.text = beer.tagline
        descriptionLabel.text = beer.description
    }

}

// MARK: - Private

private extension BeerTableViewCell {
    
    func setupViews() {
        beerImageView.contentMode = .scaleAspectFit
        beerImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(beerImageView)
        NSLayoutConstraint.activate([
            beerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            beerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            beerImageView.heightAnchor.constraint(equalToConstant: 160),
            beerImageView.widthAnchor.constraint(equalToConstant: 120),
            contentView.bottomAnchor.constraint(
                greaterThanOrEqualTo: beerImageView.bottomAnchor,
                constant: 12
            )
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: beerImageView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: beerImageView.trailingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 12),
            contentView.bottomAnchor.constraint(
                greaterThanOrEqualTo: stackView.bottomAnchor,
                constant: 12
            )
        ])
        
        nameLabel.textColor = UIColor.darkGray
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.numberOfLines = 0
        stackView.addArrangedSubview(nameLabel)
        
        taglineLabel.textColor = UIColor.black
        taglineLabel.font = UIFont.systemFont(ofSize: 14)
        taglineLabel.numberOfLines = 0
        stackView.addArrangedSubview(taglineLabel)
        
        descriptionLabel.textColor = UIColor.lightGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        stackView.addArrangedSubview(descriptionLabel)
        stackView.axis = .vertical
        stackView.spacing = 8        
    }
    
}
