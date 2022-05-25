import Foundation
import UIKit

public extension UIView {
	///
    func screenshotForRect(_ croppingRect:CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(croppingRect.size, false, UIScreen.main.scale);
		defer {
			UIGraphicsEndImageContext()
		}

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(x: -croppingRect.origin.x, y: -croppingRect.origin.y)
        self.layoutIfNeeded()
        self.layer.render(in: context)
        
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }
	
    var screenshot: UIImage? {
        return self.screenshotForRect(bounds)
    }
}

