import Foundation
import UIKit

public extension UITableView {
	
    var screenshotOfAll: UIImage? {
		return screenshotExcludingHeadersAtSections(excludedHeaderSections: nil, excludingFootersAtSections:nil, excludingRowsAtIndexPaths:nil)
	}
	
    var screenshotOfHeaderView : UIImage? {
		let originalOffset = contentOffset
		if let headerRect = tableHeaderView?.frame {
			scrollRectToVisible(headerRect, animated: false)
			let headerScreenshot = screenshotForRect(headerRect)
			setContentOffset(originalOffset, animated: false)
			
			return headerScreenshot;
		}
		return nil
	}
	
    var screenshotOfFooterView : UIImage? {
		let originalOffset = contentOffset
		if let footerRect = tableFooterView?.frame {
			scrollRectToVisible(footerRect, animated: false)
			let footerScreenshot = screenshotForRect(footerRect)
			setContentOffset(originalOffset, animated: false)
			
			return footerScreenshot;
		}
		return nil
	}
	
    var allSectionsIndexes : [Int] {
		let numSections = numberOfSections
		var allSectionsIndexes = [Int]()
		for section in 0..<numSections {
			allSectionsIndexes.append(section)
		}
		return allSectionsIndexes
	}
	
    var allRowsIndexPaths : [NSIndexPath] {
		var allRowsIndexPaths = [NSIndexPath]()
		for sectionIdx in allSectionsIndexes {
			for rowNum in 0..<numberOfRows(inSection: sectionIdx) {
				let indexPath = NSIndexPath(row: rowNum, section: sectionIdx)
				allRowsIndexPaths.append(indexPath)
			}
		}
		return allRowsIndexPaths;
	}
}

public extension UITableView {
	
    func screenshotOfCell(at indexPath:NSIndexPath) -> UIImage? {
        var cellScreenshot:UIImage?
        
        let currTableViewOffset = contentOffset
        
        scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
        
        cellScreenshot = cellForRow(at: indexPath as IndexPath)?.screenshot
        
        setContentOffset(currTableViewOffset, animated: false)
        
        return cellScreenshot;
    }
    
    func screenshotOfHeaderViewAtSection(section:Int) -> UIImage? {
        let originalOffset = contentOffset
        let headerRect = rectForHeader(inSection: section)
        
        scrollRectToVisible(headerRect, animated: false)
        let headerScreenshot = screenshotForRect(headerRect)
        setContentOffset(originalOffset, animated: false)
        
        return headerScreenshot;
    }
    
    func screenshotOfFooterViewAtSection(section:Int) -> UIImage? {
        let originalOffset = contentOffset
        let footerRect = rectForFooter(inSection: section)
        
        scrollRectToVisible(footerRect, animated: false)
        let footerScreenshot = screenshotForRect(footerRect)
        setContentOffset(originalOffset, animated: false)
        
        return footerScreenshot;
    }
    
    func screenshotExcludingAllHeaders(withoutHeaders:Bool, excludingAllFooters:Bool, excludingAllRows:Bool) -> UIImage? {
        
        var excludedHeadersOrFootersSections:[Int]?
        
        if withoutHeaders || excludingAllFooters {
            excludedHeadersOrFootersSections = allSectionsIndexes
        }
        
        var excludedRows:[NSIndexPath]?
        
        if excludingAllRows {
            excludedRows = allRowsIndexPaths
        }
        
        return screenshotExcludingHeadersAtSections( excludedHeaderSections: withoutHeaders ? NSSet(array: excludedHeadersOrFootersSections!) : nil,
                                                          excludingFootersAtSections:excludingAllFooters ? NSSet(array:excludedHeadersOrFootersSections!) : nil, excludingRowsAtIndexPaths:excludingAllRows ? NSSet(array:excludedRows!) : nil)
    }
    
    func screenshotExcludingHeadersAtSections(excludedHeaderSections:NSSet?, excludingFootersAtSections:NSSet?,
                                              excludingRowsAtIndexPaths:NSSet?) -> UIImage? {
        var screenshots = [UIImage]()
        
        if let headerScreenshot = screenshotOfHeaderView {
            screenshots.append(headerScreenshot)
        }
        
        for section in 0..<numberOfSections {
            if let headerScreenshot = screenshotOfHeaderViewAtSection(section: section, excludedHeaderSections: excludedHeaderSections) {
                screenshots.append(headerScreenshot)
            }
            
            for row in 0..<numberOfRows(inSection: section) {
                let cellIndexPath = NSIndexPath(row: row, section: section)
                if let cellScreenshot = screenshotOfCell(at: cellIndexPath) {
                    screenshots.append(cellScreenshot)
                }
                
            }
            
            if let footerScreenshot = screenshotOfFooterViewAtSection(section: section, excludedFooterSections:excludingFootersAtSections) {
                screenshots.append(footerScreenshot)
            }
        }
        
        
        if let footerScreenshot = screenshotOfFooterView {
            screenshots.append(footerScreenshot)
        }
        
        return UIImage.verticalImage(from: screenshots)
        
    }
    
