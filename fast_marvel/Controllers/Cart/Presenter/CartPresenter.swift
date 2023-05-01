//
//  CartPresenter.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 29/04/23.
//

import Foundation

enum CartActionType {
    case add
    case remove
    case removeALl
}

protocol CartPresenterProtocol {
    func displayCartResume() -> [CartResume]
    func attachView(view: CartPresentable)
    
    func changeCart(comicId: Int, action: CartActionType)
}

protocol CartPresentable: NSObjectProtocol {
    func displayCart(resume: [CartResume])
    func changeCart(comicId: Int, action: CartActionType)
}

class CartPresenter: CartPresenterProtocol {
    private weak var view: CartPresentable?
    
    init() { }
    
    func attachView(view: CartPresentable) {
        self.view = view
    }
    
    func displayCartResume() -> [CartResume] {
        return CartManager.shared.createCartResume()
    }
    
    private func addItemToCart(comicId: Int) {
        if let comic = CartManager.shared.comics.first(where: { $0.id == comicId }) {
            CartManager.shared.addToCart(comic: comic)
        }
        self.view?.displayCart(resume: self.displayCartResume())
    }
    
    private func removeItemFromCart(comicId: Int) {
        if let comic = CartManager.shared.comics.first(where: { $0.id == comicId }) {
            CartManager.shared.removeFromCart(comic: comic)
        }
        
        self.view?.displayCart(resume: self.displayCartResume())
    }
    
    private func removeProductFromCart(comicId: Int) {
        CartManager.shared.comics.filter { $0.id == comicId }.forEach {
            CartManager.shared.removeFromCart(comic: $0)
        }

        self.view?.displayCart(resume: self.displayCartResume())
    }
    
    func changeCart(comicId: Int, action: CartActionType) {
        switch action {
        case .remove:
            self.removeItemFromCart(comicId: comicId)
        case .add:
            self.addItemToCart(comicId: comicId)
        case .removeALl:
            self.removeProductFromCart(comicId: comicId)
        }
    }
}
