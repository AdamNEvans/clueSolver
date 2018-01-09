//
//  Guess.swift
//  Clue
//
//  Created by Adam Evans on 11/27/15.
//  Copyright © 2015 Kijug Software. All rights reserved.
//

import Foundation

class Guess : NSCoding
{
	// General Info:
	// 1. Guesses with at least one owned card are not considered (the player could have shown the owned card).
	// 2. `unknowns` contains all the "unknown" cards in the guess
	var person:Card			// person guessed
	var weapon:Card			// weapon guessed
	var room:Card			// room guessed
	var unknowns:[Card]		// the possible cards that the player could own (all cards with unknown state)
	var type:GuessType		// what was shown (secret if unknown)
	var player:Int			// who showed something 
	
	var description:String
	{
		get
		{
			return "player \(player), \(type.description): \(PEOPLE[person.rawValue]) \(WEAPONS[weapon.rawValue]) \(ROOMS[room.rawValue])"
		}
	}
	
	// =============================================================================
	//								Initializers
	// =============================================================================
	
	init(inPerson:Card, inWeapon:Card, inRoom:Card, inType:GuessType, inPlayer:Int)
	{
		person = inPerson
		weapon = inWeapon
		room = inRoom
		unknowns = [person, weapon, room]
		type = inType
		player = inPlayer
	}
	
	// =============================================================================
	
	required init?(coder aDecoder: NSCoder)
	{
		guard let inPerson = Card(rawValue:Int(aDecoder.decodeInt64(forKey:"person"))) else { return nil }
		guard let inWeapon = Card(rawValue:Int(aDecoder.decodeInt64(forKey:"weapon"))) else { return nil }
		guard let inRoom = Card(rawValue:Int(aDecoder.decodeInt64(forKey:"room"))) else { return nil }
		guard let inUnknowns = aDecoder.decodeObject(forKey:"unknowns") as? [Card] else { return nil }
		guard let inType = GuessType(rawValue:Int(aDecoder.decodeInt64(forKey:"type"))) else { return nil }
		
		person = inPerson
		weapon = inWeapon
		room = inRoom
		unknowns = inUnknowns
		type = inType
		player = Int(aDecoder.decodeInt64(forKey:"player"))
	}
	
	// =============================================================================
	
	func encode(with aCoder: NSCoder)
	{
		aCoder.encode(person, forKey:"person")
		aCoder.encode(weapon, forKey:"weapon")
		aCoder.encode(room, forKey:"room")
		aCoder.encode(unknowns, forKey:"unknowns")
		aCoder.encode(type, forKey:"type")
		aCoder.encode(player, forKey:"player")
	}
	
	// =============================================================================
}
