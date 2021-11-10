//
//  ViewController.swift
//  Project7
//
//  Created by Dimas on 22/08/21.
//

import UIKit

class ViewController: UITableViewController {
	
	var petitions = [Petition]()
	var displayedPetitions = [Petition]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Petitions"
		
		let filterBtn = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
		let resetBtn = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
		let creditBtn = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(creditTapped))
		
		navigationItem.rightBarButtonItems = [filterBtn, resetBtn, creditBtn]
		
		if navigationController?.tabBarItem.tag == 0 {
			fetch(from: "https://www.hackingwithswift.com/samples/petitions-1.json")
		} else {
			fetch(from: "https://www.hackingwithswift.com/samples/petitions-2.json")
		}
	}
	
	func reload(_ tableView: UITableView, animate: Bool) {
		if animate {
			let range = NSMakeRange(0, tableView.numberOfSections)
			let sections = NSIndexSet(indexesIn: range)
			tableView.reloadSections(sections as IndexSet, with: .automatic)
		} else {
			tableView.reloadData()
		}
	}
	
	@objc func resetTapped() {
		displayedPetitions = petitions
		reload(tableView, animate: true)
	}
	
	@objc func filterTapped() {
		let ac = UIAlertController(title: "Enter filter words", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		let submitFilter = UIAlertAction(title: "Submit", style: .default) { [self] _ in
			if let words = ac.textFields?[0].text?.lowercased() {
				var filteredPetitions = [Petition]()

				for petition in petitions {
					let title = petition.title.lowercased()
					if title.contains(words) {
						filteredPetitions.append(petition)
					}
				}
				displayedPetitions = filteredPetitions
				reload(tableView, animate: true)
			}
		}
		
		ac.addAction(submitFilter)
		present(ac, animated: true, completion: nil)
	}
	
	@objc func creditTapped() {
		let ac = UIAlertController(title: "Credit", message: "From We The People API of the Whitehouse", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Dismiss", style: .default))
		present(ac, animated: true)
	}
	
	func fetch(from urlString: String) {
		DispatchQueue.global(qos: .userInitiated).async { [weak self]  in
			if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
				self?.parse(data)
			}
		}
		
	}
	
	func parse(_ json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
			petitions = jsonPetitions.results
			displayedPetitions = petitions
			
			DispatchQueue.main.async { [weak self] in
				self?.tableView.reloadData()
			}
		} else {
			DispatchQueue.main.async { [weak self] in
				let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
				ac.addAction(UIAlertAction(title: "Ok", style: .default))
				self?.present(ac, animated: true)
			}
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return displayedPetitions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		
		let petition = displayedPetitions[indexPath.row]
		cell.textLabel?.text = petition.title
		cell.detailTextLabel?.text = petition.body
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = DetailViewController()
		vc.detailItem = displayedPetitions[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}
}

