//
//  UIImageView.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 25/04/23.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
let activityView = UIActivityIndicatorView(style: .medium)

extension UIImageView {
    func loadRemoteImageFrom(urlString: String){
        let url = URL(string: urlString)
        image = nil
        
        activityView.center = self.center
        self.addSubview(activityView)
        activityView.startAnimating()
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            activityView.stopAnimating()
            activityView.removeFromSuperview()
            return
        }
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            DispatchQueue.main.async {
                activityView.stopAnimating()
                activityView.removeFromSuperview()
            }
            if let response = data {
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: response) {
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                        self.image = imageToCache
                    }else{
                        self.loadRemoteImageFrom(urlString: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/330px-No-Image-Placeholder.svg.png")
                    }
                }
            }
        }.resume()
    }
}
