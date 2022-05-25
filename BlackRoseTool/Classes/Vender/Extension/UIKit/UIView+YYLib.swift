//
//  UIView+YYLib.swift
//  SwiftProject
//
//  Created by MAC on 2022/04/11.
//

import UIKit

// MARK: - Static
public extension UIView {
    /// 根据xib生成对象
    class func instantiateFromNib() -> Self {
        return instantiateFromNibHelper()
    }
    
    /// https://stackoverflow.com/questions/33200035/return-instancetype-in-swift
    private class func instantiateFromNibHelper<T>() -> T {
        return Bundle(for: self).loadNibNamed(self.clsName, owner: nil, options: nil)!.first! as! T
    }
}

// MARK: - Convenience init
public extension UIView {
    /// EZSwiftExtensions
    convenience init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
    }
    
    /// EZSwiftExtensions, puts padding around the view
    convenience init(superView: UIView, padding: CGFloat) {
        self.init(frame: CGRect(x: superView.x + padding, y: superView.y + padding, width: superView.width - padding*2, height: superView.height - padding*2))
    }
    
    /// EZSwiftExtensions - Copies size of superview
    convenience init(superView: UIView) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: superView.size))
    }
}

// MARK: - Property
public extension UIView {
    /// Loops until it finds the top root view.
    var rootView: UIView {
        guard let parentView = superview else {
            return self
        }
        
        return parentView.rootView
    }
    
    /// Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /// First responder.
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        for subview in subviews where subview.isFirstResponder {
            return subview
        }
        return nil
    }
    
    /// Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, *, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }
}

// MARK: - Util
public extension UIView {
    ///
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func add(_ views: [UIView]) {
        views.forEach(addSubview)
    }
    
    func add(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    func bringToFront() {
        superview?.bringSubviewToFront(self)
    }
    
    func exclusiveTouchSubviews() {
        for view in subviews {
            if let button = view as? UIButton {
                button.isExclusiveTouch = true
            } else {
                view.exclusiveTouchSubviews()
            }
        }
    }
    
    /// 设置view的anchorPoint，同时保证view的frame不改变
    func setAnchorPointFixedFrame(_ anchorPoint: CGPoint) {
        let oldOrigin = frame.origin
        layer.anchorPoint = anchorPoint
        let newOrign = frame.origin
        let transition = CGPoint(x: newOrign.x - oldOrigin.x, y: newOrign.y - oldOrigin.y)
        center = CGPoint(x: center.x - transition.x, y: center.y - transition.y)
    }
}

// MARK: Layer Extensions
public extension UIView {
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    
    ///  - Mask square/rectangle UIView with a circular/capsule cover, with a border of desired color and width around it
    func roundView(borderColor color: UIColor? = nil, borderWidth width: CGFloat? = nil) {
        setCornerRadius(min(frame.size.height, frame.size.width) / 2)
        layer.borderWidth = width ?? 0
        layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor
    }
    
    ///
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    ///
    func addShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
        if let r = cornerRadius {
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
        }
    }
    
    ///
    func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }
    
    ///
    func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    
    ///
    func addBorderTopWithPadding(size: CGFloat, color: UIColor, padding: CGFloat) {
        addBorderUtility(x: padding, y: 0, width: frame.width - padding*2, height: size, color: color)
    }
    
    ///
    func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    
    ///
    func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    
    ///
    func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
    
    ///
    fileprivate func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    ///
    func drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: w, height: w), cornerRadius: w/2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        layer.addSublayer(shapeLayer)
    }
    
    ///
    func drawStroke(width: CGFloat, color: UIColor) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: w, height: w), cornerRadius: w/2)
        let shapeLayer = CAShapeLayer ()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        layer.addSublayer(shapeLayer)
    }
}

