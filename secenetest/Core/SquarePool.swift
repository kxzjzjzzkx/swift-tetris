//  积木池
//  SquarePool.swift
//  secenetest
//
//  Created by  孔尚杰 on 2023/3/2.
//

import Foundation

class SquarePool {
    var intArray = [Int](repeating: 0, count: 240)              // 位置
    var drawArray = [SquareEntity](repeating: SquareEntity.init(imageNamed: ""), count: 200)  // 队列
    
    // 命中
    func hit(nowSquare:MutiSquareEntity) -> Bool {
        var hitFlag = false
        // 获取积木当前所有的点位置
        var x = nowSquare.getLeft()
        var y = nowSquare.getTop()
//        var t = getJudegePoint(nowSquare:nowSquare)
        for (i,obj) in nowSquare.shapeArray[nowSquare.shapeArrayIndex].enumerated() {
            if( obj == 0){
                continue    // 没有积木跳过
            }
            var xFix = i%4        // 需要横向偏移的位移
            var yFix = i/4        // 需要纵向偏移的位移
            print("积木移动中-位置x:",x,"y:",y,"xf:",xFix,"yf:",yFix)
            // 向下一个判定是否有碰撞，有则停止整块积木
//            print("当前积木下标点fix:",i,"有方块，进行向下推演")
            // 进行向下一部的推演
            
            
//            if(intArray[(x+xFix)+(y-yFix)*10] == 1 ){
//                print("命中！不可下移")
//                hitFlag = true      // 命中了。不可移动
//                break
//            }
        }
        // 推演过程中，如果遇到障碍，表示命中，则不再向下，记录下当前积木的位置
        // 拆分所有小方块，推进到drawArray队列里
        // 反馈down函数，停止下降
        return hitFlag
    }
    
    // 满格
    func full(){
        // 遍历所有行从上到下，发现满格，则消行，
        // 并向下平移
    }
    
    // 记录积木池
    func mark(nowSquare:MutiSquareEntity){
        for (i, obj) in nowSquare.shapeArray[nowSquare.shapeArrayIndex].enumerated(){
            if( obj == 0){
                continue    // 没有积木跳过
            }
            var x = nowSquare.getLeft()
            var y = nowSquare.getTop()
            var xFix = i%4        // 需要横向偏移的位移
            var yFix = i/4        // 需要纵向偏移的位移
            print("积木停止-位置x:",x,"y:",y,"xf:",xFix,"yf:",yFix)
            intArray[(x+xFix)+(y+yFix)*10] = 1  // 占位置
        }
        
    }
    
    // 展示积木池
    func show(){
        for (index, obj) in intArray.enumerated() {
            if(index%10 == 9){
                print(obj)
            }else{
                print(obj,terminator: "")
            }
        }
    }
}
