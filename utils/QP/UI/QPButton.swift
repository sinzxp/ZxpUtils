//
//  QPButton.swift
//  CJWUtilsS
//
//  Created by Frank on 7/29/16.
//  Copyright © 2016 cen. All rights reserved.
//

import UIKit

open class QPButton: UIButton {
	open override func updateConstraints() {
		super.updateConstraints()
	}

	public func setup() {
	}

	public convenience init () {
		self.init(frame: CGRect.zero)
		setup()
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	open override func layoutSubviews() {
		super.layoutSubviews()
	}

}

public class QPTopIconButton: QPButton {
	public override func setup() {
		titleLabel?.numberOfLines = 0
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		verticalCenterImageAndTitle(4)
	}
}

open class QPTopIconButtonPro: QPControl {

	public let imageView = UIImageView()
	public let titleLabel = UILabel()

	public func setTitle(title: String?, forState state: UIControlState) {
		self.titleLabel.text = title
	}

	public func setImage(image: UIImage?, forState state: UIControlState) {
		imageView.image = image
	}

    open override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
//		super.addTarget(target, action: action, forControlEvents: controlEvents)
        super.addTarget(target, action: action, for: controlEvents)
	}

	open override func setup() {
		addSubview(imageView)
		addSubview(titleLabel)
//		title.textColor = UIColor.white
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.systemFont(ofSize: 13)
		titleLabel.textAlignmentCenter()
		imageView.scaleAspectFill()
	}

	open func imageSizePredicate() -> String {
		return "*0.5"
	}

	open func imageTopAlignPreidicate() -> String {
		return "4"
	}

	open override func layoutSubviews() {
		super.layoutSubviews()

		imageView.topAlign(self, predicate: imageTopAlignPreidicate())
		imageView.aspectRatio()
		imageView.width(self, predicate: imageSizePredicate())
		imageView.centerX(self)
		titleLabel.topConstrain(imageView, predicate: "0")
		titleLabel.bottomAlign(self, predicate: "0")
		titleLabel.leadingAlign(self, predicate: "8")
		titleLabel.trailingAlign(self, predicate: "-8")
	}
}

public extension UIButton {

	public func verticalCenterImageAndTitle(_ spacing: CGFloat) {
		if let imageView = self.imageView {
            let sizeZero = CGSize.zero
			// get the size of the elements here for readability
			let imageSize = imageView.frame.size ;
			var titleSize = self.titleLabel?.frame.size ?? sizeZero

			// lower the text and push it left to center it
			self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing / 2), 0.0);

			// the text width might have changed (in case it was shortened before due to
			// lack of space and isn't anymore now), so we get the frame size again
			titleSize = self.titleLabel?.frame.size ?? sizeZero;

			// raise the image and push it right to center it
			self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing / 2), 0.0, 0.0, -titleSize.width);
		}
	}
}
