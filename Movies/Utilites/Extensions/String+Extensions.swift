//
//  Extensions.swift
//  Movies
//
//  Created by aya on 17/09/2024.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
