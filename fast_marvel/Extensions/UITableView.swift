//
//  UITableView.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 30/04/23.
//

import Foundation
import UIKit

extension UITableView {
    enum TebleViewType {
        case cart
        case favorites
        
        func getImage() -> UIImage? {
            switch self {
            case .cart:
                return UIImage(named: "cart")
            case .favorites:
                return UIImage(named: "favoriteOff")
            }
        }
        
        func getText() -> String {
            switch self {
            case .cart:
                return "Empty cart"
            case .favorites:
                return "No favorites found"
            }
        }
    }
    
    func setEmptyView(type: TebleViewType) {
        let view = UIView()
        view.backgroundColor = .clear
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = type.getImage()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.text = type.getText()
        
        view.addSubview(image)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 64),
            image.widthAnchor.constraint(equalToConstant: 64),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16)
        ])
        
        self.backgroundView = view
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
