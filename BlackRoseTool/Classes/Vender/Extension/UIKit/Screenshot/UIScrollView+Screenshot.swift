import Foundation
import UIKit

public extension UIScrollView {
    var screenshotOfVisibleContent: UIImage? {
        var croppingRect = bounds
        croppingRect.origin = contentOffset
        return screenshotForRect(croppingRect)
    }
}
