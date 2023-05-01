//
//  FavoritesDataSource.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 01/05/23.
//

import UIKit

class FavoritesDataSource: NSObject, UITableViewDataSource {
    private var comics = [Comic]()
    private var favoriteManager: Favoritable
    
    init(comics: [Comic] = [Comic](), favoriteManager: Favoritable) {
        self.comics = comics
        self.favoriteManager = favoriteManager
    }
    
    func getComic(index: Int) -> Comic? {
        if comics.count <= index {
            return nil
        }
        
        return comics[index]
    }
    
    func setComics(comics: [Comic]) {
        self.comics = comics
    }
    
    func count() -> Int {
        return self.comics.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comics.count == 0 {
            tableView.setEmptyView(type: .favorites)
        } else {
            tableView.restore()
        }
        
        return comics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteTableViewCell {
            cell.setupCell(comic: comics[indexPath.row])
            
            if indexPath.row == 0 && !UserDefaults.standard.bool(forKey: "animated") {
                UserDefaults.standard.set(true, forKey: "animated")
                cell.animate()
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteManager.removeFavorite(id: self.comics[indexPath.row].id ?? 0)
            self.comics = favoriteManager.listFavorite()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
