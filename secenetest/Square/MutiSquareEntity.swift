//
//  MutiSquareEntity.swift
//  secenetest
//
//  Created by  孔尚杰 on 2023/2/25.
//

import Foundation
import SpriteKit

class MutiSquareEntity: SKSpriteNode {
    
    
    var shapeArray = [[Int]]()    // 图形绘图数组
    var shapeArrayIndex = 0
    
    var shapeEntityArray = [SquareEntity]()     // 方块队列
    private var left = 0                       // 可向左的偏移次数
    private var top = 21                       // 可向下的下降次数 按照未入框开始算，其实是下降20次
    private var width = 0                      // 图形的宽度-横线
    private var length = 0                     // 图形的长度-竖线
    private var imgName = ""                   // 资源名称
    private var isEnd = false
    
    required public init(imageNamed: String,shapeArray: [[Int]]){
        self.shapeArray = shapeArray
        self.width=1
        self.length=4
        self.left = 5 - self.width
        self.imgName = imageNamed
        super.init(texture: nil, color: UIColor.clear, size: CGSize.zero)
//        super.init(color: UIColor.clear, size: CGSize.zero)
        drawShape()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // 绘制图形
    func drawShape(){
        let baseX = 4 * unit
        let baseY = CGFloat(20+self.width) * unit
        var i: Int = 0
        var count : Int = 0
        for arr in shapeArray[shapeArrayIndex] {
            if(arr == 1){
                count += 1
                let temp = SquareEntity.init(imageNamed: imgName)
                temp.anchorPoint = CGPoint.zero
                temp.position = CGPoint(x:baseX+CGFloat((i%4)*unitInt),y:baseY+CGFloat((i/4)*unitInt))
                self.addChild(temp)
                shapeEntityArray.append(temp)        // 形状实例组合
            }
            i+=1
        }
        computeMaxWidth()
        computeMaxLength()
    }
    
    
    
    func moveDown(){
        if(!self.canDown()){
            return
        }
        for temp in shapeEntityArray{
            temp.run(.moveTo(y: temp.position.y-unit, duration: 0))
        }
        top -= 1
        if top == 0 {
            isEnd = true    // 积木停止移动
        }
    }
    
    func moveLeft(){
        if(!self.canLeft()){
            print("到最左端了，不可再向左")
            return
        }
        for temp in shapeEntityArray{
            temp.run(.moveTo(x: temp.position.x-unit, duration: 0))
        }
        left -= 1
    }
    
    func moveRight(){
        if(!self.canRight()){
            print("到最右端了，不可再向右")
            return
        }
        for temp in shapeEntityArray{
            temp.run(.moveTo(x: temp.position.x+unit, duration: 0))
        }
        left += 1
    }
    
    func turn(){
        clear()     // 清理
        shapeArrayIndex += 1        // 队列增加
        shapeArrayIndex = shapeArrayIndex%shapeArray.count
        // 构建变换图形
        let baseX = CGFloat(left) * unit
        let baseY = CGFloat(top) * unit
        var i: Int = 0
        var count : Int = 0
        for arr in shapeArray[shapeArrayIndex] {
            if(arr == 1){
                count += 1
                let temp = SquareEntity.init(imageNamed: imgName)
                temp.anchorPoint = CGPoint.zero
                temp.position = CGPoint(x:baseX+CGFloat((i%4)*unitInt),y:baseY+CGFloat((i/4)*unitInt))
                self.addChild(temp)
                shapeEntityArray.append(temp)        // 形状实例组合
            }
            i+=1
        }
        computeMaxWidth()
        computeMaxLength()
        
    }
    
    func clear(){
        // 删除当前图形
        for temp in shapeEntityArray{
            temp.removeFromParent()
        }
    }
    
    func getIsEnd() -> Bool {
        return self.isEnd
    }
    
    func setIsEnd() {
        self.isEnd = true
    }
    
    func getLeft() -> Int {
        return self.left
    }
    
    func getTop() -> Int {
        return self.top
    }
    
}
// MARK
extension MutiSquareEntity{
    
    func canDown() -> Bool {
//        print("top:",top)
        if( top > 0){
            return true
        }
        return false
    }
    
    func canLeft() -> Bool {
        print("left:",left,"width:",self.width)
        if( left > 0){
            return true
        }
        return false
    }
    
    func canRight() -> Bool {
        print("right:",left,"width",self.width)
        if( left + self.width < 10){
            return true
        }
        return false
    }
    
    // 计算图形的宽度-横线
    func computeMaxWidth(){
        var widthArray = [
            shapeArray[shapeArrayIndex][0]+shapeArray[shapeArrayIndex][1]+shapeArray[shapeArrayIndex][2]+shapeArray[shapeArrayIndex][3],
            shapeArray[shapeArrayIndex][4]+shapeArray[shapeArrayIndex][5]+shapeArray[shapeArrayIndex][6]+shapeArray[shapeArrayIndex][7],
            shapeArray[shapeArrayIndex][8]+shapeArray[shapeArrayIndex][9]+shapeArray[shapeArrayIndex][10]+shapeArray[shapeArrayIndex][11],
            shapeArray[shapeArrayIndex][12]+shapeArray[shapeArrayIndex][13]+shapeArray[shapeArrayIndex][14]+shapeArray[shapeArrayIndex][15]
        ]
        self.width = widthArray.max() ?? 0
    }
    
    // 计算图形的长度-竖线
    func computeMaxLength(){
        var lengthArray = [
            shapeArray[shapeArrayIndex][0]+shapeArray[shapeArrayIndex][4]+shapeArray[shapeArrayIndex][8]+shapeArray[shapeArrayIndex][12],
            shapeArray[shapeArrayIndex][1]+shapeArray[shapeArrayIndex][5]+shapeArray[shapeArrayIndex][9]+shapeArray[shapeArrayIndex][13],
            shapeArray[shapeArrayIndex][2]+shapeArray[shapeArrayIndex][6]+shapeArray[shapeArrayIndex][10]+shapeArray[shapeArrayIndex][14],
            shapeArray[shapeArrayIndex][3]+shapeArray[shapeArrayIndex][7]+shapeArray[shapeArrayIndex][11]+shapeArray[shapeArrayIndex][15]
        ]
        self.length = lengthArray.max() ?? 0
    }
    
    
    
    
    
}
