//
//  Shuffle.swift
//  Pair
//
//  Created by Luis Puentes on 6/20/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffling() {
        for _ in 0..<10 {
            sort { (_,_) in arc4random() < arc4random()
            }
        }
    }
}