// MARK: - Transform Extensions
public extension UIView {
    ///
    func setRotationX(_ x: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians, 1.0, 0.0, 0.0)
        layer.transform = transform
    }
    
    ///
    func setRotationY(_ y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, y.degreesToRadians, 0.0, 1.0, 0.0)
        layer.transform = transform
    }
    
    ///
    func setRotationZ(_ z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, z.degreesToRadians, 0.0, 0.0, 1.0)
        layer.transform = transform
    }
    
    ///
    func setRotation(x: CGFloat, y: CGFloat, z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, y.degreesToRadians, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, z.degreesToRadians, 0.0, 0.0, 1.0)
        layer.transform = transform
    }
    
    ///
    func setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        layer.transform = transform
    }
}

// MARK: - Animation Extensions
public extension UIView {
    ///
    static private let AnimationDuration: TimeInterval = 1
    static private let AnimationSpringDamping: CGFloat = 0.5
    static private let AnimationSpringVelocity: CGFloat = 0.5
    static let DefaultFadeDuration: TimeInterval = 0.4
    
    /// Shakes the view for as many number of times as given in the argument.
    func shakeViewForTimes(_ times: Int) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0 )),
            NSValue(caTransform3D: CATransform3DMakeTranslation( 5, 0, 0 ))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7/100
        
        layer.add(anim, forKey: nil)
    }
    
    ///
    func spring(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        spring(duration: UIView.AnimationDuration, animations: animations, completion: completion)
    }
    
    ///
    func spring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: UIView.AnimationDuration,
            delay: 0,
            usingSpringWithDamping: UIView.AnimationSpringDamping,
            initialSpringVelocity: UIView.AnimationSpringVelocity,
            options: .allowAnimatedContent,
            animations: animations,
            completion: completion
        )
    }
    
    ///
    func animate(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }
    
    ///
    func animate(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        animate(duration: UIView.AnimationDuration, animations: animations, completion: completion)
    }
    
    ///
    func pop() {
        setScale(x: 1.1, y: 1.1)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
        })
    }
    
    ///
    func popBig() {
        setScale(x: 1.25, y: 1.25)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
        })
    }
    
    /// Reverse pop, good for button animations
    func reversePop() {
        setScale(x: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.05, delay: 0, options: .allowUserInteraction, animations: { [weak self] in
            self?.setScale(x: 1, y: 1)
        }) { (bool) in }
    }
    
    /// Fade in with duration, delay and completion block.
    func fadeIn(_ duration: TimeInterval? = UIView.DefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        fadeTo(1.0, duration: duration, delay: delay, completion: completion)
    }
    
    ///
    func fadeOut(_ duration: TimeInterval? = UIView.DefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        fadeTo(0.0, duration: duration, delay: delay, completion: completion)
    }
    
    /// Fade to specific value	 with duration, delay and completion block.
    func fadeTo(_ value: CGFloat, duration: TimeInterval? = UIView.DefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration ?? UIView.DefaultFadeDuration, delay: delay ?? UIView.DefaultFadeDuration, options: .curveEaseInOut, animations: {
            self.alpha = value
        }, completion: completion)
    }
    
    func addZoomOutAnimation() {
        transform = transform.scaledBy(x: 0.5, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
    func addFlyUpwardAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.transform = self.transform.translatedBy(x: 0, y: -20)
            self.alpha = 0
        }
    }
    
    func addTopAndDownAnimation() {
        transform = .identity
        
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = self.transform.translatedBy(x: 0, y: -10)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.15, animations: {
                self.transform = .identity
            })
        })
    }
}

