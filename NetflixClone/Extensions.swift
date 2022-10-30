//
//  Extensions.swift
//  NetflixClone
//
//  Created by Maks Kokos on 30.10.2022.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
