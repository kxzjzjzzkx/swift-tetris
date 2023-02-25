//
//  MutiSquareEntity.swift
//  secenetest
//
//  Created by  孔尚杰 on 2023/2/25.
//

import Foundation
import SpriteKit

class MutiSquareEntity: SKSpriteNode {
    
    private var shapeArray = [Int]()           // 图形绘图数组
    private var shapeEntity = [SquareEntity]() // 方块队列
    private var left = 0                       // 可向左的偏移次数
    private var top = 0                        // 可向下的下降次数
    private var width = 0                      // 图形的宽度
    private var length = 0                     // 图形的长度
    private var imgName = ""                   // 资源名称
    
    // 绘制图形
    func drawShape(){
        for arr in shapeArray {
            if(arr == 1){
                SquareEntity.init(imageNamed: imgName)
                
            }
        }
    }
    
}
