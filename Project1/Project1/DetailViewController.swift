//
//  DetailViewController.swift
//  Project1
//
//  Created by Dimas on 04/08/21.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	
	var selectedImage: String?
	var atPosition: Int?
	var picturesLength: Int?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.largeTitleDisplayMode = .never

		if let imageToLoad = selectedImage, let index = atPosition, let length = picturesLength {
			imageView.image = UIImage(named: imageToLoad)
			title = "Picture \(index + 1) of \(length)"
		}
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self,
																 action: #selector(shareTaped))
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.navigationController?.hidesBarsOnTap = true
	}
    
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		self.navigationController?.hidesBarsOnTap = false
	}
	
	@objc func shareTaped() {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
		
		let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
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
