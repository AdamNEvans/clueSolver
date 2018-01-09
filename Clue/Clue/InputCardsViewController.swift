//
//  InputCardsViewController.swift
//  Clue
//
//  Created by Adam Evans on 11/27/15.
//  Copyright © 2015 Kijug Software. All rights reserved.
//

import UIKit


class InputCardsViewController: UIViewController
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
		var counts = [Int]()
		
		for i in 0..<data.numPlayers
		{
			if let stepper = (self.view.viewWithTag(i+1) as? UIStepper)
			{
				counts.append(Int(stepper.value))
			}
		}
		
		data.setCounts(counts)
		self.performSegue(withIdentifier: "InputCardsToGame", sender:self)
	}
	
	// =============================================================================
	
	@objc func updateCounter(_ sender:AnyObject)
	{
		let stepper = sender as! UIStepper
		let label = self.view.viewWithTag(stepper.tag + 10) as! UILabel
		label.text = "\(Int(stepper.value))"
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
		let BUTTON_WIDTH:CGFloat = (WIDTH - (3 * PADDING)) / 2
		let BUTTON_HEIGHT:CGFloat = 50
		let TITLE_FONT_SIZE:CGFloat = 40

		// create the title label
		let title = UILabel()
		title.text = "Card Counts"
		title.font = UIFont.systemFont(ofSize:TITLE_FONT_SIZE)
		title.sizeToFit()
		title.center = CGPoint(x: WIDTH / 2, y: (2 * PADDING) + (title.frame.size.height / 2))
		self.view.addSubview(title)
		
		// create the name input fields
		let NAME_X = 2 * PADDING
		let COUNT_X = WIDTH / 3
		let STEPPER_X = WIDTH / 2
		let START_Y = title.frame.origin.y + title.frame.size.height + (2 * PADDING)
		let PLAYER_HEIGHT:CGFloat = 40
		
		for i in 0..<data.numPlayers
		{
			let name = UILabel()
			name.text = data.names[i]
			name.sizeToFit()
			name.frame.origin = CGPoint(x: NAME_X, y: START_Y + (CGFloat(i) * PLAYER_HEIGHT))
			self.view.addSubview(name)
			
			let valueLabel = UILabel()
			valueLabel.text = "0"
			valueLabel.sizeToFit()
			valueLabel.frame.origin.x = COUNT_X
			valueLabel.center.y = name.center.y
			valueLabel.tag = 10 + (i+1)
			self.view.addSubview(valueLabel)
			
			let counter = UIStepper()
			counter.frame.origin.x = STEPPER_X
			counter.center.y = name.center.y
			counter.maximumValue = 18
			counter.minimumValue = 0
			counter.stepValue = 1
			counter.tag = i+1
			counter.addTarget(self, action:#selector(InputCardsViewController.updateCounter(_:)), for:.valueChanged)
			self.view.addSubview(counter)
			
			// TODO: change the max values on the steppers to never go over the max
			// by taking into account the values of the other steppers (sum of numbers must equal 18)
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
}
