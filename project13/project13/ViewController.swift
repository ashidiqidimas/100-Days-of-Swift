//
//  ViewController.swift
//  project13
//
//  Created by Dimas on 11/10/21.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
	
	private let filters = ["CISepiaTone", "CIPixellate", "CIGaussianBlur", "CITwirlDistortion", "CIBumpDistortion", "CIUnsharpMask", "CIVignette"]
	private var filterKeys = [String]()
	private var isShowedMenu = false
	private var isDragging = false
	private var relativeLocation: CGPoint = .zero
	
	private var context: CIContext!
	private var currentImage: UIImage!
	private var imageSize: CGSize!
	
	private var currentFilter = CIFilter(name: "CISepiaTone")! {
		didSet {
			if let img = currentImage {
				let beginImage = CIImage(image: img)
				currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
				updateTableView()
				applyProcessing()
			}
		}
	}
	
	private let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = .init(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .red
		
		return tableView
	}()
	
	private let editMenuView: UIView = {
		let editMenuView = UIView()
		editMenuView.backgroundColor = .red
		
		let screenSize = UIScreen.main.bounds
		editMenuView.frame = CGRect(x: 0, y: screenSize.height - 300, width: screenSize.width, height: 300)
		
		return editMenuView
	}()
	
	private let showMenuButton: UIButton = {
		let showMenuButton = UIButton(type: .custom)
		showMenuButton.translatesAutoresizingMaskIntoConstraints = false
		let config = UIImage.SymbolConfiguration(pointSize: 32)
		showMenuButton.setImage(UIImage(systemName: "chevron.up", withConfiguration: config), for: .normal)
		showMenuButton.tintColor = .init(named: "AccentColor")
		showMenuButton.backgroundColor = .blue
		showMenuButton.addTarget(self, action: #selector(showHideMenu), for: .touchUpInside)
		
		return showMenuButton
	}()
	
	private let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = .init(width: 100, height: 100)
		layout.scrollDirection = .horizontal
		layout.minimumInteritemSpacing = 8
		layout.sectionInset = .init(top: 0, left: 8, bottom: 0, right: 8)
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
		collectionView.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
		
		return collectionView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
		
		title = "Instafilter"
		imageSize = CGSize(width: view.frame.width - 32, height: (view.frame.width - 32) * 16 / 9) // TODO: Change to size: zero then add size after importing an image
		
		customizeSubviews()
		addRightBarButtons()
		addGestures()
		
		context = CIContext()
		
		view.addSubview(tableView)
		view.addSubview(showMenuButton)
		view.addSubview(collectionView)
		
		NSLayoutConstraint.activate([
			showMenuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			showMenuButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -16),
			
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			collectionView.heightAnchor.constraint(equalToConstant: 116)
		])
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		for cell in collectionView.visibleCells {
			let filterCell = cell as! FilterCollectionViewCell
			if filterCell.filter == "CISepiaTone" {
				cell.backgroundColor = .lightGray
			}
		}
	}
	
	@objc func showHideMenu() {
		let bottomConstraint = view.constraints.first(where: { $0.firstAttribute == .bottom })
		
		UIView.animate(withDuration: 0.3) { [ weak self] in
			
			guard let showMenuButton = self?.showMenuButton else { return }
			guard let self = self else { return }
			
			if self.isShowedMenu {
				showMenuButton.transform = .identity
				bottomConstraint?.constant = -16
				self.view.layoutIfNeeded()
				
				self.isShowedMenu.toggle()
			} else {
				showMenuButton.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
				
				bottomConstraint?.constant = -100
				self.view.layoutIfNeeded()
				
				self.isShowedMenu.toggle()
			}
		}
	}
	
	func addRightBarButtons() {
		UIStackView.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).spacing = -8
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
		let saveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(save))
		saveButton.isEnabled = false
		saveButton.tintColor = .clear
		navigationItem.rightBarButtonItems = [addButton, saveButton]
	}
	
	func customizeSubviews() {
		view.addSubview(imageView)
		imageView.frame = CGRect(origin: .zero, size: imageSize)
		imageView.center = view.center
		imageView.isUserInteractionEnabled = true
	}
	
	@objc func save() {
		guard let image = imageView.image else { return }
		
		UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingError:contextInfo:)), nil)
	}
	
	func ShowSaveButton() {
		let saveButton = navigationItem.rightBarButtonItems?.first(where: { $0.action == #selector(save)})
		
		saveButton?.isEnabled = true
		saveButton?.tintColor = .init(named: "AccentColor")
	}
	
	func setFilter(action: UIAlertAction) {
		guard currentImage != nil else { return }
		guard let actionTitle = action.title else { return }
		
		currentFilter = CIFilter(name: actionTitle)!
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		applyProcessing()
	}
	
	func applyProcessing() {
		guard let image = currentFilter.outputImage else { return }
		
		let inputKeys = currentFilter.inputKeys
		
		if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(0.5, forKey: kCIInputIntensityKey) }
		if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(0.5 * 10, forKey: kCIInputRadiusKey) }
		if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(0.5 * 10, forKey: kCIInputScaleKey) }
		if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: imageSize.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
		
		if let cgImg = context.createCGImage(image, from: image.extent) {
			let processedImage = UIImage(cgImage: cgImg)
			imageView.image = processedImage
		}
	}
	
	func processedImage(_ image: UIImage, for filterName: String) -> UIImage? {
		
		let filter = CIFilter(name: filterName)
		let beginImage = CIImage(image: image)
		filter?.setValue(beginImage, forKey: kCIInputImageKey)
		
		let inputKeys = currentFilter.inputKeys
		
		if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(0.5, forKey: kCIInputIntensityKey) }
		if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(0.5 * 100, forKey: kCIInputRadiusKey) }
		if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(0.5 * 100, forKey: kCIInputScaleKey) }
		if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: imageSize.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
		
		guard let filterImage = filter?.outputImage else { return nil }
		
		if let cgImg = context.createCGImage(filterImage, from: filterImage.extent) {
			return UIImage(cgImage: cgImg)
		} else {
			return nil
		}
	}
	
	@objc func image(_ image: UIImage, didFinishSavingError error: Error?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		} else {
			let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
		
	}
}

