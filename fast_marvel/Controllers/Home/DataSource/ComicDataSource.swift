//
//  ComicDataSource.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 27/04/23.
//

import Foundation
import UIKit

class ComicDataSource: NSObject, UICollectionViewDataSource {
    // publico e mutável para poder atualizar os dados
    var comics: [Comic]
    var filteredComics: [Comic] = []
    var searchActive: Bool = false
    
    init(comics: [Comic]) {
        self.comics = comics
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = self.comics.count
        
        if self.searchActive {
            count = filteredComics.count
        }
        
        if count == 0 {
            collectionView.setEmptyState()
        } else {
            collectionView.restore()
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                         for: indexPath) as? ComicCollectionViewCell {
            var comic = self.comics[indexPath.row]
            
            if self.searchActive {
                comic = filteredComics[indexPath.row]
            }
            
            cell.setupCell(comic: comic)
            
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 4
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func filterComics(searchText: String) {
        if searchText == "" {
            self.filteredComics = comics
        } else {
            self.searchActive = true
            self.filteredComics = self.comics.filter {
                ($0.title ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "Footer",
                                                                         for: indexPath)
            
            if let footerIndicator = footer.subviews.first(where: {
                $0 is UIActivityIndicatorView
            }) as? UIActivityIndicatorView {
                if searchActive {
                    footerIndicator.stopAnimating()
                } else {
                    footerIndicator.startAnimating()
                }
            } else {
                let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
                footerView.color = .darkGray
                footerView.translatesAutoresizingMaskIntoConstraints = false
                
                if searchActive {
                    footerView.stopAnimating()
                } else {
                    footerView.startAnimating()
                }
                
                footer.addSubview(footerView)
                footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                footerView.widthAnchor.constraint(equalToConstant: collectionView.bounds.width).isActive = true
            }
            
            return footer
        }
        
        return UICollectionReusableView()
    }
}
