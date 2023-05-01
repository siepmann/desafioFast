//
//  CartDatasource.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 01/05/23.
//

import UIKit

class CartDataSource: NSObject, UITableViewDataSource {
    var resume: [CartResume]
    var delegate: CartPresentable
    
    init(resume: [CartResume], delegate: CartPresentable) {
        self.resume = resume
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resume.count == 0 {
            tableView.setEmptyView(type: .cart)
        } else {
            tableView.restore()
        }
        
        return resume.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "resumeCell", for: indexPath) as? CartResumeTableViewCell {
            cell.setupCell(resume: resume[indexPath.row],
                           delegate: delegate)
                       
            return cell
        }
        return UITableViewCell()
    }
}
