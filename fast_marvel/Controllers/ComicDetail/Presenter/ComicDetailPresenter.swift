//
//  ComicDetailPresenter.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 26/04/23.
//

import Foundation
import UIKit

struct ComicDetailPresenter {
    let comic: Comic
    
    func navigate(from viewController: UIViewController) {
        let controller = ComicDetailViewController(comic: comic)
        
        viewController.present(controller, animated: true)
    }
}
