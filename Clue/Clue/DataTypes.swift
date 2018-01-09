//
//  DataTypes.swift
//  Clue
//
//  Created by Adam Evans on 12/22/17.
//  Copyright © 2017 Kijug Software. All rights reserved.
//

import Foundation


enum Status:Int
{
	case owned
	case unowned
	case unknown
}


enum GuessType:Int, CustomStringConvertible
{
	case person = 0
	case weapon = 1
	case room	= 2
	case secret = 3
	case pass	= 4
	
	var description:String
	{
		switch (self)
		{
			case .person:	return "Person"
			case .weapon:	return "Weapon"
			case .room:		return "Room"
			case .secret:	return "Secret"
			case .pass:		return "Pass"
		}
	}
}

