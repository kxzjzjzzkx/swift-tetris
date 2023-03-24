//  积木池
//  SquarePool.swift
//  secenetest
//
//  Created by  孔尚杰 on 2023/3/2.
//

import Foundation

class SquarePool {
    
    var drawArray = [SquareEntity]()  // 队列
//    var drawArray :Array<SquareEntity> = []
    
    func initPool(){
        print("初始化积木池位置 start")
        for _ in 0...239 {
            drawArray.append(SquareEntity.init(imageNamed: ""))
        }
        print("初始化积木池位置 end")
    }
    
    // 命中 下
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
        for (i,obj) in nowSquare.shapeArray[nowSquare.shapeArrayIndex].enumerated() {
            if( obj == 0){
                continue    // 没有积木跳过
            }
            let xFix = i%4        // 需要横向偏移的位移
            let yFix = i/4        // 需要纵向偏移的位移
            // 向下一个判定是否有碰撞，有则停止整块积木
            // 进行向下一部的推演
            if(drawArray[(x+xFix)+(y+yFix-1)*10].lightStatus == 1 ){
                print("命中！不可下移")
                hitFlag = true      // 命中了。不可移动
                nowSquare.setIsEnd() // 本积木生命周期结束
                break
            }
        }
        return hitFlag
    }
    
    // 获取单行满格
    func getOneFull() -> Int {
        var res = 0
        for i in 1...20 {
            var count = 0
            for j in 0...9 {
                count += drawArray[(i-1)*10+j].lightStatus
            }
            if(count == 10){
                res = i
                break
            }
        }
        return res
    }
    
    // 获取满格数量
    func findFullRows() -> [Int]{
        // 遍历所有行从上到下，发现满格，则记录
        var fullArray = [Int]()
        for i in 1...20 {
            var count = 0
            for j in 0...9 {
                count += drawArray[(i-1)*10+j].lightStatus
            }
            if(count == 10){
                fullArray.append(i)
            }
        }
        return fullArray
    }
    
    // 溢出
    func isOverflow() -> Bool {
        // 溢出判定 21行以后，存在一个积木点则游戏结束
        var flag = false
        for i in 200...239 {
            if(drawArray[i].lightStatus==1){
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
            nowSquare.shapeEntityArray[j].setSid(sid: endFix)       // 记录 sid
            nowSquare.shapeEntityArray[j].setLightOn()              // 记录 位置
            drawArray[endFix] = nowSquare.shapeEntityArray[j]       // 定位结束
            j += 1
        }
    }
    
    // 展示积木池
    func show(){
        for (index, obj) in drawArray.enumerated() {
            if(index%10 == 9){
                print(obj.lightStatus)
            }else{
                print(obj.lightStatus,terminator: "")
            }
        }
    }
    
    // 清空积木池
    func clearAll(){
        drawArray = [SquareEntity](repeating: SquareEntity.init(imageNamed: ""), count: 240)              // 位置
        for temp in drawArray {
            temp.removeFromParent()
        }
    }
}

extension SquarePool {
    
    // 清理这一行
    func clearByRow(row:Int){
        let i = row
        for j in 0...9 {
            let fix = (i-1)*10+j
            drawArray[fix].setLightOff()
            print("删除",i,"行",j,"列图形，下标：",drawArray[fix])
            drawArray[fix].removeFromParent()
        }
    }
    
    // i行往上全部下降
    func rowDown(row:Int){
        for i in row...20{
            print("从第",i+1,"行开始下移")
            for j in 0...9 {
                let nowFix = (i-1)*10+j      // 当前行
                let downFix = i*10+j  // 上一行
                // 方块转移
                if(drawArray[downFix].lightStatus==1){
                    print("要下移的下标:",downFix,"目标的下标:",nowFix)
                    print(drawArray[downFix])
                    print("转移至->")
                    print(drawArray[nowFix])
                }
                drawArray[downFix].moveDown()
                drawArray[nowFix] = drawArray[downFix]
                drawArray[downFix] = SquareEntity.init(imageNamed: "")              // 初始化移动过的格子
                if(drawArray[nowFix].lightStatus==1){
                    print("转移后->")
                    print(drawArray[nowFix])
                }
            }
            
        }
    }
    
    // 命中 左
    func hitLeft(nowSquare:MutiSquareEntity) -> Bool {
        var hitFlag = false
        // 获取积木当前所有的点位置
        let x = nowSquare.getLeft()
        let y = nowSquare.getTop()
        if x == 0 {
            // 最左
            return true
        }
        for (i,obj) in nowSquare.shapeArray[nowSquare.shapeArrayIndex].enumerated() {
            if( obj == 0){
                continue    // 没有积木跳过
            }
            let xFix = i%4        // 需要横向偏移的位移
            let yFix = i/4        // 需要纵向偏移的位移
            // 向下一个判定是否有碰撞，有则停止整块积木
            // 进行向下一部的推演
            if(drawArray[(x+xFix-1)+(y+yFix)*10].lightStatus == 1 ){
                print("命中！不可下移")
                hitFlag = true      // 命中了。不可移动
                break
            }
        }
        return hitFlag
    }
    
    // 命中 右
    func hitRight(nowSquare:MutiSquareEntity) -> Bool {
        var hitFlag = false
        // 获取积木当前所有的点位置
        let x = nowSquare.getLeft()
        let y = nowSquare.getTop()
        if x == 10 {
            // 最右
            return true
        }
        for (i,obj) in nowSquare.shapeArray[nowSquare.shapeArrayIndex].enumerated() {
            if( obj == 0){
                continue    // 没有积木跳过
            }
            let xFix = i%4        // 需要横向偏移的位移
            let yFix = i/4        // 需要纵向偏移的位移
            // 向下一个判定是否有碰撞，有则停止整块积木
            // 进行向下一部的推演
            if(drawArray[(x+xFix+1)+(y+yFix)*10].lightStatus == 1 ){
                print("命中！不可下移")
                hitFlag = true      // 命中了。不可移动
                break
            }
        }
        return hitFlag
    }
    
}
