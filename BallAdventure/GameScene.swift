//
//  GameScene.swift
//  BallAdventure
//
//  Created by gangyeol kim on 2016. 1. 27..
//  Copyright (c) 2016년 gangyeol kim. All rights reserved.
//1142, 472

import SpriteKit
import GoogleMobileAds

struct StaticVariable{
    
    static var round = 1 // Default must 1
    static var playTime = 0
    static var dieAndClearCount = 0

}

struct PhysicsCategory{
    
    static let player:UInt32 = 0x1 << 1
    static let exit:UInt32 = 0x1 << 2
    static let wall:UInt32 = 0x1 << 3
    static let background:UInt32 = 0x1 << 4
    static let toWarpNode:UInt32 = 0x1 << 5
    static let fromWarpNode:UInt32 = 0x1 << 6
    
}

class GameScene: SKScene,SKPhysicsContactDelegate{
    
    
    var stageName : [String?] = ["Go Go Go !","One Hole","Angry Dot", "Moving Bridge","Rotate Rotate!","Dot Dot Dot!","Bonus Stage","Think Big","The Hell","Teleport","Ad Maker","Hello!"]
    var player = SKShapeNode(circleOfRadius: 20)
    var exit = SKSpriteNode()
    var walls = [SKSpriteNode]()
    
    var toWarpNode = SKSpriteNode()
    var fromWarpNode = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        
        // print(self.camera?.position)
        
        presentRound()
        setExit()
        setPlayer()
        setWall()
        setView()
        setWarp()
        
