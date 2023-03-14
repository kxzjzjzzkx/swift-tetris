//
//  GameScene.swift
//  secenetest
//
//  Created by  孔尚杰 on 2023/2/22.
//

import SwiftUI
import SpriteKit
import GameplayKit

let unit = 30.0     // 一个10像素
let unitInt = 30

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    

    var nowSquare: SKSpriteNode! = nil      // 当前方块
    var countSquare: SKShapeNode! = nil     // 底部累计的方块
    var game: GameEngine? = nil     // 核心处理器
    var mainLayer: GameMainLayer! = nil // 主界面
    
    let turnBtn = SKSpriteNode(imageNamed: "resources/button_rotate")       // 转向按钮
    let downBtn = SKSpriteNode(imageNamed: "resources/button_drop")         // 下降按钮
    
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        initUI()
                
        // 初始化 生成 积木界面
        self.mainLayer = GameMainLayer()
        self.mainLayer.position = CGPoint(x:self.size.width/2-170,y:self.size.height/3)
        self.addChild(self.mainLayer)
        
        // 生成操作界面
        turnBtn.position = CGPoint(x:self.size.width/3,y:self.size.height/4)
        turnBtn.setScale(0.3)
        self.addChild(turnBtn)
        downBtn.position = CGPoint(x:self.size.width/3+200,y:self.size.height/4)
        downBtn.setScale(0.3)
        self.addChild(downBtn)
        
        // 初始化 引擎
        game = GameEngine()
        
        self.mainLayer.makeRandomSquare()   // 生成一个随机积木
        
        // 新增积木 后续可以改成 “start”启动，再进行操作
        
    }
    
    func initUI(){
        // 底部
        let bgButtom = SKSpriteNode(color:UIColor.white,size: CGSize(width:self.size.width,height:80))
        bgButtom.anchorPoint = CGPoint.zero
        bgButtom.position = CGPoint.zero
        bgButtom.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x:0,y:21), to: CGPoint(x:bgButtom.size.width,y:21))
        self.addChild(bgButtom)
        
        // 头部
        let topFix :CGFloat = 100
        let bgTop = SKSpriteNode(color:UIColor.white,size: CGSize(width:self.size.width,height:self.size.height-topFix))
        bgTop.anchorPoint = CGPoint.zero
        bgTop.position = CGPoint.init(x: 0, y: self.size.height-topFix)
        self.addChild(bgTop)
        
//        // 宽10格，高20格 ，一格为一个正方块边长10像素
//        // 核心块
//        let baseFix = self.size.width/2-200  // 基础偏移
//        let mainTop = SKSpriteNode(color: UIColor.gray, size: CGSize(width:10*unit,height:1))
//        mainTop.anchorPoint = CGPoint.zero
//        mainTop.position = CGPoint(x: baseFix, y: self.size.height/2+unit*10)
//        self.addChild(mainTop)
//
//        let mainButtom = SKSpriteNode(color: UIColor.gray, size: CGSize(width:10*unit,height:1))
//        mainButtom.anchorPoint = CGPoint.zero
//        mainButtom.position = CGPoint(x: baseFix, y: self.size.height/2-unit*10)
//        self.addChild(mainButtom)
//
//        let mainLeft = SKSpriteNode(color: UIColor.gray, size: CGSize(width:1,height:20*unit))
//        mainLeft.anchorPoint = CGPoint.zero
//        mainLeft.position = CGPoint(x: baseFix, y: self.size.height/2-unit*10)
//        self.addChild(mainLeft)
//
//        let mainRight = SKSpriteNode(color: UIColor.gray, size: CGSize(width:1,height:20*unit))
//        mainRight.anchorPoint = CGPoint.zero
//        mainRight.position = CGPoint(x: baseFix+10*unit, y: self.size.height/2-unit*10)
//        self.addChild(mainRight)
        // 四个坐标点
        //  左上(40,self.size.height/2+unit*5) 右上(40+10*unit,self.size.height/2+unit*5)
        //  左下(40,self.size.height/2-unit*5) 右下(40+10*unit,self.size.height/2-unit*5)
//        for i in 0...1 {
//            let squareTemp = SKSpriteNode(imageNamed: "resources/pure_1")
//            squareTemp.anchorPoint = CGPoint.zero
//            squareTemp.position = CGPoint(x:mainTop.position.x+CGFloat(unitInt * i),y:mainTop.position.y)
//            self.addChild(squareTemp)
//        }
//        let squareTemp = SKSpriteNode(imageNamed: "resources/pure_1")
//        squareTemp.anchorPoint = CGPoint.zero
//        squareTemp.position = CGPoint(x:mainTop.position.x+CGFloat(unitInt * 4),y:mainTop.position.y - CGFloat(unitInt))
//        self.addChild(squareTemp)
//        let squareTemp = SquareEntity.init(imageNamed: "resources/pure_1", x: mainTop.position.x, y: mainTop.position.y, unitWidth: unitInt)
//        self.addChild(squareTemp)
//        nowSquare = squareTemp
        
        
    }
    
    func getOne(atPoint pos : CGPoint){
        let inode = SKSpriteNode(imageNamed: "resources/123")
        inode.setScale(0.5)
        inode.anchorPoint = CGPoint.zero
        inode.position = pos
        inode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: inode.size.width, height: inode.size.height))
        inode.physicsBody?.isResting = false
        inode.physicsBody?.restitution = 0      // 弹跳力 0-1 默认0.2
        inode.physicsBody?.allowsRotation = false    // 是否旋转
        inode.name="one"
        addChild(inode)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//        self.getOne(atPoint: pos)
//        self.mainLayer?.moveDown()
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        guard let touch  = touches.first else { return }
        let location = touch.location(in: self)
        if(self.turnBtn.contains(location)){
            print("点击转向")
            mainLayer.turn()
        }else if(self.downBtn.contains(location)){
            print("点击下降到底")
        }else{
            if(location.x<self.size.width/2){
                mainLayer?.moveHorizontal(isLeft: true)
            }else{
                mainLayer?.moveHorizontal(isLeft: false)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
        self.mainLayer?.playing(currentTime: currentTime)
    }
}

// 碰撞检测回调
//extension GameScene: SKPhysicsContactDelegate {
//    func didBegin(_ contact: SKPhysicsContact) {
//        let bodyA: SKPhysicsBody
//        let bodyB: SKPhysicsBody
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//            bodyA = contact.bodyA
//            bodyB = contact.bodyB
//        }else {
//            bodyA = contact.bodyB
//            bodyB = contact.bodyA
//        }
//
//        if bodyA.categoryBitMask == categoryRock && bodyB.categoryBitMask == categoryShip {
//            print("石头和飞船碰撞💥")
//        }
//    }
//}
