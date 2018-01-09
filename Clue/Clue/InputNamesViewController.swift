//
//  InputNamesViewController.swift
//  Clue
//
//  Created by Adam Evans on 11/27/15.
//  Copyright © 2015 Kijug Software. All rights reserved.
//

import UIKit

class InputNamesViewController: UIViewController, UITextFieldDelegate
{
	// =============================================================================
	//								UI stuff
	// =============================================================================
	
	@objc func back(_ sender:AnyObject)
	{
		let _ = self.navigationController?.popViewController(animated: true)
	}
	
	// =============================================================================
	
	@objc func next(_ sender:AnyObject)
	{
		// TODO: throw up alert if there isn't at least one name
		
		var names = [String]()
		
		for i in 0..<MAX_PLAYERS
		{
			if let text = (self.view.viewWithTag(i+1) as? UITextField)?.text
			{
				if (text != "")
				{
					names.append(text)
				}
			}
		}
		
		data.newGame(names)
		self.performSegue(withIdentifier: "InputNamesToInputCards", sender:self)
	}
	
	// =============================================================================
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		return false
	}
	
	// =============================================================================
	//							ViewController stuff
	// =============================================================================
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
		let WIDTH = self.view.frame.size.width
		let HEIGHT = self.view.frame.size.height
		let PADDING:CGFloat = 10
		let TITLE_FONT_SIZE:CGFloat = 40
		let BUTTON_WIDTH:CGFloat = (WIDTH - (3 * PADDING)) / 2
		let BUTTON_HEIGHT:CGFloat = 50
		
		// create the title label
		let title = UILabel()
		title.text = "Players"
		title.font = UIFont.systemFont(ofSize: TITLE_FONT_SIZE)
		title.sizeToFit()
		title.center = CGPoint(x: WIDTH / 2, y: (2 * PADDING) + (title.frame.size.height / 2))
		self.view.addSubview(title)
		
		// create the name input fields
		let NAME_X = 2 * PADDING
		let FIELD_X = WIDTH / 3
		let START_Y = title.frame.maxY + (4 * PADDING)
		let PLAYER_HEIGHT:CGFloat = 50
		
		for i in 0..<MAX_PLAYERS
		{
			let name = UILabel()
			name.text = "Player \(i+1):"
			name.sizeToFit()
			name.frame.origin = CGPoint(x: NAME_X, y: START_Y + (CGFloat(i) * PLAYER_HEIGHT))
			self.view.addSubview(name)
			
			let fieldFrame = CGRect(x: FIELD_X, y: 0, width: (WIDTH - FIELD_X) - (2 * PADDING), height: 40)
			let field = UITextField(frame:fieldFrame)
			field.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
			field.borderStyle = .roundedRect
			field.center.y = name.center.y
			field.delegate = self
			field.isHidden = false
			field.tag = i+1
			self.view.addSubview(field)
		}
		
		// create the back button
		let backButton = MyUtilities.buttonWithSize(size:CGSize(width: BUTTON_WIDTH, height: BUTTON_HEIGHT))
		backButton.setTitle("Back", for:.normal)
		backButton.frame.origin = CGPoint(x:PADDING, y:HEIGHT - (PADDING + BUTTON_HEIGHT))
		backButton.setTitleColor(UIColor.white, for:UIControlState())
		backButton.addTarget(self, action:#selector(InputCardsViewController.back(_:)), for:.touchUpInside)
		self.view.addSubview(backButton)
		
		// create the next button
		let nextButton = MyUtilities.buttonWithSize(size:CGSize(width: BUTTON_WIDTH, height: BUTTON_HEIGHT))
		nextButton.frame.origin = CGPoint(x:(WIDTH + PADDING) / 2, y:HEIGHT - (PADDING + BUTTON_HEIGHT))
		nextButton.setTitleColor(UIColor.white, for:.normal)
		nextButton.setTitle("Next", for:UIControlState())
		nextButton.addTarget(self, action:#selector(InputCardsViewController.next(_:)), for:.touchUpInside)
		self.view.addSubview(nextButton)
    }
	
	// =============================================================================
	
	override var prefersStatusBarHidden : Bool
	{
		return true
	}
	
	// =============================================================================
}












