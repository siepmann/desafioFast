//
//  FavoriteTableViewCell.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 27/04/23.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    private lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var comicThumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.label.text = ""
        self.comicThumbImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(comic: Comic) {
        self.contentView.addSubview(self.backView)
        self.backView.addSubview(self.label)
        self.backView.addSubview(self.comicThumbImageView)
        
        comicThumbImageView.layer.cornerRadius = 20
        comicThumbImageView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            self.backView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.backView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.backView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.backView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            self.comicThumbImageView.heightAnchor.constraint(equalToConstant: 90),
            self.comicThumbImageView.widthAnchor.constraint(equalToConstant: 60),
            self.comicThumbImageView.leadingAnchor.constraint(equalTo: self.backView.leadingAnchor, constant: 8),
            self.comicThumbImageView.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 2),
            self.comicThumbImageView.bottomAnchor.constraint(equalTo: self.backView.bottomAnchor, constant: -2),
            
            self.label.leadingAnchor.constraint(equalTo: self.comicThumbImageView.trailingAnchor, constant: 8),
            self.label.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor, constant: -8),
            self.label.centerYAnchor.constraint(equalTo: self.comicThumbImageView.centerYAnchor)
        ])
        
        self.contentView.backgroundColor = .red
        self.backView.backgroundColor = .white
        self.label.text = comic.title ?? ""
        self.comicThumbImageView.loadRemoteImageFrom(urlString: comic.thumbnail?.thumbURL() ?? "")
    }
    
    func animate() {
        self.slideLeft()
    }
    
    private func slideLeft() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.3,
                       options: [.curveEaseOut], animations: {
            self.backView.transform = CGAffineTransform(translationX: -30, y: 0)
            self.backView.layer.cornerRadius = 10
        }) { success in
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: [.curveEaseOut]) {
                self.backView.transform = .identity
                self.backView.layer.cornerRadius = 0
            }
        }
    }
}
