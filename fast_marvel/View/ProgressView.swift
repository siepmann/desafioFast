//
//  ProgressView.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 01/05/23.
//

import UIKit

class ProgressView {
    static let shared = ProgressView()
    private let hudView: UIActivityIndicatorView!
    private var overlayView = UIView()
    
    private init () {
        hudView = UIActivityIndicatorView(style: .large)
        
        guard let topWindow = self.getTopWindow() else { return }
        overlayView.frame = topWindow.bounds
        
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        topWindow.addSubview(overlayView)
        
        hudView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        overlayView.addSubview(hudView)
        hudView.center = overlayView.center
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.hudView.stopAnimating()
            self.overlayView.removeFromSuperview()
        }
    }
    
    func show() {
        DispatchQueue.main.async {
            if let window = self.getTopWindow() {
                window.addSubview(self.overlayView)
                self.hudView.startAnimating()
            }
        }
    }
    
    private func getTopWindow() -> UIWindow? {
        return UIApplication.shared.windows.last
    }
}