// MARK: - Table View
extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as? FilterTableViewCell else { fatalError("Can't deque cell for table view") }

		return cell
	}
	
	func updateTableView() {
		// TODO: manipulate the constraints when changing data source
		
		filterKeys.removeAll()
		
		let inputKeys = currentFilter.inputKeys
		if inputKeys.contains(kCIInputIntensityKey) { filterKeys.append("kCIInputIntensityKey") }
		if inputKeys.contains(kCIInputRadiusKey) { filterKeys.append("kCIInputRadiusKey") }
		if inputKeys.contains(kCIInputScaleKey) { filterKeys.append("kCIInputScaleKey") }
		
		tableView.reloadData()
	}
	
}

// MARK: - Collection View
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 7
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
		
		cell.layer.cornerRadius = 4
		cell.layer.masksToBounds = true
		
		if let img = imageView.image {
			cell.imageView.image = processedImage(img, for: filters[indexPath.item])
		} else {
			cell.imageView.image = processedImage(UIImage(named: "BigSur") ?? UIImage(), for: filters[indexPath.item])
		}
		
		cell.filter = filters[indexPath.item]
		
		var filter = filters[indexPath.item]
		filter.removeFirst()
		filter.removeFirst()
		
		cell.title.text = filter
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else { return }
		
		cell.backgroundColor = .red
		let filter = filters[indexPath.item]
		
		if let selectedFilter = CIFilter(name: filter) {
			currentFilter = selectedFilter
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else { return }

		cell.backgroundColor = .white
	}
	
}

// MARK: - Gestures
extension ViewController {
	func addGestures() {
		let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
		imageView.addGestureRecognizer(pinchGesture)
		
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
		panGesture.minimumNumberOfTouches = 2
		panGesture.maximumNumberOfTouches = 2
		imageView.addGestureRecognizer(panGesture)
		
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
		longPress.numberOfTouchesRequired = 1
		longPress.allowableMovement = 10
		longPress.minimumPressDuration = 0.1
		imageView.addGestureRecognizer(longPress)
	}
	
	@objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
		if gesture.state == .began {
			imageView.image = currentImage
		}
		
		if gesture.state == .ended {
			applyProcessing()
		}
	}
	
	@objc func didPan(_ gesture: UIPanGestureRecognizer) {
		if gesture.state == .began {
			isDragging = true
			
			relativeLocation = gesture.location(in: imageView)
		}
		
		if gesture.state == .changed {
			guard isDragging else { return }
			
			let location = gesture.location(in: view)
			
			imageView.frame.origin.x = location.x - relativeLocation.x
			imageView.frame.origin.y = location.y - relativeLocation.y
		}
		
		if gesture.state == .ended {
			isDragging = false
		}
	}
	
	@objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
		if gesture.state == .changed {
			let scale = gesture.scale
			imageView.frame = CGRect(origin: .zero, size: CGSize(width: imageSize.width * scale, height: imageSize.height * scale))
			imageView.center = view.center
		}
		
		if gesture.state == .ended {
			imageSize = imageView.frame.size
		}
	}
	
}

// MARK: - Image Picker Controller
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@objc func importImage() {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		present(picker, animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		dismiss(animated: true)
		currentImage = image
		
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		applyProcessing()
		collectionView.reloadData()
		
		if currentImage != nil { ShowSaveButton() }
		
		if let imageInside = imageView.image {
			imageSize = CGSize(width: imageView.frame.width,
							   height: imageView.frame.width / imageInside.size.width * imageInside.size.height)
			imageView.frame.size = imageSize
			imageView.center = view.center
		}
	}
}
