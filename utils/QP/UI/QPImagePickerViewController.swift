//
//  QPImagePickerViewController.swift
//  CJWUtilsS
//
//  Created by Frank on 9/7/16.
//  Copyright © 2016 cen. All rights reserved.
//

import UIKit

public typealias QPImagePickerBlock = ( _ images: Array<UIImage>) -> ()

public class QPImagePickerViewController: UIImagePickerController, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	var block: QPImagePickerBlock!
	var cameraBlock: QPImagePickerBlock!
	var maxCount = 1
	var editAble = true

	func pickImage(vc: UIViewController, maxCount: Int, block: @escaping QPImagePickerBlock) {
		self.block = block
		self.maxCount = maxCount

		let actionSheet = UIAlertController(title: "选择照片", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
		let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
		let camera = UIAlertAction(title: "相机", style: UIAlertActionStyle.default) { (action) -> Void in
			self.imageFromCamera(vc, block: block)
		}
		let library = UIAlertAction(title: "图库", style: UIAlertActionStyle.default) { (action) -> Void in
			if maxCount <= 1 {
				self.imageFromPhoto(vc, block: block)
			} else {
				self.imageFromLibrary(vc, maxCount: maxCount, block: block)
			}
		}

		actionSheet.addAction(cancelAction)
		actionSheet.addAction(camera)
		actionSheet.addAction(library)

		vc.present(actionSheet, animated: true) { () -> Void in
		}
	}
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if maxCount <= 1 {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                let oirentationImage = image.fixOrientation()!
                block([oirentationImage])
            } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let oirentationImage = image.fixOrientation()!
                block([oirentationImage])
            }
        } else {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let oirentationImage = image.fixOrientation()!
                block([oirentationImage])
            }
        }
        
        picker.dismiss(animated: true) { () -> Void in
            //
        }
    }
    

	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
		if maxCount <= 1 {
			if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
				let oirentationImage = image.fixOrientation()!
				block([oirentationImage])
			} else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
				let oirentationImage = image.fixOrientation()!
				block([oirentationImage])
			}
		} else {
			if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
				let oirentationImage = image.fixOrientation()!
				block([oirentationImage])
			}
		}

		picker.dismiss(animated: true) { () -> Void in
			//
		}
	}

	func imageFromSystem(_ vc: UIViewController, type: UIImagePickerControllerSourceType, block: @escaping QPImagePickerBlock) {
		if self.block == nil {
			self.block = block
		}

		let isAvailable = UIImagePickerController.isSourceTypeAvailable(type)

		self.sourceType = type
		self.delegate = self
		self.allowsEditing = editAble
		if isAvailable {
			vc.present(self, animated: true, completion: nil)
		} else {
			self.showText("无权限")
		}
	}

	func imageFromPhoto(_ vc: UIViewController, block: @escaping QPImagePickerBlock) {
		imageFromSystem(vc, type: UIImagePickerControllerSourceType.photoLibrary, block: block)
	}

	func imageFromCamera(_ vc: UIViewController, block: @escaping QPImagePickerBlock) {
		imageFromSystem(vc, type: UIImagePickerControllerSourceType.camera, block: block)

	}

	func imageFromLibrary(_ vc: UIViewController, maxCount: Int, block: @escaping QPImagePickerBlock) {
		let pickerVc = MLSelectPhotoPickerViewController()
		pickerVc.maxCount = maxCount
		pickerVc.status = PickerViewShowStatus.cameraRoll
		pickerVc.showPickerVc(vc)
		pickerVc.callBack = {
			(assets) -> () in
			if let array = assets as? NSArray {
				var imgs = Array<UIImage>()
				for asset in array {
					if let ass = asset as? MLSelectPhotoAssets {
						let image = ass.originImage()!
						imgs.append(image)
					}

				}
				block(imgs)
			}
		}
	}

	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true) { () -> Void in
		}
	}
}

public extension UIViewController {

	func pickImage(_ maxCount: Int, editAble: Bool, block: @escaping QPImagePickerBlock) {
		let picker = QPImagePickerViewController()
		picker.editAble = editAble
        picker.pickImage(vc: self, maxCount: maxCount, block: block)
	}

	func pickImage(_ maxCount: Int, block: @escaping QPImagePickerBlock) {
		pickImage(maxCount, editAble: true, block: block)
	}

	func pickImageFromLibrary(_ maxCount: Int, block: @escaping QPImagePickerBlock) {
		let picker = QPImagePickerViewController()
		picker.imageFromLibrary(self, maxCount: maxCount, block: block)
	}

	// imageFromCamera
	func pickImageFromCamera(block: @escaping QPImagePickerBlock) {
		let picker = QPImagePickerViewController()
		picker.imageFromCamera(self, block: block)
	}
}
