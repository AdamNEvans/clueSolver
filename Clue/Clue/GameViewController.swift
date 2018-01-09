//
//  GameViewController.swift
//  Clue
//
//  Created by Adam Evans on 11/27/15.
//  Copyright © 2015 Kijug Software. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDataSource
{
	fileprivate var personLabel:UILabel!
	fileprivate var weaponLabel:UILabel!
	fileprivate var roomLabel:UILabel!
	
	fileprivate var personSelector:UIStepper!
	fileprivate var weaponSelector:UIStepper!
	fileprivate var roomSelector:UIStepper!
	fileprivate var knowledgeSelector:UISegmentedControl!			//person, weapon, room, at least one, or none
	fileprivate var playerSelector:UISegmentedControl!
	
	fileprivate var table:UITableView!
	
	// =============================================================================
	//							UItableView stuff
	// =============================================================================
	
	func numberOfSections(in tableView: UITableView) -> Int
	{
		return 3
	}
	
	// =============================================================================
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		switch (section)
		{
			case 0: return 6
			case 1: return 6
			default: return 9
		}
	}
	
	// =============================================================================
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	{
		switch (section)
		{
			case 0: return "People"
			case 1: return "Weapons"
			default: return "Rooms"
		}
	}
	
	// =============================================================================
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = UITableViewCell()
		let card:Int
		var text:String
		
		// set the section sensitive variables
		switch (indexPath.section)
		{
			case 0: card = indexPath.row
					text = PEOPLE[card]
			
			case 1: card = indexPath.row + NUM_PEOPLE
					text = WEAPONS[indexPath.row]
			
			default: card = indexPath.row + NUM_PEOPLE + NUM_WEAPONS
					text = ROOMS[indexPath.row]
		}
		
		// pad the card name with spaces for even alignment
		let NAME_SIZE = 13
		let numSpaces = NAME_SIZE - text.count
		let SPACING = "  "
		
		for _ in 0..<numSpaces
		{
			text = "\(text) "
		}
		
		// add the values for each card and player
		if (data.isConfidential(Card(rawValue: card)!))
		{
			text = "\(text)\(SPACING)CONFIDENTIAL"
		}
		else
		{
			for i in 0..<data.numPlayers
			{
				let status = data.info[i][card]
				let char:String
				
				switch (status)
				{
					case .owned: char = "Y"
					case .unowned: char = "N"
					case .unknown: char = "-"
				}
				
				text = "\(text)\(SPACING)\(char)"
			}
		}
		
		// set the cell properties
		cell.textLabel?.font = UIFont(name:"Courier", size:15)
		cell.textLabel?.text = text
		cell.selectionStyle = .none
		
		return cell
	}
	
	// =============================================================================
	//								UI stuff
	// =============================================================================
	
	@objc func back(_ sender:AnyObject)
	{
		self.navigationController?.popViewController(animated:true)
	}
	
	// =============================================================================
	
	@objc func submitKnowledge(_ sender:AnyObject)
	{
		print("=============================================")
		print("submitting knowledge:")
		guard let person = Card(rawValue: Int(personSelector.value)) else { return }
		guard let weapon = Card(rawValue: Int(weaponSelector.value)) else { return }
		guard let room = Card(rawValue: Int(roomSelector.value)) else { return }
		guard let type = GuessType(rawValue: knowledgeSelector.selectedSegmentIndex) else { return }
		let player = playerSelector.selectedSegmentIndex
		
		print("  person=\(person)")
		print("  weapon=\(weapon)")
		print("  room=\(room)")
		print("  type=\(type)")
		print("  player=\(player)")
		
		let guess = Guess(inPerson:person, inWeapon:weapon, inRoom:room, inType:type, inPlayer:player)
		
		data.submit(guess)
		table.reloadData()
	}
	
	// =============================================================================
	
	@objc func personChanged(_ sender:AnyObject)
	{
		updateLabel(personLabel, from:sender)
	}
	
	// =============================================================================
	
	@objc func weaponChanged(_ sender:AnyObject)
	{
		updateLabel(weaponLabel, from:sender)
	}
	
	// =============================================================================
	
	@objc func roomChanged(_ sender:AnyObject)
	{
		updateLabel(roomLabel, from:sender)
	}
	
	// =============================================================================
	
	func updateLabel(_ label:UILabel, from obj:AnyObject)
	{
		if let stepper = obj as? UIStepper
		{
			label.text = CARD_NAMES[Int(stepper.value)]
		}
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
		
		let LABEL_X = PADDING
		let VALUE_X = WIDTH / 4
		let STEPPER_X = 2 * WIDTH / 3
		let CARD_ENTRY_HEIGHT:CGFloat = 40
		
		let scrollview = UIScrollView(frame:self.view.frame)
		let contentView = UIView()
		contentView.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width * 2, height: self.view.frame.size.height)
		
		// =======================================
		// create the title label
		let title = UILabel()
		title.text = "Enter Guesses"
		title.font = UIFont.systemFont(ofSize:TITLE_FONT_SIZE)
		title.sizeToFit()
		title.center = CGPoint(x: WIDTH / 2, y: (2 * PADDING) + (title.frame.size.height / 2))
		contentView.addSubview(title)
		
		let CARD_START_Y:CGFloat = title.frame.maxY + (2 * PADDING)
		
		// =======================================
		// Person fields
		var cardLabel = UILabel()
		cardLabel.text = "Person:"
		cardLabel.sizeToFit()
		cardLabel.frame.origin = CGPoint(x: LABEL_X, y: CARD_START_Y)
		contentView.addSubview(cardLabel)
		
		personLabel = UILabel()
		personLabel.text = PEOPLE[0]
		personLabel.sizeToFit()
		personLabel.frame.size.width = STEPPER_X - VALUE_X
		personLabel.frame.origin = CGPoint(x: VALUE_X, y: 0)
		personLabel.center.y = cardLabel.center.y
		contentView.addSubview(personLabel)
		
		personSelector = UIStepper()
		personSelector.value = 0
		personSelector.minimumValue = 0
		personSelector.maximumValue = Double(PEOPLE.count) - 1
		personSelector.wraps = false
		personSelector.frame.origin = CGPoint(x: STEPPER_X, y: 0)
		personSelector.center.y = cardLabel.center.y
		personSelector.addTarget(self, action:#selector(GameViewController.personChanged(_:)), for:.valueChanged)
		contentView.addSubview(personSelector)
		
		// =======================================
		// weapon fields
		cardLabel = UILabel()
		cardLabel.text = "Weapon:"
		cardLabel.sizeToFit()
		cardLabel.frame.origin = CGPoint(x: LABEL_X, y: CARD_START_Y + CARD_ENTRY_HEIGHT)
		contentView.addSubview(cardLabel)
		
		weaponLabel = UILabel()
		weaponLabel.text = WEAPONS[0]
		weaponLabel.sizeToFit()
		weaponLabel.frame.size.width = STEPPER_X - VALUE_X
		weaponLabel.frame.origin = CGPoint(x: VALUE_X, y: 0)
		weaponLabel.center.y = cardLabel.center.y
		contentView.addSubview(weaponLabel)
		
		weaponSelector = UIStepper()
		weaponSelector.value = Double(PEOPLE.count)
		weaponSelector.minimumValue = Double(PEOPLE.count)
		weaponSelector.maximumValue = Double(CARD_NAMES.count - ROOMS.count) - 1
		weaponSelector.wraps = false
		weaponSelector.frame.origin = CGPoint(x: STEPPER_X, y: 0)
		weaponSelector.center.y = cardLabel.center.y
		weaponSelector.addTarget(self, action:#selector(GameViewController.weaponChanged(_:)), for:.valueChanged)
		contentView.addSubview(weaponSelector)
		
		// =======================================
		// room fields
		cardLabel = UILabel()
		cardLabel.text = "Room:"
		cardLabel.sizeToFit()
		cardLabel.frame.origin = CGPoint(x: LABEL_X, y: CARD_START_Y + (2 * CARD_ENTRY_HEIGHT))
		contentView.addSubview(cardLabel)
		
		roomLabel = UILabel()
		roomLabel.text = ROOMS[0]
		roomLabel.sizeToFit()
		roomLabel.frame.size.width = STEPPER_X - VALUE_X
		roomLabel.frame.origin = CGPoint(x: VALUE_X, y: 0)
		roomLabel.center.y = cardLabel.center.y
		contentView.addSubview(roomLabel)
		
		roomSelector = UIStepper()
		roomSelector.value = Double(CARD_NAMES.count - ROOMS.count)
		roomSelector.minimumValue = Double(CARD_NAMES.count - ROOMS.count)
		roomSelector.maximumValue = Double(CARD_NAMES.count) - 1
		roomSelector.wraps = false
		roomSelector.frame.origin = CGPoint(x: STEPPER_X, y: 0)
		roomSelector.center.y = cardLabel.center.y
		roomSelector.addTarget(self, action:#selector(GameViewController.roomChanged(_:)), for:.valueChanged)
		contentView.addSubview(roomSelector)
		
		// =======================================
		// make the knowledge selector
		knowledgeSelector = UISegmentedControl(items: ["Person", "Weapon", "Room", "Secret", "Pass"])
		knowledgeSelector.center = CGPoint(x: WIDTH / 2, y: roomSelector.frame.origin.y + roomSelector.frame.size.height + CARD_ENTRY_HEIGHT)
		knowledgeSelector.selectedSegmentIndex = 0
		contentView.addSubview(knowledgeSelector)
		
		// =======================================
		// make the player selector
		playerSelector = UISegmentedControl(items:data.names)
		playerSelector.center = CGPoint(x: WIDTH / 2,
			y: knowledgeSelector.frame.origin.y + knowledgeSelector.frame.size.height + CARD_ENTRY_HEIGHT)
		playerSelector.selectedSegmentIndex = 0
		contentView.addSubview(playerSelector)
		
		// =======================================
		// create the back button
		let backButton = MyUtilities.buttonWithSize(size:CGSize(width: BUTTON_WIDTH, height: BUTTON_HEIGHT))
		backButton.setTitle("Back", for:.normal)
		backButton.frame.origin = CGPoint(x:PADDING, y:HEIGHT - (PADDING + BUTTON_HEIGHT))
		backButton.setTitleColor(UIColor.white, for:UIControlState())
		backButton.addTarget(self, action:#selector(InputCardsViewController.back(_:)), for:.touchUpInside)
		contentView.addSubview(backButton)
		
		// create the submit button
		let submitButton = MyUtilities.buttonWithSize(size:CGSize(width: BUTTON_WIDTH, height: BUTTON_HEIGHT))
		submitButton.frame.origin = CGPoint(x:(WIDTH + PADDING) / 2, y:HEIGHT - (PADDING + BUTTON_HEIGHT))
		submitButton.setTitleColor(UIColor.white, for:.normal)
		submitButton.setTitle("Submit", for:.normal)
		submitButton.addTarget(self, action:#selector(GameViewController.submitKnowledge(_:)), for:.touchUpInside)
		contentView.addSubview(submitButton)
		
		
		// =======================================
		// Create the second page of content (displays status of all cards and players to user)
		// =======================================
		let tableFrame = CGRect(x: self.view.frame.origin.x + WIDTH, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
		table = UITableView(frame:tableFrame, style:.grouped)
		table.dataSource = self
		contentView.addSubview(table)
		
		scrollview.addSubview(contentView)
		scrollview.contentSize = CGSize(width: contentView.frame.size.width, height: contentView.frame.size.height)
		scrollview.isPagingEnabled = true
		self.view.addSubview(scrollview)
		
		table.reloadData()
    }
	
	// =============================================================================
	
	override var prefersStatusBarHidden : Bool
	{
		return true
	}
	
	// =============================================================================
}
















