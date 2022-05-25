//
//  UIImage+YYLib.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import UIKit

// MARK: - CGImage
extension CGImage {
    public var isDark: Bool {
        get {
            guard let imageData = dataProvider?.data else { return false }
            guard let ptr = CFDataGetBytePtr(imageData) else { return false }
            let length = CFDataGetLength(imageData)
            let threshold = Int(Double(width * height) * 0.45)
            var darkPixels = 0
            for i in stride(from: 0, to: length, by: 4) {
                let r = ptr[i]
                let g = ptr[i + 1]
                let b = ptr[i + 2]
                let luminance = (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
                if luminance < 150 {
                    darkPixels += 1
                    if darkPixels > threshold {
                        return true
                    }
                }
            }
            return false
        }
    }
}

public extension UIImage {
    class func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage {
        let sourceOpt = [kCGImageSourceShouldCache : false] as CFDictionary
        // 其他场景可以用createwithdata (data并未decode,所占内存没那么大),
        let source = CGImageSourceCreateWithURL(imageURL as CFURL, sourceOpt)!
        
        let maxDimension = max(pointSize.width, pointSize.height) * scale
        let downsampleOpt = [kCGImageSourceCreateThumbnailFromImageAlways : true,
                                     kCGImageSourceShouldCacheImmediately : true ,
                               kCGImageSourceCreateThumbnailWithTransform : true,
                                      kCGImageSourceThumbnailMaxPixelSize : maxDimension] as CFDictionary
        let downsampleImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOpt)!
        return UIImage(cgImage: downsampleImage)
    }
    
    
    /// 将图片转换为Base64字符串
    /// - Parameter image: image description
    /// - Returns: description
    class func imageToBase64(image:UIImage) -> String{
        let imageData :Data? = image.jpegData(compressionQuality: 1.0)
        let str : String = imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        return str
    }
    
    /// 将Base64字符串转换为
    /// - Parameter imgBase64String: imgBase64String description
    /// - Returns: description
    class func base64ToImage(imgBase64String:String?)-> UIImage{
        let data:Data? = Data(base64Encoded: imgBase64String!, options: .ignoreUnknownCharacters)
        let uiimage:UIImage = UIImage.init(data:data!)!
        return uiimage
    }
    
}
extension UIImage {
    
    
    /// 更改图片颜色
    public func imageWithTintColor(color : UIColor) -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        color.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
    
    /// 获取网络图片尺寸
    
    ///
    
    /// - Parameter url: 网络图片链接
    
    /// - Returns: 图片尺寸size
    
    class func getImageSize(_ url: String?) -> CGSize {
        
        
        
        guard let urlStr = url else {
            
            return CGSize.zero
            
        }
        
        let tempUrl = URL(string: urlStr)
        
        
        
        let imageSourceRef = CGImageSourceCreateWithURL(tempUrl! as CFURL, nil)
        
        var width: CGFloat = 0
        
        var height: CGFloat = 0
        
        if let imageSRef = imageSourceRef {
            
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSRef, 0, nil)
            
            
            
            if let imageP = imageProperties {
                
                let imageDict = imageP as Dictionary
                
                width = imageDict[kCGImagePropertyPixelWidth] as! CGFloat
                
                height = imageDict[kCGImagePropertyPixelHeight] as! CGFloat
                
            }
            
        }
        
        
        
        return CGSize(width: width, height: height)
        
    }
    
}
// MARK: - Initializers
public extension UIImage {
    /// SwifterSwift: Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        
        self.init(cgImage: aCgImage)
    }
    
}

// MARK: - Properties
public extension UIImage {
    /// Determine if a UIImage is generally dark or generally light
    var isDark: Bool {
        return cgImage?.isDark ?? false
    }
    
    /// Whether this image has alpha channel.
    var hasAlphaChannel: Bool {
        guard let cgImage = cgImage else {
            return false
        }
        let alpha = cgImage.alphaInfo
        return (alpha == .first ||
                alpha == .last ||
                alpha == .premultipliedFirst ||
                alpha == .premultipliedLast )
    }
    
    var base64: String {
        return jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    /// SwifterSwift: Size in bytes of UIImage
    var bytesSize: Int {
        return jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /// SwifterSwift: Size in kilo bytes of UIImage
    var kilobytesSize: Int {
        return bytesSize / 1024
    }
    
    /// SwifterSwift: UIImage with .alwaysOriginal rendering mode.
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /// SwifterSwift: UIImage with .alwaysTemplate rendering mode.
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - Methods
public extension UIImage {
    
    /// SwifterSwift: Compressed UIImage data from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional Data (if applicable).
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return jpegData(compressionQuality: quality)
    }
    
    /// SwifterSwift: Compressed UIImage from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional UIImage (if applicable).
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        return compressedData(quality: quality).flatMap { UIImage(data: $0) }
    }
    
    /// SwifterSwift: UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width < size.width && rect.size.height < size.height,
              let image = cgImage?.cropping(to: rect) else {
                  return self
              }
        return UIImage(cgImage: image)
    }
    