// MARK: - Gesture Extensions
public extension UIView {
    /// http://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview/32182866#32182866
    func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    ///  - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    func addTapGesture(tapNumber: Int = 1, action: ((UITapGestureRecognizer) -> Void)?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    ///
    func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, numberOfTouches: Int = 1, target: AnyObject, action: Selector) {
        let swipe = UISwipeGestureRecognizer(target: target, action: action)
        swipe.direction = direction
        
        #if os(iOS)
        swipe.numberOfTouchesRequired = numberOfTouches
        #endif
        
        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
    }
    
    ///  - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, numberOfTouches: Int = 1, action: ((UISwipeGestureRecognizer) -> Void)?) {
        let swipe = BlockSwipe(direction: direction, fingerCount: numberOfTouches, action: action)
        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
    }
    
    ///
    func addPanGesture(target: AnyObject, action: Selector) {
        let pan = UIPanGestureRecognizer(target: target, action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }
    
    ///  - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    func addPanGesture(action: ((UIPanGestureRecognizer) -> Void)?) {
        let pan = BlockPan(action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }
    
    #if os(iOS)
    
    ///
    func addPinchGesture(target: AnyObject, action: Selector) {
        let pinch = UIPinchGestureRecognizer(target: target, action: action)
        addGestureRecognizer(pinch)
        isUserInteractionEnabled = true
    }
    
    #endif
    
    #if os(iOS)
    
    ///  - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    func addPinchGesture(action: ((UIPinchGestureRecognizer) -> Void)?) {
        let pinch = BlockPinch(action: action)
        addGestureRecognizer(pinch)
        isUserInteractionEnabled = true
    }
    
    #endif
    
    ///
    func addLongPressGesture(target: AnyObject, action: Selector) {
        let longPress = UILongPressGestureRecognizer(target: target, action: action)
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
    }
    
    ///  - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    func addLongPressGesture(action: ((UILongPressGestureRecognizer) -> Void)?) {
        let longPress = BlockLongPress(action: action)
        addGestureRecognizer(longPress)
        isUserInteractionEnabled = true
    }
}

// MARK: - Frame Layout
public extension UIView {
    /// resizes this view so it fits the largest subview
    func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in subviews {
            let aView = someView
            let newWidth = aView.x + aView.w
            let newHeight = aView.y + aView.h
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    ///
    func resizeToFitWidth() {
        let currentHeight = h
        sizeToFit()
        h = currentHeight
    }
    
    ///
    func resizeToFitHeight() {
        let currentWidth = w
        sizeToFit()
        w = currentWidth
    }
    
    ///
    func leftOffset(_ offset: CGFloat) -> CGFloat {
        return left - offset
    }
    
    ///
    func rightOffset(_ offset: CGFloat) -> CGFloat {
        return right + offset
    }
    
    ///
    func topOffset(_ offset: CGFloat) -> CGFloat {
        return top - offset
    }
    
    ///
    func bottomOffset(_ offset: CGFloat) -> CGFloat {
        return bottom + offset
    }
    
    ///
    func alignRight(_ offset: CGFloat) -> CGFloat {
        return w - offset
    }
    
    ///  Centers view in superview horizontally
    func centerXInSuperView() {
        guard let parentView = superview else {
            return
        }
        
        x = parentView.w/2 - w/2
    }
    
    ///  Centers view in superview vertically
    func centerYInSuperView() {
        guard let parentView = superview else {
            return
        }
        
        y = parentView.h/2 - h/2
    }
    
    ///  Centers view in superview horizontally & vertically
    func centerInSuperView() {
        centerXInSuperView()
        centerYInSuperView()
    }
}

// MARK: - AutoLayout
/// 自己添加约束
public extension UIView {
    @discardableResult
    func layoutWidth(_ constant: CGFloat) -> NSLayoutConstraint {
        return addConstraint(attribute: .width, constant: constant)
    }
    
    @discardableResult
    func layoutHeight(_ constant: CGFloat) -> NSLayoutConstraint {
        return addConstraint(attribute: .height, constant: constant)
    }
    
    @discardableResult
    func layoutWidth(min constant: CGFloat) -> NSLayoutConstraint {
        return addConstraint(attribute: .width, constant: constant, relatedBy: .greaterThanOrEqual)
    }
    
    @discardableResult
    func layoutHeight(min constant: CGFloat) -> NSLayoutConstraint {
        return addConstraint(attribute: .height, constant: constant, relatedBy: .greaterThanOrEqual)
    }
    
    @discardableResult
    func layoutWidth(max constant: CGFloat) -> NSLayoutConstraint {
        return addConstraint(attribute: .width, constant: constant, relatedBy: .lessThanOrEqual)
    }
    
