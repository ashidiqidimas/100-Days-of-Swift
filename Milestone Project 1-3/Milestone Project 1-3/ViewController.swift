//
//  ViewController.swift
//  Milestone Project 1-3
//
//  Created by Dimas on 11/08/21.
//

import UIKit

class ViewController: UITableViewController {
	
	var countries = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.title = "Countries"
		
		tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
		
		let fm = FileManager()
		let path = Bundle.main.resourcePath!
		let items = try! fm.contentsOfDirectory(atPath: path)
		
		for item in items {
			if item.hasSuffix("png") {
				countries.append(item)
			}
		}
		
		countries.sort()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		countries.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell {
			let country = countries[indexPath.row]
			cell.countryImageView.image = UIImage(named: country)
			var countryStr = country
			countryStr.removeLast(4)
			cell.countryLabel.text = countryStr
			
//			cell.layer.cornerRadius = 20
//			cell.layer.masksToBounds = true
			
			return cell
		} else {
			return UITableViewCell()
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
			vc.imageToLoad = countries[indexPath.row]
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
}

