//
//  ComicCollectionViewCell.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 24/04/23.
//

import Foundation
import UIKit

class ComicCollectionViewCell: UICollectionViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(didTapFavoriteButton(_:)),
                         for: .touchUpInside)
        
        return button
    }()
    
    private lazy var favoriteManager: FavoriteManager = FavoriteManager()
    
    private var comic: Comic?
    private var isFavorited: Bool = false
    
    override func prepareForReuse() {
        label.text = ""
        imageView.image = nil
    }
    
    func setupCell(comic: Comic) {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(favoriteButton)
        self.contentView.addSubview(label)
        
        self.comic = comic
        
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.label.topAnchor, constant: -2),
            
            self.favoriteButton.widthAnchor.constraint(equalToConstant: 26),
            self.favoriteButton.heightAnchor.constraint(equalToConstant: 26),
            self.favoriteButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4),
            self.favoriteButton.centerYAnchor.constraint(equalTo: self.label.centerYAnchor),
            
            self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4),
            self.label.trailingAnchor.constraint(equalTo: self.favoriteButton.leadingAnchor, constant: -4),
            self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
            self.label.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.label.textAlignment = .center
        self.label.text = comic.title
        
        self.isFavorited = self.favoriteManager
            .listFavorite()
            .contains(where: {
                $0.id == (self.comic?.id ?? 0)
            })
        
        self.favoriteButton.setImage(isFavorited
                                     ? UIImage(named: "favoriteOn")
                                     : UIImage(named: "favoriteOff"),
                                     for: .normal)
        
        DispatchQueue.main.async {
            self.imageView.loadRemoteImageFrom(urlString: comic.thumbnail?.thumbURL() ?? "")
        }
    }
    
    @objc func didTapFavoriteButton(_ sender: UIButton) {
        if isFavorited {
            self.favoriteManager.removeFavorite(id: self.comic?.id ?? 0)
            self.isFavorited = false
            self.favoriteButton.setImage(UIImage(named: "favoriteOff"), for: .normal)
        } else if let comic = self.comic {
            self.favoriteManager.addFavorite(comic: [comic])
            self.isFavorited = true
            self.favoriteButton.setImage(UIImage(named: "favoriteOn"), for: .normal)
        }
    }
}
