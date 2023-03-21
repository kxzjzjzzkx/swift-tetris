//  积木池
//  SquarePool.swift
//  secenetest
//
//  Created by  孔尚杰 on 2023/3/2.
//

import Foundation

class SquarePool {
    var intArray = [Int](repeating: 0, count: 240)              // 位置
    var drawArray = [SquareEntity](repeating: SquareEntity.init(imageNamed: ""), count: 240)  // 队列
    
    // 命中
    func hit(nowSquare:MutiSquareEntity) -> Bool {
        var hitFlag = false
        // 获取积木当前所有的点位置
        let x = nowSquare.getLeft()
        let y = nowSquare.getTop()
        if y == 0 {
            // 命中底部
            nowSquare.setIsEnd() // 本积木生命周期结束
            return true
        }
//        var t = getJudegePoint(nowSquare:nowSquare)
        for (i,obj) in nowSquare.shapeArray[nowSquare.shapeArrayIndex].enumerated() {
            if( obj == 0){
                continue    // 没有积木跳过
            }
            let xFix = i%4        // 需要横向偏移的位移
            let yFix = i/4        // 需要纵向偏移的位移
//            print("积木移动中-位置x:",x,"y:",y,"xf:",xFix,"yf:",yFix)
            // 向下一个判定是否有碰撞，有则停止整块积木
//            print("当前积木下标点fix:",i,"有方块，进行向下推演")
            // 进行向下一部的推演
            if(intArray[(x+xFix)+(y+yFix-1)*10] == 1 ){
                print("命中！不可下移")
                hitFlag = true      // 命中了。不可移动
                nowSquare.setIsEnd() // 本积木生命周期结束
                break
            }
        }
        // 推演过程中，如果遇到障碍，表示命中，则不再向下，记录下当前积木的位置
        // 拆分所有小方块，推进到drawArray队列里
        // 反馈down函数，停止下降
        return hitFlag
    }
    
    // 满格
    func full() -> Int{
        var score = 0
        let fullArray = findFull()  // 查询是否存在满行
        if(fullArray.count>0){
            print("发现满行=",fullArray)
            score = fullArray.count * 100 // 获得分数 一行100分 后续可以考虑成多种计分方式
            clearByRow(clearRow:fullArray) // 从上至下消行
        }
        return score
    }
    
    // 溢出
    func overflow() -> Bool {
        // 溢出判定 21行以后，存在一个积木点则游戏结束
        var flag = false
        for i in 200...239 {
            if(intArray[i]==1){
                flag = true
                break
            }
        }
        return flag
    }
    
    // 记录积木池
    func mark(nowSquare:MutiSquareEntity){
        var j = 0
        for (i, obj) in nowSquare.shapeArray[nowSquare.shapeArrayIndex].enumerated(){
            if( obj == 0){
                continue    // 没有积木跳过
            }
            let x = nowSquare.getLeft()
            let y = nowSquare.getTop()
            let xFix = i%4        // 需要横向偏移的位移
            let yFix = i/4        // 需要纵向偏移的位移
//            print("积木停止-位置x:",x,"y:",y,"xf:",xFix,"yf:",yFix)
            let endFix = (x+xFix)+(y+yFix)*10
            intArray[endFix] = 1  // 占位置
            nowSquare.shapeEntityArray[j].setSid(sid: endFix)
            drawArray[endFix] = nowSquare.shapeEntityArray[j]
            j += 1
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
    
    // 清空积木池
    func clearAll(){
        intArray = [Int](repeating: 0, count: 240)              // 位置
        for temp in drawArray {
            temp.removeFromParent()
        }
    }
}

extension SquarePool {
    // 找到满行的 横行
    func findFull() -> [Int] {
        // 遍历所有行从上到下，发现满格，则记录
        var fullArray = [Int]()
        for i in 1...20 {
            var count = 0
            for j in 0...9 {
                count += intArray[(i-1)*10+j]
            }
            if(count == 10){
                fullArray.append(i)
            }
        }
        return fullArray
    }
    
    // 清理这一行
    func clearByRow(clearRow:[Int]){
        for i in clearRow.reversed() {  // 倒序
            for j in 0...9 {
                let fix = (i-1)*10+j
                intArray[fix] = 0
                print("删除图形，下标：",drawArray[fix])
                drawArray[fix].removeFromParent()
            }
            rowDown(row:i)
        }
    }
    
    // i行往上全部下降
    func rowDown(row:Int){
        for i in row...20{
            for j in 0...9 {
                let nowFix = (i-1)*10+j      // 当前行
                let downFix = i*10+j  // 上一行
                // 方块转移
                drawArray[nowFix] = drawArray[downFix]
                drawArray[downFix] = SquareEntity.init(imageNamed: "")
                intArray[nowFix] = intArray[downFix]
                intArray[downFix] = 0
                drawArray[nowFix].moveDown()    // 前台渲染要下降
            }
        }
    }
    
}
