//
//  CartManager.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 29/04/23.
//

import Foundation

struct CartResume {
    let id: Int
    let comicName: String
    let price: Double
    let quantity: Int
    let comicThumb: String
}

class CartManager {
    private(set) var comics: [Comic] = []
    private(set) var cartTotal: Double = 0
    
    static let shared = CartManager()
    
    private init() { }
    
    func addToCart(comic: Comic) {
        self.comics.append(comic)
        self.cartTotal += comic.prices?.first(where: {
            $0.type == "printPrice"
        })?.price ?? 0
    }
    
    func removeFromCart(comic: Comic) {
        let deletedIndex = self.comics.firstIndex(where: { $0.id == comic.id ?? 0 }) ?? -1
        
        if deletedIndex >= 0 {
            self.comics.remove(at: deletedIndex)
            
            self.cartTotal -= comic.prices?.first(where: {
                $0.type == "printPrice"
            })?.price ?? 0
        }
    }
    
    func createCartResume() -> [CartResume] {
        let resume = self.comics.map { c in
            let price = c.prices?.first(where: {
                $0.type == "printPrice"
            })?.price ?? 0
            
            return CartResume(id: c.id ?? 0,
                              comicName: c.title ?? "",
                              price: price,
                              quantity: 1,
                              comicThumb: c.thumbnail?.thumbURL() ?? "")
        }
        
        return Dictionary(grouping: resume, by: \.id )
            .map { id, comic -> CartResume in
                let sumPrice = comic.lazy.map(\.price).reduce(0, +)
                let sumQtd = comic.lazy.map(\.quantity).reduce(0, +)
                let name = comic.lazy.first(where: { $0.id == id })?.comicName ?? ""
                let thumb = comic.lazy.first(where: { $0.id == id })?.comicThumb ?? ""
                
                return CartResume(id: id,
                                  comicName: name,
                                  price: sumPrice,
                                  quantity: sumQtd,
                                  comicThumb: thumb)
            }.sorted {
                $0.id < $1.id
            }
    }
    
    func emptyCart() {
        self.comics = []
        self.cartTotal = 0
    }
}
