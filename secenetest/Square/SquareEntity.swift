//
//  SquareEntity.swift
//  secenetest
//
//  Created by  孔尚杰 on 2023/2/24.
//

import Foundation
import SpriteKit

class SquareEntity : SKSpriteNode {

    var leftLimit = 4
    var downLimit = 20
    var sid = 0
    var lightStatus = 0
    
    required public init(imageNamed: String){
        let texture = SKTexture(imageNamed:imageNamed)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.lightStatus = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSid(sid:Int){
        self.sid = sid
    }
    
    func setLightOn(){
        self.lightStatus = 1
    }
    
    func setLightOff(){
        self.lightStatus = 0
    }
    
    // 是否能左移动
    func canLeft() -> Bool{
        if(leftLimit<=0){
            return false
        }else{
            leftLimit -= 1
            return true
        }
    }
    
    // 是否能左移动
    func canRight() -> Bool{
        if(leftLimit>8){
            return false
        }else{
            leftLimit += 1
            return true
        }
    }

    // 是否能下降
    func canDown() -> Bool {
        if(downLimit<=1){
            return false
        }else{
            downLimit -= 1
            return true
        }
    }
    
    func moveLeft(){
        self.run(.moveTo(x: self.position.x-unit, duration: 0))
    }
    
    func moveRight(){
        self.run(.moveTo(x: self.position.x+unit, duration: 0))
    }
    
    func moveDown(){
        self.run(.moveTo(y: self.position.y-unit, duration: 0))
    }
    
}