    @discardableResult
    func layoutHeight(max constant: CGFloat) -> NSLayoutConstraint {
        return addConstraint(attribute: .height, constant: constant, relatedBy: .lessThanOrEqual)
    }
    
    @discardableResult
    func addConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return UIView.addConstraint(on: self, attribute: attribute, relatedBy: relatedBy, multiplier: multiplier, constant: constant, priority: priority)
    }
}

/// 和父控件相关约束
public extension UIView {
    func layoutEqualParent(inset: UIEdgeInsets) {
        layoutTopParent(inset.top)
        layoutLeftParent(inset.left)
        layoutBottomParent(inset.bottom)
        layoutRightParent(inset.right)
    }
    
    func layoutEqualParent(_ offset: CGFloat = 0) {
        layoutTopParent(offset)
        layoutLeftParent(offset)
        layoutBottomParent(offset)
        layoutRightParent(offset)
    }
    
    func layoutCenterParent(_ offset: CGPoint = .zero) {
        layoutCenterHorizontal(offset.x)
        layoutCenterVertical(offset.y)
    }
    
    @discardableResult
    func layoutCenterHorizontal(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWithParent(attribute: .centerX, constant: offset)
    }
    
    @discardableResult
    func layoutCenterVertical(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWithParent(attribute: .centerY, constant: offset)
    }
    
    @discardableResult
    func layoutTopParent(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWithParent(attribute: .top, constant: offset)
    }
    
    @discardableResult
    func layoutLeftParent(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWithParent(attribute: .left, constant: offset)
    }
    
    @discardableResult
    func layoutBottomParent(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWithParent(attribute: .bottom, constant: -offset)
    }
    
    @discardableResult
    func layoutRightParent(_ offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWithParent(attribute: .right, constant: -offset)
    }
    
    @discardableResult
    func addConstraintWithParent(attribute: NSLayoutConstraint.Attribute, constant: CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        guard let superview = superview else {
            return nil
        }
        
        return UIView.addConstraint(on: superview, item: self, attribute: attribute, relatedBy: relatedBy, toItem: superview, attribute: attribute, multiplier: multiplier, constant: constant, priority: priority)
    }
}

/// 和兄弟控件相关约束
public extension UIView {
    @discardableResult
    func layoutTop(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWith(view: view, attribute: .top, attribute: .top, constant: offset)
    }
    
    @discardableResult
    func layoutLeft(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWith(view: view, attribute: .left, attribute: .left, constant: offset)
    }
    
    @discardableResult
    func layoutBottom(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWith(view: view, attribute: .bottom, attribute: .bottom,  constant: offset)
    }
    
    @discardableResult
    func layoutRight(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWith(view: view, attribute: .right, attribute: .right, constant: offset)
    }
    
    @discardableResult
    func layoutHorizontal(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWith(view: view, attribute: .left, attribute: .right, constant: offset)
    }
    
    @discardableResult
    func layoutVertical(view: UIView, offset: CGFloat = 0) -> NSLayoutConstraint? {
        return addConstraintWith(view: view, attribute: .top, attribute: .bottom, constant: offset)
    }
    
    @discardableResult
    func addConstraintWith(view: UIView, attribute attribute1: NSLayoutConstraint.Attribute, attribute attribute2: NSLayoutConstraint.Attribute, constant: CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1, priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        guard let superview = superview else {
            return nil
        }
        
        return UIView.addConstraint(on: superview, item: self, attribute: attribute1, relatedBy: relatedBy, toItem: view, attribute: attribute2, multiplier: multiplier, constant: constant, priority: priority)
    }
}

public extension UIView {
    /// 给target添加约束
    @discardableResult
    class func addConstraint(on target: UIView, attribute: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        return UIView.addConstraint(on: target, item: target, attribute: attribute, relatedBy: relatedBy, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant, priority: priority)
    }
    
