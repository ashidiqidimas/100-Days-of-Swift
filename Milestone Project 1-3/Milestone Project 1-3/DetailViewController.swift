//
//  DetailViewController.swift
//  Milestone Project 1-3
//
//  Created by Dimas on 11/08/21.
//

import UIKit

class DetailViewController: UIViewController {
	
	var imageToLoad: String?
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var countrylabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.lightGray.cgColor
		
		if let image = imageToLoad {
			imageView.image = UIImage(named: image)
			
			var country = imageToLoad
			country?.removeLast(4)
			countrylabel.text = country
		}
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
	}
	
	@objc func shareTapped() {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
		
		let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
