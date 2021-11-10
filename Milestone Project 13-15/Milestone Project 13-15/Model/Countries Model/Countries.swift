//
//  Countries.swift
//  Milestone Project 13-15
//
//  Created by Dimas on 04/11/21.
//

import Foundation

struct Countries: Codable {
	let error: Bool
	let msg: String
	let data: [Country]
}
