//
//  CartResumeTableViewCell.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 29/04/23.
//

import UIKit

class CartResumeTableViewCell: UITableViewCell {
    private lazy var comicTitleLabel: UILabel = {
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
        imageView.layer.cornerRadius = 26
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var removeFromCart: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        
        button.setImage(UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.addTarget(self,
                                 action: #selector(removeProductFromCart),
                                 for: .touchUpInside)
        
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self,
                         action: #selector(addItemToCart),
                         for: .touchUpInside)
        
        return button
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(removeItemFromCart),
                         for: .touchUpInside)
        
        button.setImage(UIImage(named: "remove"), for: .normal)
        return button
    }()
    
    private lazy var comicCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private var resume: CartResume!
    private weak var delegate: CartPresentable?
    
    func setupCell(resume: CartResume, delegate: CartPresentable) {
        self.resume = resume
        self.delegate = delegate
        
        self.contentView.addSubview(comicTitleLabel)
        self.contentView.addSubview(comicThumbImageView)
        self.contentView.addSubview(totalPriceLabel)
        
        self.contentView.addSubview(removeFromCart)
        self.contentView.addSubview(minusButton)
        self.contentView.addSubview(comicCountLabel)
        self.contentView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            self.comicThumbImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.comicThumbImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.comicThumbImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            self.comicThumbImageView.widthAnchor.constraint(equalToConstant: 80),
            self.comicThumbImageView.heightAnchor.constraint(equalToConstant: 120),
            
            self.comicTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.comicTitleLabel.leadingAnchor.constraint(equalTo: self.comicThumbImageView.trailingAnchor, constant: 8),
            
            self.removeFromCart.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.removeFromCart.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.removeFromCart.leadingAnchor.constraint(equalTo: self.comicTitleLabel.trailingAnchor, constant: 8),
            self.removeFromCart.widthAnchor.constraint(equalToConstant: 32),
            self.removeFromCart.heightAnchor.constraint(equalToConstant: 32),
            
            self.minusButton.leadingAnchor.constraint(equalTo: self.comicThumbImageView.trailingAnchor, constant: 8),
            self.minusButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            self.minusButton.widthAnchor.constraint(equalToConstant: 24),
            self.minusButton.heightAnchor.constraint(equalToConstant: 24),
            
            self.comicCountLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            self.comicCountLabel.leadingAnchor.constraint(equalTo: self.minusButton.trailingAnchor, constant: 8),
            self.comicCountLabel.heightAnchor.constraint(equalToConstant: 24),
            
            self.plusButton.leadingAnchor.constraint(equalTo: self.comicCountLabel.trailingAnchor, constant: 8),
            self.plusButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            self.plusButton.widthAnchor.constraint(equalToConstant: 24),
            self.plusButton.heightAnchor.constraint(equalToConstant: 24),
            
            self.totalPriceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.plusButton.trailingAnchor, constant: -16),
            self.totalPriceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            self.totalPriceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
        
        self.comicTitleLabel.text = resume.comicName
        self.comicThumbImageView.loadRemoteImageFrom(urlString: resume.comicThumb)
        
        self.comicCountLabel.text = "\(resume.quantity)"
        self.totalPriceLabel.text = "USD \(resume.price.toString())"
    }
    
    @objc func addItemToCart() {
        delegate?.changeCart(comicId: self.resume.id,
                             action: .add)
    }
    
    @objc func removeItemFromCart() {
        delegate?.changeCart(comicId: self.resume.id,
                             action: .remove)
    }
    
    @objc func removeProductFromCart() {
        delegate?.changeCart(comicId: self.resume.id,
                             action: .removeALl)

    }
}
