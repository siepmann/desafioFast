//
//  CartPresenter.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 29/04/23.
//

import Foundation

protocol CartPresenterProtocol {
    func displayCartResume() -> [CartResume]
    func removeFromCart(comic: Comic)
    func attachView(view: CartPresentable)
}

protocol CartPresentable: NSObjectProtocol {
    func displayCart(resume: [CartResume])
}

class CartPresenter: CartPresenterProtocol {
    private weak var view: CartPresentable?
    
    init() {
        
    }
    
    func attachView(view: CartPresentable) {
        self.view = view
    }
    
    func removeFromCart(comic: Comic) {
        CartManager.shared.removeFromCart(comic: comic)
        self.view?.displayCart(resume: self.displayCartResume())
    }
    
    func displayCartResume() -> [CartResume] {
        return CartManager.shared.createCartResume()
    }
}
