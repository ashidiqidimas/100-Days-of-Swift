//
//  ViewController.swift
//  Milestone Project 13-15
//
//  Created by Dimas on 23/10/21.
//

import UIKit

class ViewController: UIViewController {
	var countries = [Country]()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.identidier)
		tableView.rowHeight = 104
		tableView.backgroundColor = .red
		
		return tableView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		view.addSubview(tableView)
		
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Countries"
		loadCountries()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
		
		tableView.separatorStyle = .none
	}
	
	func loadCountries() {
		do {
			try Network.requestCountries() { [weak self] result in
				if let result = result {
					self?.countries = result.data
					self?.countries.removeFirst()
					self?.tableView.reloadData()
				}
			}
		} catch {
			print(error)
		}
	}

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if countries.isEmpty {
			return 10
		} else {
			return countries.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identidier, for: indexPath) as? CountryTableViewCell else { fatalError("Can't deque cell") }
		
		if !countries.isEmpty {
			let country = countries[indexPath.row]
			cell.countryLabel.text = country.name
			cell.flagImageView.load(from: country.flag)
		}
		
		return cell
	}
	
}