    func resized(to targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func scaled(with scale: CGFloat) -> UIImage? {
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return resized(to: scaledSize)
    }
    
    /// scales image
    func scaledTo(width: CGFloat, height: CGFloat) -> UIImage {
        let newSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - orientation: optional UIImage orientation (default is nil).
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, with oritentation: UIImage.Orientation? = nil) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: toHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage filled with color
    ///
    /// - Parameter color: color to fill image with.
    /// - Returns: UIImage filled with given color.
    func filled(with color: UIColor) -> UIImage {
        guard let mask = cgImage else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        context.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        return newImage
    }
    
    /// SwifterSwift: UIImage tinted with color
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint
    /// - Returns: UIImage tinted with given color.
    func tint(with color: UIColor, blendMode: CGBlendMode) -> UIImage {
        guard let mask = cgImage else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        context.clip(to: drawRect, mask: mask)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        return newImage
    }
}

// MARK: -
public extension UIImage {
    
    
    /// EZSE:
    func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    
    /// EZSE:
    func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
    
    func fitSize(in view: UIView? = nil) -> CGSize {
        let imageWidth = self.size.width
        let imageHeight = self.size.width
        let containerWidth = view != nil ? view!.bounds.size.width : UIScreen.main.bounds.size.width
        let containerHeight = view != nil ? view!.bounds.size.height : UIScreen.main.bounds.size.height
        
        let overWidth = imageWidth > containerWidth
        let overHeight = imageHeight > containerHeight
        
        let timesThanScreenWidth = imageWidth / containerWidth
        let timesThanScreenHeight = imageHeight / containerHeight
        
        var fitSize = CGSize(width: imageWidth, height: imageHeight)
        
        if overWidth && overHeight {
            fitSize.width = timesThanScreenWidth > timesThanScreenHeight ? containerWidth : imageWidth / timesThanScreenHeight
            fitSize.height = timesThanScreenWidth > timesThanScreenHeight ? imageHeight / timesThanScreenWidth : containerHeight
        } else {
            if overWidth && !overHeight {
                fitSize.width = containerWidth
                fitSize.height = containerHeight / timesThanScreenWidth
            } else if (!overWidth && overHeight) {
                //fitSize.width = containerWidth / timesThanScreenHeight
                fitSize.height = containerHeight
            }
        }
        return fitSize
    }
    
}



extension UIImage{
    
    /// 更改图片颜色
    public func changeColor(_ color : UIColor) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        color.setFill()
        
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIRectFill(bounds)
        
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = tintedImage else {
            return UIImage()
        }
        
        return image
    }
    
    
    ///生成二维码
    public class func generateQRCode(_ text: String,_ width:CGFloat,_ fillImage:UIImage? = nil, _ color:UIColor? = nil) -> UIImage? {
        
        //给滤镜设置内容
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            // 设置生成的二维码的容错率
            // value = @"L/M/Q/H"
            filter.setValue("H", forKey: "inputCorrectionLevel")
            
            //获取生成的二维码
            guard let outPutImage = filter.outputImage else {
                return nil
            }
            
            // 设置二维码颜色
            let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage":outPutImage,"inputColor0":CIColor(cgColor: color?.cgColor ?? UIColor.black.cgColor),"inputColor1":CIColor(cgColor: UIColor.clear.cgColor)])
            
            //获取带颜色的二维码
            guard let newOutPutImage = colorFilter?.outputImage else {
                return nil
            }
            
            let scale = width/newOutPutImage.extent.width
            
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            
            let output = newOutPutImage.transformed(by: transform)
            
            let QRCodeImage = UIImage(ciImage: output)
            
            guard let fillImage = fillImage else {
                return QRCodeImage
            }
            
            let imageSize = QRCodeImage.size
            
            UIGraphicsBeginImageContext(imageSize)
            
            QRCodeImage.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
            
            let fillRect = CGRect(x: (width - width/5)/2, y: (width - width/5)/2, width: width/5, height: width/5)
            
            fillImage.draw(in: fillRect)
            
            guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return QRCodeImage }
            
            UIGraphicsEndImageContext()
            
            return newImage
            
        }
        
        return nil
        
    }
    
    
    ///生成条形码
    public class func generateCode128(_ text:String, _ size:CGSize,_ color:UIColor? = nil ) -> UIImage?
    {
        //给滤镜设置内容
        guard let data = text.data(using: .utf8) else {
            return nil
        }
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            
            filter.setDefaults()
            
            filter.setValue(data, forKey: "inputMessage")
            
            //获取生成的条形码
            guard let outPutImage = filter.outputImage else {
                return nil
            }
            
            // 设置条形码颜色
            let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage":outPutImage,"inputColor0":CIColor(cgColor: color?.cgColor ?? UIColor.black.cgColor),"inputColor1":CIColor(cgColor: UIColor.clear.cgColor)])
            
            //获取带颜色的条形码
            guard let newOutPutImage = colorFilter?.outputImage else {
                return nil
            }
            
            let scaleX:CGFloat = size.width/newOutPutImage.extent.width
            
            let scaleY:CGFloat = size.height/newOutPutImage.extent.height
            
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            
            let output = newOutPutImage.transformed(by: transform)
            
            let barCodeImage = UIImage(ciImage: output)
            
            return barCodeImage
            
        }
        
        return nil
    }
    
    
    
}





















