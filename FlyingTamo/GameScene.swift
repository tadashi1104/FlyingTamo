//
//  GameScene.swift
//  FlyingTamo
//
//  Created by 鈴木 義 on 2015/08/23.
//  Copyright (c) 2015年 Tadashi.S. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    //Tamoのスプライト
    var tamo = SKSpriteNode(imageNamed: "Tamo")
    //障害ベースのスプライト
    var syougaiBase = SKNode()
    
    //死亡フラグ
    var dethFlg = false
    
    override func didMoveToView(view: SKView) {
        //下方向に重力を追加　y軸は上が正、下が負
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
        //衝突を検知できるようにする
        self.physicsWorld.contactDelegate = self
        //画面の作成
        setScreen()
    }
    
    func setScreen() {
        //Tamoの配置
        setTamo()
        //背景の配置
        setBackground()
        //障害物の配置
        setSyougai()
    }
    
    func setTamo() {
        let tamoTexture = SKTexture(imageNamed: "Tamo")
        let tamo = SKSpriteNode(texture: tamoTexture)
        tamo.position = CGPoint(x: self.size.width * 0.2, y:self.size.height * 0.5)
        tamo.size = CGSize(width: tamoTexture.size().width, height: tamoTexture.size().height)
        tamo.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(25.0, 25.0))
        tamo.physicsBody?.linearDamping = 0 //流体や空気抵抗をシミュレート
        tamo.physicsBody?.allowsRotation = true //ぶつかった時に回転するかどうか
        tamo.physicsBody?.collisionBitMask = 1
        tamo.physicsBody?.contactTestBitMask = 1
        self.tamo = tamo
        self.addChild(tamo)
    }
    
    func setBackground() {
        let ground = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(self.size.width, 50.0))
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.size.width, 50.0))
        ground.physicsBody?.collisionBitMask = 1
        ground.physicsBody?.contactTestBitMask = 1
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.dynamic = false
        ground.position = CGPoint(x: self.size.width * 0.5, y: 25.0)
        ground.zPosition = 0.0

        self.addChild(ground)
    }
    
    func setSyougai() {
        
        //障害物の座標を指定するための変数
        var x:CGFloat = 0
        var y:CGFloat = 0
        
        //障害ベースの初期化
        syougaiBase.removeAllChildren()
        syougaiBase.removeAllActions()
        
        for i in 0..<200 {
            let syougai = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(25.0, 25.0))
//            let syougaiTexture = SKTexture(imageNamed: "")
//            syougaiTexture.filteringMode = .Linear
            
            syougai.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(20.0, 20.0))
            syougai.physicsBody?.collisionBitMask = 1
            syougai.physicsBody?.contactTestBitMask = 1
            syougai.physicsBody?.allowsRotation = false
            syougai.physicsBody?.dynamic = false
            syougai.zRotation = -1.0
            syougai.zPosition = -1
            
            x = self.size.width * 0.5 + CGFloat(i) * 100
            y = CGFloat(arc4random_uniform(UInt32(self.size.height))) + 50.0
            
            syougai.position = CGPoint(x: x, y: y)
            
            self.syougaiBase.addChild(syougai)
        }
        
        //アニメーションの設定
        let moveAnime = SKAction.moveBy(CGVector(dx: -100, dy: 0), duration: 0.5)
        let repeatForeverLeftAnime = SKAction.repeatActionForever(SKAction.sequence([moveAnime]))
        
        self.addChild(syougaiBase)
        
        syougaiBase.runAction(repeatForeverLeftAnime)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        dethFlg = true
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
        self.speed = 0
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touchbegan")
        if dethFlg == true {
            self.removeAllChildren()
            self.removeAllActions()
            setScreen()
            self.speed = 1
            dethFlg = false
            return
        }
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 3.0)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touchended")
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
