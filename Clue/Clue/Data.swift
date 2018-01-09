//
//  Data.swift
//  Clue
//
//  Created by Adam Evans on 11/27/15.
//  Copyright © 2015 Kijug Software. All rights reserved.
//

import UIKit


let MAX_PLAYERS = 6
let NUM_CARDS = 21
let NUM_PEOPLE = 6
let NUM_WEAPONS = 6
let NUM_ROOMS = 9
let PEOPLE = ["Col. Mustard", "Prof. Plum", "Mr. Green", "Mrs. Peacock", "Miss Scarlet", "Mrs. White"]
let WEAPONS = ["Knife", "Candlestick", "Revolver", "Rope", "Lead Pipe", "Wrench"]
let ROOMS = ["Hall", "Lounge", "Dining Room", "Kitchen", "Ball room", "Conservatory", "Billiard Room", "Library", "Study"]
let CARD_NAMES = ["Col. Mustard", "Prof. Plum", "Mr. Green", "Mrs. Peacock", "Miss Scarlet", "Mrs. White",
                  "Knife", "Candlestick", "Revolver", "Rope", "Lead Pipe", "Wrench",
                  "Hall", "Lounge", "Dining Room", "Kitchen", "Ball room", "Conservatory", "Billiard Room", "Library", "Study"]


var data = Data()


class Data : NSCoding
{
	var numPlayers:Int
	var names:[String]
	var guesses:[Guess]
	var info:[[Status]]		// info[player][card] = status of card in relation to the given player
	var counts:[Int]		// number of cards owned per player
	var confidentials:[CardGroup:Card]		// which card is confidential for each group, or nil
	
	// =============================================================================
	//								Initializers
	// =============================================================================
	
	init()
	{
		numPlayers = 0
		names = [String]()
		guesses = [Guess]()
		info = [[Status]]()
		counts = [Int]()
		confidentials = [CardGroup:Card]()
	}
	
	// =============================================================================
	
	required init?(coder decoder: NSCoder)
	{
		guard let nameList = decoder.decodeObject(forKey:"names") as? [String] else { return nil }
		guard let guessList = decoder.decodeObject(forKey:"guesses") as? [Guess] else { return nil }
		guard let infoObj = decoder.decodeObject(forKey:"info") as? [[Status]] else { return nil }
		guard let countList = decoder.decodeObject(forKey:"counts") as? [Int] else { return nil }
		guard let confidentialList = decoder.decodeObject(forKey:"confidentials") as? [CardGroup:Card] else { return nil }
		
		numPlayers = Int(decoder.decodeInt64(forKey:"numPlayers"))
		names = nameList
		guesses = guessList
		info = infoObj
		counts = countList
		confidentials = confidentialList
	}
	
	// =============================================================================
	
	func encode(with coder: NSCoder)
	{
		coder.encode(numPlayers, forKey:"numPlayers")
		coder.encode(names, forKey:"names")
		coder.encode(guesses, forKey:"guesses")
		coder.encode(info, forKey:"info")
		coder.encode(counts, forKey:"counts")
		coder.encode(confidentials, forKey:"confidentials")
	}
	
	// =============================================================================
	//								Normal Functions
	// =============================================================================
	
	func newGame(_ players:[String])
	{
		numPlayers = players.count
		names = players
		guesses = [Guess]()
		counts = [Int]()
		info = [[Status]]()
		confidentials = [CardGroup:Card]()
		
		for _ in 0..<numPlayers
		{
			info.append([Status](repeating: .unknown, count: NUM_CARDS))
		}
	}
	
	// =============================================================================
	
	func setCounts(_ inCounts:[Int])
	{
		counts = inCounts
	}
	
	// =============================================================================
	
	func submit(_ guess:Guess)
	{
		applyGuess(guess)
		
		if let result = solve2()
		{
			print("ERROR: bad guess = \(result)")
		}
	}
	
	// =============================================================================
	//								Solving Functions
	// =============================================================================
	
