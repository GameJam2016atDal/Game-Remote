//
//  GameScene.swift
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//

import SpriteKit
import SocketKit

class GameScene: SKScene {
	
	
	let moveAnalogStick =  🕹(diameter: 170)
	var socket: Socket!
	
	override func didMove(to view: SKView) {
		/* Setup your scene here */
		backgroundColor = UIColor.white
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		
		moveAnalogStick.position = CGPoint(x: moveAnalogStick.radius + 50, y: moveAnalogStick.radius + 50)
		addChild(moveAnalogStick)
		
		//MARK: Handlers begin
		
		moveAnalogStick.trackingHandler = { [unowned self] data in
			let direction = data.velocity.x
			do {
				if direction > 0 {
					try self.socket.write(value: "2")
				} else {
					try self.socket.write(value: "0")
				}
			} catch {
				print("Write Error")
			}
		}
		moveAnalogStick.stopHandler = { [unowned self] data in
			do {
				try self.socket.write(value: "4")
			} catch {
				print("Error")
			}
		}
		setRandomStickColor()
		//        addApple(CGPoint(x: frame.midX, y: frame.midY))
		
		view.isMultipleTouchEnabled = true
	}
	
	func toOtherScene() {
		let newScene = GameScene()
		newScene.scaleMode = .resizeFill
		let transition = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
		view?.presentScene(newScene, transition: transition)
	}
	
	func setRandomStickColor() {
		
		let randomColor = UIColor.random()
		moveAnalogStick.stick.color = randomColor
	}
	
	func setRandomSubstrateColor() {
		
		let randomColor = UIColor.random()
		moveAnalogStick.substrate.color = randomColor
	}
	
	override func update(_ currentTime: TimeInterval) {
		/* Called before each frame is rendered */
	}
}

extension UIColor {
	
	static func random() -> UIColor {
		
		return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
	}
}
