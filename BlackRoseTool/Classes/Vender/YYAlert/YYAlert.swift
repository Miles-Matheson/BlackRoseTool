//
//  YYAlert.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import UIKit

public final class YYAlert {
	public typealias Index = Int
	public typealias Handler = (Index) -> Void
	
	@discardableResult
	public static func show(title: String?,
							message: String?,
							button: String,
							handler: Handler? = nil) -> UIAlertController {
		let action = UIAlertAction(title: button, style: .default) { _ in
			handler?(0)
		}
		return show(title: title, message: message, actions: [action])
	}
	
	@discardableResult
	public static func show(title: String?,
							message: String?,
							buttons: [String],
							handler: Handler? = nil) -> UIAlertController {
		var index = -1
		let actions = buttons.map { text -> UIAlertAction in
			index += 1
			return UIAlertAction(title: text, style: .default) { _ in
				handler?(index)
			}
		}
		
		return show(title: title, message: message, actions: actions)
	}
	
	@discardableResult
	public static func show(title: String?,
							message: String?,
							actions: [UIAlertAction]) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		actions.forEach {
			alert.addAction($0)
		}
		
		UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true)
		return alert
	}
}