	private func applyGuess(_ guess:Guess)
	{
		switch (guess.type)
		{
			case .person: setKnown(guess.player, card:guess.person)
			case .weapon: setKnown(guess.player, card:guess.weapon)
			case .room: setKnown(guess.player, card:guess.room)
			case .secret: guesses.append(guess)
			case .pass:
				info[guess.player][guess.person.rawValue] = .unowned
				info[guess.player][guess.weapon.rawValue] = .unowned
				info[guess.player][guess.room.rawValue] = .unowned
		}
	}
	
	// =============================================================================
	
	private func solve1()
	{
		var recalculate = true
		
		// keep trying to reduce the number of guesses while new information is being found
		while (recalculate)
		{
			// resolve guesses that have two cards Unowned by the showing player in them (player must have shown the third card)
			// remove guesses that have at least one owned card in them (card shown could have been the owned one)
			var i = 0
			
			while (i < guesses.count)
			{
				let guess = guesses[i]
				let one = info[guess.player][guess.person.rawValue]
				let two = info[guess.player][guess.weapon.rawValue]
				let three = info[guess.player][guess.room.rawValue]
				var shouldRemove = false
				
				// remove guesses with owned cards
				if (one == .owned) || (two == .owned) || (three == .owned)
				{
					shouldRemove = true
				}
				// At this point we don't know that this player owns any of the cards, so if there is only one unknown card,
				// then we know this player has to own that card because they had to show something (the other cards have to
				// be unowned because of the above check for ownership)
				else if (one == .unknown) && (two != .unknown) && (three != .unknown)
				{
					setKnown(guess.player, card:guess.person)
					shouldRemove = true
					recalculate = true
				}
				else if (one != .unknown) && (two == .unknown) && (three != .unknown)
				{
					setKnown(guess.player, card:guess.weapon)
					shouldRemove = true
					recalculate = true
				}
				else if (one != .unknown) && (two != .unknown) && (three == .unknown)
				{
					setKnown(guess.player, card:guess.room)
					shouldRemove = true
					recalculate = true
				}
				
				if (shouldRemove)
				{
					guesses.remove(at: i)
				}
				else
				{
					i += 1
				}
			}
		}
	}
	
	// =============================================================================
	// if an impossible situation was detected, returns the guess that is impossible, else nil
	private func solve2() -> Guess?
	{
		var recalculate = false
		var i = 0
		
		// update the guesses
		while (i >= 0) && (i < guesses.count)
		{
			let guess = guesses[i]
			
			// -------------------------------------
			// remove any guesses with an owned card (that card could have been the one shown)
			var j = 0
			var doneWithGuess = false
			
			while (j < guess.unknowns.count)
			{
				if (info[guess.player][guess.unknowns[j].rawValue] == .owned)
				{
					doneWithGuess = true
					break
				}
				
				j += 1
			}
			
			if (doneWithGuess)
			{
				guesses.remove(at: i)
				i -= 1
				recalculate = true
				continue
			}
			
			// -------------------------------------
			// remove any unowned cards from the guesses
			j = 0
			
			while (j < guess.unknowns.count)
			{
				if (info[guess.player][guess.unknowns[j].rawValue] == .unowned)
				{
					guess.unknowns.remove(at:j)
					j -= 1
					recalculate = true
				}
				
				// make sure we have at east one card in the guess
				if (guess.unknowns.count == 0)
				{
					print("ERROR: guess \(guess) could not have happened")
					return guess
				}
				
				j += 1
			}
			
			// -------------------------------------
			// resolve any guesses with just one card
			if (guess.unknowns.count == 1)
			{
				setKnown(guess.player, card:guess.unknowns[0])
			}
			
			// move on to the next guess
			i += 1
		}
		
		// -----------------------------------------
		// if a player has all their cards, set all the player's other cards to unowned
		for j in 0..<numPlayers
		{
			var owned = 0
			
			for k in 0..<NUM_CARDS
			{
				if (info[j][k] == .owned)
				{
					owned += 1
				}
			}
			
			// set all not-owned cards to unowned
			if (owned >= counts[j])
			{
				for k in 0..<NUM_CARDS
				{
					if (info[j][k] != .owned)
					{
						info[j][k] = .unowned
					}
				}
			}
		}
		
		// -----------------------------------------
		// see if we can deduce any confidential cards
		if (deduceConfidentials())
		{
			print("deduced a confidential")
			deduceNonConfidentials()
		}
		
		// -----------------------------------------
		// keep solving while changes are being made
		return (recalculate ? solve2() : nil)
	} 
	
