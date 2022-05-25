//
//  UILabel+YYLib.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import UIKit

// MARK: - Methods
public extension UILabel {
	/// EZSwiftExtensions (if duration set to 0 animate wont be)
    func setText(_ text: String?, duration: TimeInterval) {
		UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: { () -> Void in
			self.text = text
		}, completion: nil)
	}
	
	/// EZSwiftExtensions
    func estimatedSize(_ width: CGFloat = .greatestFiniteMagnitude, height: CGFloat = .greatestFiniteMagnitude) -> CGSize {
		return sizeThatFits(CGSize(width: width, height: height))
	}
	
	/// EZSwiftExtensions
    func estimatedHeight() -> CGFloat {
		return sizeThatFits(CGSize(width: w, height: .greatestFiniteMagnitude)).height
	}
	
	/// EZSwiftExtensions
    func estimatedWidth() -> CGFloat {
		return sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: h)).width
	}
	
	/// EZSwiftExtensions
    func fitHeight() {
		h = estimatedHeight()
	}
	
	/// EZSwiftExtensions
    func fitWidth() {
		w = estimatedWidth()
	}
	
	/// EZSwiftExtensions
    func fitSize() {
		fitWidth()
		fitHeight()
		sizeToFit()
	}
}
