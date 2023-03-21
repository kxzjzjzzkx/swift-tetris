//
//  GameEngine.swift
//  secenetest
//
//  Created by  孔尚杰 on 2023/2/23.
//

import SpriteKit

class GameMainLayer: SKNode{

    var nowSquare: SquareEntity! = nil              // 当前积木
    var nowMutiSquare: MutiSquareEntity! = nil      // 当前积木-组合
    var squarePool: SquarePool! = SquarePool()      // 积木池
    var countSquare: SKSpriteNode! = nil            // 累计积木
    
    var lastChangeTime = 0.0        // 最后修改时间
    var timeLimit = 0.3             // 行动间隔时间
    
    var gameStatus = "playing"
    var gameScore = 0
    
    override init(){
        super.init()
        
        // 宽10格，高20格 ，一格为一个正方块边长10像素
        // 核心块
        let mainTop = SKSpriteNode(color: UIColor.gray, size: CGSize(width:10*unit,height:1))
        mainTop.anchorPoint = CGPoint.zero
        mainTop.position = CGPoint(x: 0, y: 0)
        self.addChild(mainTop)
    
        let mainButtom = SKSpriteNode(color: UIColor.gray, size: CGSize(width:10*unit,height:1))
        mainButtom.anchorPoint = CGPoint.zero
        mainButtom.position = CGPoint(x: 0, y: unit*20)
        self.addChild(mainButtom)
    
        let mainLeft = SKSpriteNode(color: UIColor.gray, size: CGSize(width:1,height:20*unit))
        mainLeft.anchorPoint = CGPoint.zero
        mainLeft.position = CGPoint(x: 0, y: 0)
        self.addChild(mainLeft)

        let mainRight = SKSpriteNode(color: UIColor.gray, size: CGSize(width:1,height:20*unit))
        mainRight.anchorPoint = CGPoint.zero
        mainRight.position = CGPoint(x: unit*10,y: 0)
        self.addChild(mainRight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createNewSquare(){
        // 生成单个方块
        self.nowSquare = SquareEntity(imageNamed: "resources/pure_1")
        nowSquare.position = CGPoint(x:4.5*unit,y:19.5*unit)
        self.addChild(nowSquare)
    }
    
    // 水平移动 以手指点击位为准
    func moveHorizontal(isLeft: Bool){
        if(isLeft){
            moveLeft()
        }else{
            moveRight()
        }
    }
    
    func moveLeft(){
        if nowMutiSquare != nil {
            nowMutiSquare.moveLeft()
        }
    }
    
    func moveRight(){
        if nowMutiSquare != nil {
            nowMutiSquare.moveRight()
        }
        
    }
    // 转向
    func turn(){
        if nowMutiSquare != nil {
            // if判断是否可以变化
            nowMutiSquare.turn()
        }
    }
    
    // 游戏进行中
    func playing(currentTime: CFTimeInterval){
        // 单位时间到，game继续进行
        if(gameStatus=="game over"){
            // game over
        }else{
            if(currentTime-lastChangeTime>=timeLimit){
                lastChangeTime = currentTime
                if canDown() {
                    nowMutiSquare.moveDown()    // 方块可以移动，进行移动
                }
                // 积木是否到底
                if( nowMutiSquare.getIsEnd()){
                    print("方块不可下移，移动到底部了")
                    squarePool.mark(nowSquare: nowMutiSquare)   // 记录当前积木进入积木池
                    print("积木结束积木池当前积木")
                    squarePool.show()                           // 打印积木形状
                    // 消行 计分 满格删除下沉
                    gameScore += squarePool.full()
                    print("发现满行清理满行积木池当前积木")
                    squarePool.show()
                    if(squarePool.overflow()){
                        // 超行，game over
                        print("game over ,wait for restart ")
    //                    nowMutiSquare = nil
    //                    squarePool.clear()
                        gameStatus = "game over"
                    }else{
                        // game playing
                        makeRandomSquare()                          // 生成新积木
                    }
                    return
                }
            }
        }
    }
    
    func makeRandomSquare(){
        
//        let type = arc4random() % 7 // 随机积木
//        let status  = 0             // 默认初始状态
        // 生成复杂的方块组合
        let type = 0
        switch type {
            case 0:
                self.nowMutiSquare = MutiSquareEntity(imageNamed: SquareL.imagesName,shapeArray: SquareL.array)
            case 1:
                self.nowMutiSquare = MutiSquareEntity(imageNamed: SquareO.imagesName,shapeArray: SquareO.array)
            case 2:
//                self.nowMutiSquare = MutiSquareEntity(imageNamed: SquareZL.imagesName,shapeArray: SquareZL.array)
                self.nowMutiSquare = MutiSquareEntity(imageNamed: SquareO.imagesName,shapeArray: SquareO.array)
            case 3:
//                self.nowMutiSquare = MutiSquareEntity(imageNamed: SquareZR.imagesName,shapeArray: SquareZR.array)
                self.nowMutiSquare = MutiSquareEntity(imageNamed: SquareO.imagesName,shapeArray: SquareO.array)
            case 4:
                self.nowMutiSquare = MutiSquareEntity(imageNamed: SquareSL.imagesName,shapeArray: SquareSL.array)
            case 5:
                self.nowMutiSquare = MutiSquareEntity(imageNamed: SquareSR.imagesName,shapeArray: SquareSR.array)
            case 6:
                self.nowMutiSquare = MutiSquareEntity(imageNamed: SquareT.imagesName,shapeArray: SquareT.array)
            default:
                self.nowMutiSquare = MutiSquareEntity(imageNamed: SquareL.imagesName,shapeArray: SquareL.array)
        }
        self.addChild(nowMutiSquare)
    }

}

extension GameMainLayer{
    // 是否能变换的 判断
    func canTurn(){
    
    }
    
    // 是否能下降
    func canDown() -> Bool{
        if nowMutiSquare == nil {
            return false      // 组合方块不存在，则结束
        }
//        if nowMutiSquare.getTop() == 0 {
//            return false      // 可下移次数结束，结束
//        }
        // 判定当前积木命中范围
        if( squarePool.hit(nowSquare: nowMutiSquare)){
            // 下一步收到阻碍
            print("方块不可下移，接触其他积木")
            return false
        }
        return true
    }
    
}