    func screenshotOfHeadersAtSections(includedHeaderSection:NSSet, footersAtSections:NSSet?, rowsAtIndexPaths:NSSet?) -> UIImage? {
        var screenshots = [UIImage]()
        
        for section in 0..<numberOfSections {
            if let headerScreenshot = screenshotOfHeaderViewAtSection(section: section, includedHeaderSections: includedHeaderSection) {
                screenshots.append(headerScreenshot)
            }
            
            for row in 0..<numberOfRows(inSection: section) {
                if let cellScreenshot = screenshotOfCellAtIndexPath(indexPath: NSIndexPath(row: row, section: section), includedIndexPaths: rowsAtIndexPaths) {
                    screenshots.append(cellScreenshot)
                }
            }
            
            if let footerScreenshot = screenshotOfFooterViewAtSection(section: section, includedFooterSections: footersAtSections) {
                screenshots.append(footerScreenshot)
            }
        }
        
        return UIImage.verticalImage(from: screenshots)
    }
    
    func screenshotOfCellAtIndexPath(indexPath:NSIndexPath, excludedIndexPaths:NSSet?) -> UIImage? {
        if excludedIndexPaths == nil || !excludedIndexPaths!.contains(indexPath) {
            return nil
        }
        return screenshotOfCell(at: indexPath)
    }
    
    func screenshotOfHeaderViewAtSection(section:Int, excludedHeaderSections:NSSet?) -> UIImage? {
        if excludedHeaderSections != nil && !excludedHeaderSections!.contains(section) {
            return nil
        }
        
        var sectionScreenshot = screenshotOfHeaderViewAtSection(section: section)
        if sectionScreenshot == nil {
            sectionScreenshot = blankScreenshotOfHeaderAtSection(section: section)
        }
        return sectionScreenshot;
    }
    
    func screenshotOfFooterViewAtSection(section:Int, excludedFooterSections:NSSet?) -> UIImage? {
        if excludedFooterSections != nil && !excludedFooterSections!.contains(section) {
            return nil
        }
        
        var sectionScreenshot = screenshotOfFooterViewAtSection(section: section)
        if sectionScreenshot == nil {
            sectionScreenshot = blankScreenshotOfFooterAtSection(section: section)
        }
        return sectionScreenshot;
    }
    
    func screenshotOfCellAtIndexPath(indexPath:NSIndexPath, includedIndexPaths:NSSet?) -> UIImage? {
        if includedIndexPaths != nil && !includedIndexPaths!.contains(indexPath) {
            return nil
        }
        return screenshotOfCell(at: indexPath)
    }
    
    func screenshotOfHeaderViewAtSection(section:Int, includedHeaderSections:NSSet?) -> UIImage? {
        if includedHeaderSections != nil && !includedHeaderSections!.contains(section) {
            return nil
        }
        
        var sectionScreenshot = screenshotOfHeaderViewAtSection(section: section)
        if sectionScreenshot == nil {
            sectionScreenshot = blankScreenshotOfHeaderAtSection(section: section)
        }
        return sectionScreenshot;
    }
    
    func screenshotOfFooterViewAtSection(section:Int, includedFooterSections:NSSet?)
        -> UIImage? {
            if includedFooterSections != nil && !includedFooterSections!.contains(section) {
                return nil
            }
            var sectionScreenshot = screenshotOfFooterViewAtSection(section: section)
            if sectionScreenshot == nil {
                sectionScreenshot = blankScreenshotOfFooterAtSection(section: section)
            }
            return sectionScreenshot;
    }
    
    func blankScreenshotOfHeaderAtSection(section:Int) -> UIImage? {
        
        let headerRectSize = CGSize(width: bounds.size.width, height: rectForHeader(inSection: section).size.height)
        
        return UIImage.imageWithColor(color: UIColor.clear, size:headerRectSize)
    }
    
    func blankScreenshotOfFooterAtSection(section:Int) -> UIImage? {
        let footerRectSize = CGSize(width: bounds.size.width, height: rectForFooter(inSection: section).size.height)
        return UIImage.imageWithColor(color: UIColor.clear, size:footerRectSize)
    }
}
