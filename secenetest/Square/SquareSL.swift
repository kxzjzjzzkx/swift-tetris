//
//  SquareSL.swift
//  secenetest
//
//  Created by  孔尚杰 on 2023/3/2.
//

import Foundation

class SquareSL : MutiSquareEntity{
    static let array: [[Int]] = [
        [
            1,1,0,0,
            1,0,0,0,
            1,0,0,0,
            0,0,0,0
        ],
        [
            1,0,0,0,
            1,1,1,0,
            0,0,0,0,
            0,0,0,0
        ],
        [
            0,1,0,0,
            0,1,0,0,
            1,1,0,0,
            0,0,0,0
        ],
        [
            1,1,1,0,
            0,0,1,0,
            0,0,0,0,
            0,0,0,0
        ]
        
    ]
    
    static let imagesName: String = "resources/pure_5"
}
