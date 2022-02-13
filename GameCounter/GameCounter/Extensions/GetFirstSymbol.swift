//
//  GetFirstSymbol.swift
//  GameCounter
//
//  Created by Mikita Shalima on 31.08.21.
//

import Foundation

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
