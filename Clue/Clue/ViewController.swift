//
//  ViewController.swift
//  Clue
//
//  Created by Adam Evans on 11/27/15.
//  Copyright © 2015 Kijug Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
	
	// =============================================================================
	//								UI stuff
	// =============================================================================
	
	@objc func newGame(_ sender:AnyObject)
	{
		self.performSegue(withIdentifier: "MenuToInputNames", sender:self)
	}
	
	// =============================================================================
	//							ViewController stuff
	// =============================================================================
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let WIDTH = self.view.frame.size.width
		let HEIGHT = self.view.frame.size.height
		let TITLE_FONT_SIZE:CGFloat = 50
		let PADDING:CGFloat = TITLE_FONT_SIZE / 2
		let BUTTON_WIDTH:CGFloat = 3 * WIDTH / 4
		let BUTTON_HEIGHT:CGFloat = 50
		
		// create the title label
		let title = UILabel()
		title.text = "Menu"
		title.font = UIFont.systemFont(ofSize:TITLE_FONT_SIZE)
		title.sizeToFit()
		title.center = CGPoint(x: WIDTH / 2, y: PADDING + (title.frame.size.height / 2))
		self.view.addSubview(title)
		
		// create the new game button
		let button = MyUtilities.buttonWithSize(size:CGSize(width: BUTTON_WIDTH, height: BUTTON_HEIGHT))
		button.center = CGPoint(x: WIDTH / 2, y: HEIGHT / 2)
		button.setTitleColor(UIColor.white, for:UIControlState())
		button.setTitle("New Game", for:UIControlState())
		button.addTarget(self, action:#selector(ViewController.newGame(_:)), for:.touchUpInside)
		self.view.addSubview(button)
	}
	
	// =============================================================================
	
	override var prefersStatusBarHidden : Bool
	{
		return true
	}
	
	// =============================================================================
	
}

















