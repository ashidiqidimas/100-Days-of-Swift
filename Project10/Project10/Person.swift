//
//  Person.swift
//  Project10
//
//  Created by Dimas on 08/09/21.
//

import UIKit

class Person: NSObject {
	var name: String
	var imageString: String
	
	init(name: String, imageString: String) {
		self.name = name
		self.imageString = imageString
	}
}
