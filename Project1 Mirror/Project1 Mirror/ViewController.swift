//
//  ViewController.swift
//  Project1 Mirror
//
//  Created by Dimas on 04/08/21.
//

import UIKit

class ViewController: UITableViewController {
	var pictures = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let fm = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fm.contentsOfDirectory(atPath: path)
		
		for item in items {
			if item.hasPrefix("nssl") {
				pictures.append(item)
			}
		}
		
		print(pictures, pictures.count)
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		pictures.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = pictures[indexPath.row]
		return cell
	}
	
}