    /**
     0、translatesAutoresizingMaskIntoConstraints：
     The translatesAutoresizingMaskIntoConstraints property is set to NO, so our constraints will not conflict with the old “springs and struts” method.
     
     1、NSLayoutConstraint类，是IOS6引入的，字面意思是“约束”、“限制”的意思，实现相对布局，就依靠这个类了；
     
     2、怎么理解这个方法调用：
     NSLayoutConstraint *constraint = [NSLayoutConstraint
     constraintWithItem:firstButton        firstButton是我们实例化的按钮
     attribute:NSLayoutAttributeLeading    firstButton的左边
     relatedBy:NSLayoutRelationEqual       firstButton的左边与self.view的左边的相对关系
     toItem:self.view                      指定firstButton的相对的对象是self.view
     attribute:NSLayoutAttributeLeading    相对与self.view的左边（NSLayoutAttributeLeading是左边的意思）
     multiplier:1.0f                                       （后文介绍）
     constant:20.f];                       firstButton左边相对self.view左边，向右边偏移了20.0f (根据IOS坐标系，向右和向下是正数)
     [self.view addConstraint:constraint]; 将这个约束添加到self.view上
     
     附视图的属性和关系的值:
     typedef NS_ENUM(NSInteger, NSLayoutRelation) {
     NSLayoutRelationLessThanOrEqual = -1,          //小于等于
     NSLayoutRelationEqual = 0,                     //等于
     NSLayoutRelationGreaterThanOrEqual = 1,        //大于等于
     };
     
     typedef NS_ENUM(NSInteger, NSLayoutAttribute) {
     NSLayoutAttributeLeft = 1,                     //左侧
     NSLayoutAttributeRight,                        //右侧
     NSLayoutAttributeTop,                          //上方
     NSLayoutAttributeBottom,                       //下方
     NSLayoutAttributeLeading,                      //首部
     NSLayoutAttributeTrailing,                     //尾部
     NSLayoutAttributeWidth,                        //宽度
     NSLayoutAttributeHeight,                       //高度
     NSLayoutAttributeCenterX,                      //X轴中心
     NSLayoutAttributeCenterY,                      //Y轴中心
     NSLayoutAttributeBaseline,                     //文本底标线
     
     NSLayoutAttributeNotAnAttribute = 0            //没有属性
     };
     
     NSLayoutAttributeLeft/NSLayoutAttributeRight 和 NSLayoutAttributeLeading/NSLayoutAttributeTrailing的区别是left/right永远是指左右，
     而leading/trailing在某些从右至左习惯的地区会变成，leading是右边，trailing是左边。(大概是⊙﹏⊙b)
     */
    @discardableResult
    class func addConstraint(on target: UIView, item: Any, attribute attribute1: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation, toItem: Any?, attribute attribute2: NSLayoutConstraint.Attribute, multiplier: CGFloat, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        //		target.translatesAutoresizingMaskIntoConstraints = false
        //		(toItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        (item as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: item, attribute: attribute1, relatedBy: relatedBy, toItem: toItem, attribute: attribute2, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        target.addConstraint(constraint)
        return constraint
    }
}

// MARK: - Frame Sugar
public extension UIView {
    ///
    var x: CGFloat {
        get {
            return frame.origin.x
        } set(value) {
            frame = CGRect(x: value, y: y, width: w, height: h)
        }
    }
    
    ///
    var y: CGFloat {
        get {
            return frame.origin.y
        } set(value) {
            frame = CGRect(x: x, y: value, width: w, height: h)
        }
    }
    
    ///
    var w: CGFloat {
        get {
            return frame.size.width
        } set(value) {
            frame = CGRect(x: x, y: y, width: value, height: h)
        }
    }
    
    ///
    var h: CGFloat {
        get {
            return frame.size.height
        } set(value) {
            frame = CGRect(x: x, y: y, width: w, height: value)
        }
    }
    
    ///
    var width: CGFloat {
        get {
            return frame.size.width
        } set(value) {
            frame = CGRect(x: x, y: y, width: value, height: h)
        }
    }
    
    ///
    var height: CGFloat {
        get {
            return frame.size.height
        } set(value) {
            frame = CGRect(x: x, y: y, width: w, height: value)
        }
    }
    
    ///
    var left: CGFloat {
        get {
            return x
        } set(value) {
            x = value
        }
    }
    
