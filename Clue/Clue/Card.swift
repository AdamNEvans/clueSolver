//
//  Card.swift
//  Clue
//
//  Created by Adam Evans on 12/23/17.
//  Copyright © 2017 Kijug Software. All rights reserved.
//

import Foundation


enum CardGroup:Int
{
	case person = 0
	case weapon = 1
	case room = 2
	
	func cards() -> [Card]
	{
		switch (self)
		{
			case .person:	return [.mustard, .plum, .green, .peacock, .scarlett, .white]
			case .weapon:	return [.knife, .candlestick, .revolver, .rope, .leadPipe, .wrench]
			case .room:		return [.hall, .lounge, .diningRoom, .kitchen, .ballRoom, .conservatory, .billiardRoom, .library, .study]
		}
	}
}


enum Card:Int, CustomStringConvertible
{
	case mustard = 0
	case plum = 1
	case green = 2
	case peacock = 3
	case scarlett = 4
	case white = 5
	
	case knife = 6
	case candlestick = 7
	case revolver = 8
	case rope = 9
	case leadPipe = 10
	case wrench = 11
	
	case hall = 12
	case lounge = 13
	case diningRoom = 14
	case kitchen = 15
	case ballRoom = 16
	case conservatory = 17
	case billiardRoom = 18
	case library = 19
	case study = 20
	
	var description: String
	{
		switch (self)
		{
			case .mustard:		return "Mustard"
			case .plum:			return "Plum"
			case .green:		return "Green"
			case .peacock:		return "Peacock"
			case .scarlett:		return "Scarlett"
			case .white:		return "White"
				
			case .knife:		return "Knife"
			case .candlestick:	return "Candlestick"
			case .revolver:		return "Revolver"
			case .rope:			return "Rope"
			case .leadPipe:		return "Lead Pipe"
			case .wrench:		return "Wrench"
				
			case .hall:			return "Hall"
			case .lounge:		return "Lounge"
			case .diningRoom:	return "Dining Room"
			case .kitchen:		return "Kitchen"
			case .ballRoom:		return "Ball Room"
			case .conservatory:	return "Conservatory"
			case .billiardRoom:	return "Billiard Room"
			case .library:		return "Library"
			case .study:		return "Study"
		}
	}
	
	var group:CardGroup
	{
		switch (self)
		{
			case .mustard:		return .person
			case .plum:			return .person
			case .green:		return .person
			case .peacock:		return .person
			case .scarlett:		return .person
			case .white:		return .person
				
			case .knife:		return .weapon
			case .candlestick:	return .weapon
			case .revolver:		return .weapon
			case .rope:			return .weapon
			case .leadPipe:		return .weapon
			case .wrench:		return .weapon
				
			case .hall:			return .room
			case .lounge:		return .room
			case .diningRoom:	return .room
			case .kitchen:		return .room
			case .ballRoom:		return .room
			case .conservatory:	return .room
			case .billiardRoom:	return .room
			case .library:		return .room
			case .study:		return .room
		}
	}
}

