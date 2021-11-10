//
//  Network.swift
//  Milestone Project 13-15
//
//  Created by Dimas on 27/10/21.
//

import Foundation

class Network {
	static func requestCountries(completionHandler: @escaping (Countries?) -> Void) throws {
		guard let url = URL(string: "https://countriesnow.space/api/v0.1/countries/flag/images") else {
			throw NetworkError.invalidURL
		}
		
		DispatchQueue.global(qos: .userInitiated).async {
			let request = URLRequest(url: url)
			
			let task = URLSession.shared.dataTask(with: request) { data, response, error in
				guard let data = data, error == nil else { return }
				
				var result: Countries?
				do {
					try result = JSONDecoder().decode(Countries.self, from: data)
				} catch {
					print(error)
				}
				
				DispatchQueue.main.async {
					completionHandler(result)
				}
			}
			task.resume()
		}

	}
}
