//
//  UIImageViewExtension.swift
//  Milestone Project 13-15
//
//  Created by Dimas on 07/11/21.
//

import UIKit
import SVGKit
import SkeletonView

class COImageView: UIImageView {
	var task: URLSessionDataTask!
	
	func loadSVGImage(from url: URL, completionHandler: @escaping (UIImage) -> Void) {
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			let request = URLRequest(url: url)
			self?.task = URLSession.shared.dataTask(with: request) { data, response, error in
				guard let data = data, error == nil else {
					print("Error while loading the image from url: \(url)")
					return
				}
				
				let svgImage = SVGKImage(data: data)
				guard let img = svgImage?.uiImage else { return }
				DispatchQueue.main.async {
					completionHandler(img)
				}
			}
			self?.task.resume()
		}
		
	}
	
	func load(from urlString: String) {
		if let task = task {
			task.cancel()
		}
		guard let url = URL(string: urlString) else { return }
		
		image = nil
		let gradient = SkeletonGradient(baseColor: .silver, secondaryColor: .concrete)
		let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
		self.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .crossDissolve(0.2))
		
		loadSVGImage(from: url) { [weak self] img in
			self?.image = img
			self?.hideSkeleton(transition: .crossDissolve(0.2))
		}
	}
}
