//
//  UICollectionView.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 30/04/23.
//

import Foundation
import UIKit

extension UICollectionView {
    func setLoadingState() {
        let view = UIView()
        view.backgroundColor = .clear
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .darkGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 64),
            indicator.widthAnchor.constraint(equalToConstant: 64)
        ])
        
        self.backgroundView = view
    }
    
    func setEmptyState() {
        let view = UIView()
        view.backgroundColor = .clear
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "home")
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.text = "No comics found"
        
        view.addSubview(image)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 64),
            image.widthAnchor.constraint(equalToConstant: 64),
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16)
        ])
        
        self.backgroundView = view
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
