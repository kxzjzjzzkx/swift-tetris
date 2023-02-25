//
//  GameEngine.swift
//  secenetest
//
//  Created by  孔尚杰 on 2023/2/23.
//

import SpriteKit

class GameMainLayer: SKNode{

    var nowSquare: SquareEntity! = nil      // 当前积木
    var countSquare: SKSpriteNode! = nil    // 累计积木
    
    var lastChangeTime = 0.0        // 最后修改时间
    var timeLimit = 1.0             // 行动间隔时间
    
    
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
        self.nowSquare = SquareEntity(imageNamed: "resources/pure_1")
        nowSquare.position = CGPoint(x:4.5*unit,y:19.5*unit)
        self.addChild(nowSquare)
    }
    
    // 向下
    func moveDown(){
        if(nowSquare.canDown()){
            nowSquare.moveDown()
        }else{
            print("到最低端了，不可再向下，新建一个方块")
//            nowSquare.removeFromParent()
            // 保存这个方块，新建一个方块，重新下落
            createNewSquare()
        }
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
        if(nowSquare.canLeft()){
            nowSquare.moveLeft()
        }else{
            print("到最左端了，不可再向左")
        }
    }
    
    func moveRight(){
        if(nowSquare.canRight()){
            nowSquare.moveRight()
        }else{
            print("到最右端了，不可再向右")
        }
        
    }
    
    func playing(currentTime: CFTimeInterval){
//        print("当前时间 ",currentTime)
        if(currentTime-lastChangeTime>=timeLimit){
            lastChangeTime = currentTime
            moveDown()
        }
    }

}
