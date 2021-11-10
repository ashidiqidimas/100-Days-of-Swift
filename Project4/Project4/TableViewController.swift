//
//  TableViewController.swift
//  Project4
//
//  Created by Dimas on 15/08/21.
//

import UIKit

class TableViewController: UITableViewController {
	
	var allowedWebsites = ["apple.com", "hackingwithswift.com"]
	var websites = ["apple.com", "hackingwithswift.com", "facebook.com"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Websites"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "Custom Cell")
		
		tableView.separatorStyle = .none
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return websites.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "Custom Cell", for: indexPath) as? CustomTableViewCell {
			cell.websiteLabel.text = websites[indexPath.row]
			
			return cell
		} else {
			return UITableViewCell()
		}
		
	}
	
	// MARK: - Table View Delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("clicked")
		if let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
			vc.selected = indexPath.row
			navigationController?.pushViewController(vc, animated: true)
		}
		
	}
	
}
