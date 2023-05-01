//
//  Double.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 29/04/23.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func toString() -> String {
        return String(format: "%.02f", self.roundToDecimal(2))
    }
}