    ///
    var right: CGFloat {
        get {
            return x + w
        } set(value) {
            x = value - w
        }
    }
    
    ///
    var top: CGFloat {
        get {
            return y
        } set(value) {
            y = value
        }
    }
    
    ///
    var bottom: CGFloat {
        get {
            return y + h
        } set(value) {
            y = value - h
        }
    }
    
    ///
    var origin: CGPoint {
        get {
            return frame.origin
        } set(value) {
            frame = CGRect(origin: value, size: frame.size)
        }
    }
    
    ///
    var centerX: CGFloat {
        get {
            return center.x
        } set(value) {
            center.x = value
        }
    }
    
    ///
    var centerY: CGFloat {
        get {
            return center.y
        } set(value) {
            center.y = value
        }
    }
    
    ///
    var size: CGSize {
        get {
            return frame.size
        } set(value) {
            frame = CGRect(origin: frame.origin, size: value)
        }
    }
}

// MARK: - IBInspectable
public extension UIView {
    /// Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.flatMap { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue.flatMap { $0.cgColor }
        }
    }
    
    /// Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    /// Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}

public extension UIView {
    
    //MARK: - Tap closure
    private struct AssociatedKeys {
        static var tapClosure = "tapClosure"
    }
    private var tapClosure: () -> Void {
        get {
            if let closure = objc_getAssociatedObject(self, &AssociatedKeys.tapClosure) as? () -> Void {
                return closure
            } else {
                return {}
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapClosure, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 添加单手指单击手势
    ///
    /// - Parameter closure: 回调
    func addSingleTap(_ closure: @escaping () -> Void) {
        addTap(touches: 1, taps: 1, closure)
    }
    
    /// 重新添加单击手势（主要用于cell重用时避免多次添加手势）
    ///
    /// - Parameter closure: 回调
    func reAddSingleTap(_ closure: @escaping () -> Void) {
        removeTapGestures()
        addSingleTap(closure)
    }
    
    /// 添加单手指双击手势
    ///
    /// - Parameter closure: 回调
    func addDoubleTap(_ closure: @escaping () -> Void) {
        addTap(touches: 1, taps: 2, closure)
    }
    
    /// 添加点击手势
    ///
    /// - Parameters:
    ///   - touches: 几根手指
    ///   - taps: 点击次数
    ///   - closure: 回调
    func addTap(touches: Int, taps: Int, _ closure: @escaping () -> Void) {
        isUserInteractionEnabled = true
        tapClosure = closure
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAction))
        tapGesture.numberOfTouchesRequired = touches
        tapGesture.numberOfTapsRequired = taps
        addGestureRecognizer(tapGesture)
    }
    
    /// 移除所有点击手势
    func removeTapGestures() {
        if self.gestureRecognizers != nil {
            for gesture in self.gestureRecognizers! {
                if gesture is UITapGestureRecognizer {
                    self.removeGestureRecognizer(gesture)
                }
            }
        }
    }
    
    /// 移除所有手势
    func removeAllGestures() {
        if self.gestureRecognizers != nil {
            for gesture in self.gestureRecognizers! {
                self.removeGestureRecognizer(gesture)
            }
        }
    }
    
    /// 触发点击回调
    ///
    /// - Parameter recognizer: 手势对象
    @objc private func handleAction(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == .recognized {
            tapClosure()
        }
    }
    
    func shakeBtn(delay: TimeInterval) {
        let top1 = CGAffineTransform.init(translationX: 0, y: 150)
        let reset = CGAffineTransform.identity
        //0 初始状态 下
        self.transform = top1
        self.alpha = 0.3
        
        /// 系统自带的弹簧效果
        /// usingSpringWithDamping 0~1 数值越小「弹簧」的振动效果越明显
        /// initialSpringVelocity 初始的速度，数值越大一开始移动越快
        UIView.animate(withDuration: 1.5, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options:.curveEaseOut , animations: {
            self.transform = reset
            self.alpha = 1
        }, completion: nil)
        return
    }
}












