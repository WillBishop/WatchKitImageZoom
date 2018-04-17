//
//  InterfaceController.swift
//  scrolltest WatchKit Extension
//
//  Created by Will Bishop on 9/2/18.
//  Copyright © 2018 Will Bishop. All rights reserved.
//

import WatchKit
import Foundation
import SpriteKit


class InterfaceController: WKInterfaceController, WKCrownDelegate {

	var zoomLevel: CGFloat = 1
	
	var previous = CGPoint()
	
	@IBOutlet var skInterface: WKInterfaceSKScene!
	let cameraNode = SKCameraNode()
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		let scene = SKScene(fileNamed: "MyScene")
		
		cameraNode.position = CGPoint(x: WKInterfaceDevice.current().screenBounds.width / 2, y: WKInterfaceDevice.current().screenBounds.height / 2)
		scene?.addChild(cameraNode)
		scene?.camera = cameraNode
		// Present the scene
		self.skInterface.presentScene(scene)
		
		// Use a preferredFramesPerSecond that will maintain consistent frame rate
		self.skInterface.preferredFramesPerSecond = 30
		
		crownSequencer.delegate = self
		
        // Configure interface objects here.
	}
	
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		
		crownSequencer.focus()
    }
	
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
	}
	
	
	@IBAction func didPan(_ sender: WKPanGestureRecognizer) {
		
		
		var translation = sender.translationInObject()
		
		translation.x *= -1 //Panning to the right would make it go left, need to * -1
		translation.x = translation.x * cameraNode.xScale
		translation.y = translation.y * cameraNode.yScale
		print(previous)
		print(translation)
		
		print(translation.x - self.previous.x)
		
		
		let mov = SKAction.moveBy(x: translation.x - self.previous.x, y: translation.y - self.previous.y, duration: 0)
		cameraNode.run(mov)
		self.previous = translation
		
	}
	func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
		print(zoomLevel)
		if rotationalDelta < 0{
			zoomLevel += 0.01
			let zoomInAction = SKAction.scale(to: zoomLevel, duration: 0)
			cameraNode.run(zoomInAction)
		}
		if rotationalDelta > 0{
			zoomLevel -= 0.01
			let zoomInAction = SKAction.scale(to: zoomLevel, duration: 0)
			cameraNode.run(zoomInAction)
		}
		
	}
	
	
}
extension CGPoint{
	static func +=(left: CGPoint, right: CGPoint) -> CGPoint{
		var copy = left
		copy.x += right.x
		copy.y += right.y
		return copy
	}
	static func -=(left: CGPoint, right: CGPoint) -> CGPoint{
		var copy = left
		copy.x -= right.x
		copy.y -= right.y
		return copy
	}
	static func -(left: CGPoint, right: CGPoint) -> CGPoint{
		var copy = left
		copy.x -= right.x
		copy.y -= right.y
		return copy
	}
	static func +(left: CGPoint, right: CGPoint) -> CGPoint{
		var copy = left
		copy.x += right.x
		copy.y += right.y
		return copy
	}
}
