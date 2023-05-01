//
//  ComicDetailViewController.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 26/04/23.
//

import UIKit

class ComicDetailViewController: UIViewController {
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var pagesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var descriptionLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.isEditable = false
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self,
                         action: #selector(didTapAddToCart),
                         for: .touchUpInside)
        
        
        return button
    }()
    
    private var favoriteManager: Favoritable
    private var isFavorited: Bool = false
    
    private var comic: Comic
    
    init(comic: Comic, favoriteManager: Favoritable = FavoriteManager()) {
        self.comic = comic
        self.favoriteManager = favoriteManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isBeingDismissed {
            if let tab = self.presentingViewController as? TabBarViewController,
               let nav = tab.selectedViewController as? UINavigationController,
               let vc = nav.viewControllers.last as? HomeViewController {
                vc.loadData()
            }
        }
    }

    private func setupViews() {
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(buyButton)
        self.view.addSubview(priceLabel)
        self.view.addSubview(pagesLabel)
        self.view.addSubview(favoriteButton)
        
        let width = self.view.bounds.width / 2 - 16
        let height = width * 1.5
        
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.imageView.widthAnchor.constraint(equalToConstant: width),
            self.imageView.heightAnchor.constraint(equalToConstant: height),
            
            self.favoriteButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.favoriteButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            self.favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            
            self.titleLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.titleLabel.topAnchor.constraint(equalTo: self.favoriteButton.bottomAnchor, constant: 16),
            
            self.priceLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.priceLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 16),
            self.priceLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 24),
            
            self.pagesLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.pagesLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 16),
            self.pagesLabel.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 8),
            
            self.descriptionLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 8),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                        
            self.buyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.buyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.buyButton.heightAnchor.constraint(equalToConstant: 56),
            self.buyButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32),
            self.buyButton.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 16)
        ])
        
        self.loadData()
    }
    
    private func loadData() {
        self.imageView.loadRemoteImageFrom(urlString: comic.thumbnail?.thumbURL() ?? "")
        self.titleLabel.text = comic.title
        self.descriptionLabel.text = comic.description
        
        if let filteredPrices = comic.prices?.filter({
            ($0.type ?? "").localizedCaseInsensitiveContains("printPrice")
        }), let first = filteredPrices.first {
            self.priceLabel.text = "Price USD \(first.price ?? 0)"
            
            if first.price == 0 {
                self.disableBuyButton()
            }
        } else {
            self.disableBuyButton()
        }
        
        self.pagesLabel.text = "\(comic.pageCount ?? 0) pages"
        
        self.isFavorited = self.favoriteManager
            .listFavorite()
            .contains(where: {
                $0.id == (self.comic.id ?? 0)
            })
        
        self.favoriteButton.setImage(isFavorited
                                     ? UIImage(named: "favoriteOn")
                                     : UIImage(named: "favoriteOff"),
                                     for: .normal)
    }
    
    private func disableBuyButton() {
        self.buyButton.backgroundColor = UIColor.lightGray
        self.buyButton.isUserInteractionEnabled = false
    }

    @objc func didTapFavoriteButton(_ sender: UIButton) {
        if isFavorited {
            self.favoriteManager.removeFavorite(id: self.comic.id ?? 0)
            self.isFavorited = false
            self.favoriteButton.setImage(UIImage(named: "favoriteOff"), for: .normal)
        } else {
            self.favoriteManager.addFavorite(comic: [self.comic])
            self.isFavorited = true
            self.favoriteButton.setImage(UIImage(named: "favoriteOn"), for: .normal)
        }
    }
    
    @objc func didTapAddToCart() {
        CartManager.shared.addToCart(comic: self.comic)
        self.dismiss(animated: true)
    }
}