	// =============================================================================
	// Returns true if found a new confidential card
	private func deduceConfidentials() -> Bool
	{
		print("deducing confidentials...")
		let groups = [CardGroup.person.cards(), CardGroup.weapon.cards(), CardGroup.room.cards()]
		var foundConfidential = false
		
		for i in 0..<groups.count
		{
			var unownedCards = [Card]()
			let group = groups[i]
			
			for card in group
			{
				let index = card.rawValue
				var owned = false
				
				for i in 0..<numPlayers
				{
					if (info[i][index] == .owned)
					{
						owned = true
						break
					}
				}
				
				if (!owned)
				{
					unownedCards.append(card)
				}
			}
			
			// if all cards but one are owned, then this one card has to be confidential
//			print("unowned=\(unownedCards)")
			if (unownedCards.count == 1)
			{
				// set this card to be unowned by everyone (instead of either unowned or unknown)
				let card = unownedCards[0].rawValue
				
				for i in 0..<numPlayers
				{
					info[i][card] = .unowned
				}
				
				// set the confidential card for this group
				print("found new confidential via all others owned: \(Card(rawValue:card)!)")
				confidentials[CardGroup(rawValue: i)!] = Card(rawValue:card)!
				foundConfidential = true
			}
			
			// -----------------------------------------
			// check for any cards that are set to unowned for all players
			if (!foundConfidential)
			{
				for card in group
				{
					let index = card.rawValue
					var unowned = true
					
					for i in 0..<numPlayers
					{
						if (info[i][index] != .unowned)
						{
							unowned = false
							break
						}
					}
					
					if (unowned)
					{
						print("found new confidential via nobody owns: \(card)")
						confidentials[CardGroup(rawValue: i)!] = card
						foundConfidential = true
						break
					}
				}
			}
		}
		
		return foundConfidential
	}
	
	// =============================================================================
	// After finding the confidential card in a group, deduce ownership of cards that have all but one unowned
	private func deduceNonConfidentials()
	{
		let groups = [CardGroup.person, CardGroup.weapon, CardGroup.room]
		
		for group in groups
		{
			if let confidential = confidentials[group]
			{
				let cards = group.cards()
				
				// remove the confidential card and all owned cards
				for card in cards
				{
					if (card != confidential)
					{
						// check if the card is not owned and get a list of potential owners
						let cardIndex = card.rawValue
						var owned = false
						var potentialOwners = [Int]()
						potentialOwners.reserveCapacity(numPlayers)
						
						for i in 0..<numPlayers
						{
							if (info[i][cardIndex] == .owned)
							{
								owned = true
								break
							}
							else if (info[i][cardIndex] == .unknown)
							{
								potentialOwners.append(i)
							}
						}
						
						// if nobody owns the card and there is only one potential owner, that player has to own it
						if (!owned) && (potentialOwners.count == 1)
						{
							setKnown(potentialOwners[0], card:card)
						}
					}
				}
			}
		}
	}
	
	// =============================================================================
	
	private func setKnown(_ player:Int, card:Card)
	{
		for i in 0..<numPlayers
		{
			info[i][card.rawValue] = .unowned
		}
		
		info[player][card.rawValue] = .owned
	}
	
	// =============================================================================
	//									Getters
	// =============================================================================
	// Returns false if not guaranteed to be confidential (either unknown if confidential or know to not be)
	// Returns true on when card is guaranteed to be confidential (we know it is confidential)
	func isConfidential(_ card:Card) -> Bool
	{
		let c = card.rawValue
		
		for i in 0..<numPlayers
		{
			if (info[i][c] != .unowned)
			{
				return false
			}
		}
		
		return true
	}
	
	// =============================================================================
	// Returns the index of the player that owns the card
	// Returns -1 if no owner (confidential or unknown owner)
	func ownerForCard(_ card:Card) -> Int
	{
		let cardIndex = card.rawValue
		var i = 0
		
		while (i < numPlayers)
		{
			if (info[i][cardIndex] == .owned)
			{
				return i
			}
			
			i += 1
		}
		
		return -1
	}
	
	// =============================================================================
}

















