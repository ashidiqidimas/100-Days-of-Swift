//
//  ViewController.swift
//  Project1
//
//  Created by Dimas on 03/08/21.
//

import UIKit

class ViewController: UITableViewController {
	
	var pictures = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Storm Viewer"
		self.navigationController?.navigationBar.prefersLargeTitles = true
		
		loadPictures()
	}
	
	func loadPictures() {
		let fm =  FileManager.default
		if let path = Bundle.main.resourcePath,
		   let items = try? fm.contentsOfDirectory(atPath: path) {
			
			
			for item in items {
				if item.hasPrefix("nssl") {
					pictures.append(item)
				}
			}
			
			tableView.performSelector(onMainThread: #selector(tableView.reloadData), with: nil, waitUntilDone: false)
		}
		
	}
	
	// MARK: - TableView Data Source
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		pictures.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		let pictureStr = pictures[indexPath.count]
		cell.textLabel?.text = pictureStr
		
		return cell
	}
	
	// MARK: - TableView Delegates
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController  {
			vc.selectedImage = pictures[indexPath.row]
			vc.atPosition = indexPath.row
			vc.picturesLength = pictures.count
			
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}

}