        // authenticateLocalPlayer()
        
    }
    
    
    
    func presentRound(){
        
        let roundLabel = SKLabelNode(text: "Round \(StaticVariable.round)")
        roundLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.maxY - 200)
        
        let removeRoundLabel = SKAction.runBlock { () -> Void in
            
            roundLabel.removeFromParent()
        }
        
        let waitAction05 = SKAction.waitForDuration(0.5)
        
        let scaleUp = SKAction.fadeInWithDuration(1.3)
        let scaleDown = SKAction.fadeOutWithDuration(1.5)
        
        let sequence = SKAction.sequence([scaleUp,waitAction05,scaleDown,removeRoundLabel])
        
        roundLabel.fontName =   "TrebuchetMS-Bold"
        roundLabel.fontSize = 50
        
        roundLabel.fontColor = UIColor(red: 93/255, green: 74/255, blue: 102/255, alpha: 1)
        roundLabel.runAction(sequence)
        
        addChild(roundLabel)
        
        
        
        let roundNameLabel = SKLabelNode(text: "\(stageName[StaticVariable.round - 1]!)")
        roundNameLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.maxY - 250)
        roundNameLabel.alpha = 0
        
        let removeRoundNameLabel = SKAction.runBlock { () -> Void in
            
            roundNameLabel.removeFromParent()
        }
        
        let waitAction = SKAction.waitForDuration(0.3)
        
        let roundNameScaleUp = SKAction.fadeInWithDuration(1)
        let roundNameScaleDown = SKAction.fadeOutWithDuration(1.5)
        
        let roundNameSequence = SKAction.sequence([waitAction,roundNameScaleUp,waitAction05,roundNameScaleDown,removeRoundNameLabel])
        
        roundNameLabel.fontName =   "TrebuchetMS-Bold"
        roundNameLabel.fontSize = 30
        
        roundNameLabel.fontColor = UIColor(red: 93/255, green: 74/255, blue: 102/255, alpha: 1)
        roundNameLabel.runAction(roundNameSequence)
        
        addChild(roundNameLabel)
        
    }
    
    func setView(){
        
        
        backgroundColor = UIColor(red: 231/255, green: 215/255, blue: 193/255, alpha: 1)
        //  self.scaleMode = .AspectFit
        self.scaleMode = .AspectFit
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = PhysicsCategory.background
        self.physicsBody?.collisionBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false
        self.name = "background"
        
    }
    
    func setWall(){
        
        for wall in self.children {
            if wall.name == "wall" {
                if let wall = wall as? SKSpriteNode {
                    
                    walls.append(wall)
                    wall.physicsBody = SKPhysicsBody(rectangleOfSize: wall.size)
                    wall.physicsBody?.categoryBitMask = PhysicsCategory.wall
                    wall.physicsBody?.collisionBitMask = PhysicsCategory.player
                    wall.physicsBody?.contactTestBitMask = PhysicsCategory.player
                    wall.physicsBody?.dynamic = false
                    wall.physicsBody?.affectedByGravity = false
                    //wall.name = "wall"
                }
            }
        }
        
        //        wall = self.childNodeWithName("wall") as! SKSpriteNode
    }
    
    func setWarp(){
        
        if(self.childNodeWithName("toWarpNode") != nil){
            
            toWarpNode = self.childNodeWithName("toWarpNode") as! SKSpriteNode
            fromWarpNode = self.childNodeWithName("fromWarpNode") as! SKSpriteNode
            
            toWarpNode.physicsBody = SKPhysicsBody(rectangleOfSize: toWarpNode.size)
            toWarpNode.physicsBody?.categoryBitMask = PhysicsCategory.toWarpNode
            toWarpNode.physicsBody?.collisionBitMask = PhysicsCategory.player
            toWarpNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
            toWarpNode.physicsBody?.dynamic = false
            toWarpNode.physicsBody?.affectedByGravity = false
            toWarpNode.name = "toWarpNode"
            
            
            fromWarpNode.physicsBody = SKPhysicsBody(rectangleOfSize: fromWarpNode.size)
            fromWarpNode.physicsBody = SKPhysicsBody(rectangleOfSize: toWarpNode.size)
            fromWarpNode.physicsBody?.categoryBitMask = PhysicsCategory.fromWarpNode
            fromWarpNode.physicsBody?.collisionBitMask = PhysicsCategory.player
            fromWarpNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
            fromWarpNode.physicsBody?.dynamic = false
            fromWarpNode.physicsBody?.affectedByGravity = false
            fromWarpNode.name = "fromWarpNode"
            
        
            
        }
        
        else{
            
        }
        
    }
    
    func setExit(){
        
        
        
        exit = self.childNodeWithName("exit") as! SKSpriteNode
        
        exit.color = UIColor(red: 214/255, green: 81/255, blue: 8/255, alpha: 1)
        
        exit.physicsBody = SKPhysicsBody(rectangleOfSize: exit.size)
        
        exit.physicsBody?.categoryBitMask = PhysicsCategory.exit
        exit.physicsBody?.collisionBitMask = PhysicsCategory.player
        exit.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        exit.physicsBody?.dynamic = false
        exit.physicsBody?.affectedByGravity = false
        exit.name = "exit"
        
        let exitLabel = SKLabelNode(text: "Exit")
        exitLabel.position = CGPoint(x: 4, y: -7)
        exitLabel.fontSize = 20
        exitLabel.fontName = "TrebuchetMS-Bold"
        exitLabel.fontColor = UIColor.whiteColor()
        
        exit.addChild(exitLabel)
        
        
    }
    
    func setPlayer(){
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.exit
        player.physicsBody?.collisionBitMask = PhysicsCategory.exit
        
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.dynamic = true
        
        player.fillColor = UIColor(red: 191/255, green: 67/255, blue: 66/255, alpha: 1)
        player.strokeColor = UIColor(red: 191/255, green: 67/255, blue: 66/255, alpha: 1)
        player.antialiased = true
        
        
        
        
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width/2)
        player.physicsBody?.friction = 0
        player.physicsBody?.restitution = 1
        player.physicsBody?.linearDamping = 0
        player.physicsBody?.angularDamping = 0
        player.position = CGPoint(x: 100, y: 600) // 초기값 100, 600
        player.name = "player"
        
        addChild(player)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
        
        for touch in touches{
            
            let location = touch.locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if(touch.locationInNode(self).x < self.frame.width / 2){
                
                player.physicsBody?.applyImpulse(CGVector(dx: -3, dy: 0))
                
            }
                
            else{
                
                player.physicsBody?.applyImpulse(CGVector(dx: 3, dy: 0))
                
            }
            
            if (node.name == "restartButton") {
                
                restartGame()
            }
            
        }
        
        
        // If next button is touched, start transition to second scene
        
        
    }
    
    
    func restartGame(){
        
        
        StaticVariable.playTime = 0
        StaticVariable.round = 1
        
        goToNextScene()
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        return "\(seconds) sec"
    }
    
    func goToNextScene(){
        
        
        
        removeAllChildren()
        
        let nextScene = GameScene(fileNamed: "Round\(StaticVariable.round)")
        
        if(nextScene != nil){
            
            
            nextScene!.scaleMode = .AspectFit
            
            scene?.view?.presentScene(nextScene!)
            
            setPlayer()
            
            
            
        }
            
        else{
            
            
            removeAllChildren()
            
            let finishLabel = SKLabelNode(text: "Total Play Time = \(secondsToHoursMinutesSeconds(StaticVariable.playTime))")
            finishLabel.fontName = "TrebuchetMS-Bold"
            finishLabel.fontColor = UIColor(red: 93/255, green: 74/255, blue: 102/255, alpha: 1)
            finishLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            finishLabel.fontSize = 40
            
            finishLabel.alpha = 0
            let fadeAlpha1 = SKAction.fadeAlphaTo(1, duration: 1)
            finishLabel.runAction(fadeAlpha1)
            
            
            addChild(finishLabel)
            
            let restartButton = SKLabelNode(text: "Restart!")
            restartButton.fontColor = UIColor.blueColor()
            restartButton.fontName = "TrebuchetMS-Bold"
            restartButton.fontSize = 50
            restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 100)
            restartButton.name = "restartButton"
            restartButton.alpha = 0
            
            
            let waitASecond = SKAction.waitForDuration(1)
            let restartButtonSequence = SKAction.sequence([waitASecond,fadeAlpha1])
            
            
            restartButton.runAction(restartButtonSequence)
            
            
            addChild(restartButton)
            
            
            
        }
        
        
    }
    
    func gameEnded(){
        
        StaticVariable.dieAndClearCount++
        
        player.removeFromParent()
        setPlayer()
        
        // 만일 죽거나, 판을 깬 횟수의 합이 5가 넘으면 .. 광고를 보여줘야지.
        if(StaticVariable.dieAndClearCount % 5 == 0){
            //viewFullSizedAd()
            
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
     //   print(StaticVariable.dieAndClearCount)
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        
        
        if ((firstBody.categoryBitMask & PhysicsCategory.player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.exit != 0)) {
                
                
                let playerNode = firstBody.node
                let exitNode = secondBody.node
                
                
                if(playerNode?.name == "player" && exitNode!.name == "exit" ){
                    
                    
                    StaticVariable.dieAndClearCount++
                    
                    
                    if(StaticVariable.dieAndClearCount%5 == 0){
                        
               //         viewFullSizedAd()
                        
                    }
                    
                    StaticVariable.round++
                    // showGameCenter()
                    goToNextScene()
                    
                }
                    
                else{
                    
                }
                
        }
            
        else if ((firstBody.categoryBitMask & PhysicsCategory.player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.wall != 0)) {
                
                let playerNode = firstBody.node
                let exitNode = secondBody.node
                
                
                if(playerNode?.name == "player" && exitNode!.name == "wall" ){
                    
                    self.runAction(SKAction.playSoundFileNamed("ballSound.mp3", waitForCompletion: false))
                    
                    
                }
                    
                else{
                    
                }
                
        }
            
        else if ((firstBody.categoryBitMask & PhysicsCategory.player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.background != 0)) {
                
                let playerNode = firstBody.node
                let exitNode = secondBody.node
                
                
                if(playerNode?.name == "player" && exitNode!.name == "background" ){
                    
                    self.runAction(SKAction.playSoundFileNamed("dieSound.wav", waitForCompletion: false))
                    gameEnded()
                    
                }
                    
                else{
                    
                    
                    
                }
                
        }
        
        else if ((firstBody.categoryBitMask & PhysicsCategory.player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.toWarpNode != 0)) {
                
                let playerNode = firstBody.node
                let exitNode = secondBody.node
                
                
                if(playerNode?.name == "player" && exitNode!.name == "toWarpNode" ){
                    
                    player.removeFromParent()
                    
                    player.position = CGPoint(x: fromWarpNode.position.x, y: fromWarpNode.position.y - 110)
                    
                    addChild(player)
                    
                }
                    
                else{
                    
                    
                }
                
        }
        
    }
    
  
    
    
}

