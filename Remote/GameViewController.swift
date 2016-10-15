//
//  GameViewController.swift
//  stick test
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//  Copyright (c) 2014 Dmitriy Mitrophanskiy. All rights reserved.
//

import UIKit
import SpriteKit
import SocketKit

class GameViewController: UIViewController {
	
	var socket: Socket!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Configure the view.
		let scene = GameScene(size: self.view.bounds.size)
		scene.backgroundColor = .white
		do {
			socket = try Socket(address: "134.190.152.11", port: 7777)
			scene.socket = socket
			try socket.read {
				guard let info = $0 else { return }
				print(info)
			}
		} catch {
			print("Connection Error")
		}
		if let skView = self.view as? SKView {
			
			skView.showsFPS = true
			skView.showsNodeCount = true
			/* Sprite Kit applies additional optimizations to improve rendering performance */
			skView.ignoresSiblingOrder = true
			/* Set the scale mode to scale to fit the window */
			//scene.scaleMode = .AspectFill
			skView.presentScene(scene)
		}
	}
	@IBAction func longPressToSetIP(_ sender: UILongPressGestureRecognizer) {
		let alert = UIAlertController(title: "Connect to another IP", message: nil, preferredStyle: .alert)
		alert.addTextField(configurationHandler: nil)
		let confirm = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
			guard let textField = alert.textFields?.first, let text = textField.text else { return }
			self?.socket = try? Socket(address: text, port: 7777)
		}
		alert.addAction(confirm)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alert, animated: true, completion: nil)
	}
	
	@IBAction func actionButtonPressed(_ sender: UIButton) {
		let command = String(sender.tag)
		do {
			try socket.write(value: command)
		} catch {
			print("Error")
		}
	}
	override var shouldAutorotate : Bool {
		return true
	}
	
	override var supportedInterfaceOrientations : UIInterfaceOrientationMask  {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return UIInterfaceOrientationMask.allButUpsideDown
		} else {
			return UIInterfaceOrientationMask.all
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
	
	override var prefersStatusBarHidden : Bool {
		return true
	}
}
