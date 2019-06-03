//
//  UIView+Ext.swift
//  MottramTicket
//
//  Created by 中村　鷹祐 on 2019/06/02.
//  Copyright © 2019 中村　鷹祐. All rights reserved.
//

import UIKit
import RxCocoa

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var isCircle: Bool {
        get {
            return false
        }
        set {
            if newValue {
                let width = frame.size.width
                layer.cornerRadius = width / 2
                clipsToBounds = true
            }
        }
    }
    
    @IBInspectable var isUnderLine: Bool {
        get {
            return false
        }
        set {
            if newValue {
                let underLine = CALayer()
                let x: CGFloat = 30.0
                let width: CGFloat = frame.size.width - x
                underLine.frame = CGRect(x: x, y: frame.size.height, width: width, height: 1.0)
                underLine.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
                layer.addSublayer(underLine)
            }
        }
    }
    
    @IBInspectable var isSuperHidden: Bool {
        get {
            return false
        }
        set {
            if newValue {
                isHidden = true
            }
        }
    }
    
    @IBInspectable var isShadow: Bool  {
        get {
            return false
        }
        set {
            if newValue {
                layer.masksToBounds = false
                layer.shadowOpacity = 0.5
                layer.shadowRadius = 5
                layer.shadowColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
                layer.shadowOffset = CGSize(width: 5, height: 5)
            }
        }
    }
    
    var selfCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
    }
    
    func findFirstResponder(view: UIView? = nil) -> UIView? {
        
        let view = view ?? self
        
        if view.isFirstResponder {
            return view
        }
        
        for subview in view.subviews {
            if subview.isFirstResponder { return subview }
            
            if let responder = self.findFirstResponder(view: subview) {
                return responder
            }
            
        }
        return nil
    }
    
    func findSuperViewChain<T>(ofType: T.Type) -> T? {
        if let s = self.superview {
            switch s {
            case let s as T:
                return s
            default:
                return s.findSuperViewChain(ofType: ofType)
            }
        }
        return nil
    }
    
    func findSubViewChain<T>(_ classType: T.Type) -> T? {
        
        for view in subviews {
            
            if let v = view as? T {
                return v
            }
        }
        
        for view in subviews {
            
            if let v = view.findSubViewChain(T.self) {
                return v
            }
        }
        
        return nil
    }
    
    func setCornerRadiusOnly(radius: CGFloat, corners: UIRectCorner) {
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
        layer.mask = rectShape
    }
    
    static func createFromNib<T: UIView>(_ name: String, as: T.Type) -> T? {
        
        let nib = UINib(nibName: name, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil)[0] as? T
    }
}

extension UIView {
    
    func addAnchor(types: SelfAnchor...) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        for type in types {
            
            if case let SelfAnchor.aspectRatio(x: x, y: y) = type {
                
                setAspectRatioConstraint(x: x, y: y)
                continue
            }
            
            if let anchor = type.anchor(self) as? NSLayoutDimension {
                anchor.constraint(equalToConstant: type.constant).isActive = true
                continue
            }
        }
    }
    
    func addAnchor(to toView: UIView?, types: Anchor...) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        for type in types {
            
            if case let Anchor.aspectRatio(x: x, y: y) = type {
                
                setAspectRatioConstraint(x: x, y: y)
                continue
            }
            
            if let anchor = type.anchor(self) as? NSLayoutDimension {
                anchor.constraint(equalToConstant: type.constant).isActive = true
                continue
            }
            
            assert(hasCommonSuperView(toView: toView), "共通親ビューがありません")
            
            if  let toView = toView,
                let anchor = type.anchor(self) as? NSLayoutXAxisAnchor,
                let toAnchor = type.anchor(toView) as? NSLayoutXAxisAnchor {
                
                anchor.constraint(equalTo: toAnchor, constant: type.constant).isActive = true
            }
            
            if  let toView = toView,
                let anchor = type.anchor(self) as? NSLayoutYAxisAnchor,
                let toAnchor = type.anchor(toView) as? NSLayoutYAxisAnchor {
                
                anchor.constraint(equalTo: toAnchor, constant: type.constant).isActive = true
            }
            
        }
    }
    
    fileprivate func hasCommonSuperView(toView: UIView?) -> Bool {
        
        return commmonSuperView(toView: toView) != nil
    }
    
    fileprivate func commmonSuperView(toView: UIView?) -> UIView? {
        
        guard let toView = toView else { return nil }
        
        var superV: UIView? = self.superview
        
        while superV != nil {
            
            if superV == toView {
                return superV
            }
            superV = superV?.superview
        }
        
        superV = self.superview
        
        while superV != nil {
            
            var toSuperView = toView.superview
            
            while toSuperView != nil {
                
                if superV == toSuperView {
                    return superV
                }
                toSuperView = toSuperView?.superview
            }
            superV = superV?.superview
        }
        
        return nil
    }
    
    func setAspectRatioConstraint(x: CGFloat, y: CGFloat) {
        
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.width,
                                              multiplier: y / x,
                                              constant: 0))
    }
    
    enum Anchor {
        case top
        case bottom
        case left
        case right
        case centerX
        case centerY
        case leading
        case trailing
        case width(CGFloat)
        case height(CGFloat)
        
        case fromTop(CGFloat)
        case fromBottom(CGFloat)
        case fromLeft(CGFloat)
        case fromRight(CGFloat)
        case fromCenterX(CGFloat)
        case fromCneterY(CGFloat)
        case fromLeading(CGFloat)
        case fromTrailing(CGFloat)
        
        case aspectRatio(x: CGFloat, y: CGFloat)
        
        func anchor(_ view: UIView) -> Any {
            switch self {
            case .top:          return view.topAnchor
            case .bottom:       return view.bottomAnchor
            case .left:         return view.leftAnchor
            case .right:        return view.rightAnchor
            case .centerX:      return view.centerXAnchor
            case .centerY:      return view.centerYAnchor
            case .leading:      return view.leadingAnchor
            case .trailing:     return view.trailingAnchor
                
            case .fromTop:         return view.topAnchor
            case .fromBottom:      return view.bottomAnchor
            case .fromLeft:        return view.leftAnchor
            case .fromRight:       return view.rightAnchor
            case .fromCenterX:     return view.centerXAnchor
            case .fromCneterY:     return view.centerYAnchor
            case .fromLeading:     return view.leadingAnchor
            case .fromTrailing:    return view.trailingAnchor
                
            case .width:       return view.widthAnchor
            case .height:      return view.heightAnchor
                
            case .aspectRatio: return 0
            }
        }
        var constant: CGFloat {
            switch self {
            case let .fromTop(v):          return v
            case let .fromBottom(v):       return -v
            case let .fromLeft(v):         return v
            case let .fromRight(v):        return -v
            case let .fromCenterX(v):      return v
            case let .fromCneterY(v):      return v
            case let .fromLeading(v):      return v
            case let .fromTrailing(v):     return -v
            case let .width(v):        return v
            case let .height(v):       return v
            default:                    return 0
            }
        }
    }
    
    enum SelfAnchor {
        case width(CGFloat)
        case height(CGFloat)
        case aspectRatio(x: CGFloat, y: CGFloat)
        
        func anchor(_ view: UIView) -> Any {
            switch self {
            case .width:       return view.widthAnchor
            case .height:      return view.heightAnchor
            case .aspectRatio: return 0
            }
        }
        var constant: CGFloat {
            switch self {
            case let .width(v):        return v
            case let .height(v):       return v
            default:                    return 0
            }
        }
    }
}

// MARK: - Getting constraint
extension UIView {
    
    func getConstraint(_ type: ConstraintType) -> NSLayoutConstraint? {
        
        let constraints = getConstraints(type).filter({ !($0.identifier?.contains("hiding") ?? false) })
        assert(constraints.count < 2, "複数の制約があります。")
        return constraints.first
    }
    func getConstraints(_ type: ConstraintType) -> [NSLayoutConstraint] {
        
        guard let toItem = type.toItem else {
            // 相手がない制約の場合
            return constraints.filter({ type.isMatch($0) })
        }
        
        guard let commonSuperView = commmonSuperView(toView: toItem) else {
            return []
        }
        
        return commonSuperView.constraints.filter({ type.isMatch($0) })
    }
    
    enum ConstraintType {
        
        case top(toItem: UIView, toAncor: NSLayoutYAxisAnchor)
        case bottom(toItem: UIView, toAncor: NSLayoutYAxisAnchor)
        case left(toItem: UIView, toAncor: NSLayoutXAxisAnchor)
        case right(toItem: UIView, toAncor: NSLayoutXAxisAnchor)
        case leading(toItem: UIView, toAncor: NSLayoutXAxisAnchor)
        case trailing(toItem: UIView, toAncor: NSLayoutXAxisAnchor)
        case centerX(toItem: UIView, toAncor: NSLayoutXAxisAnchor)
        case centerY(toItem: UIView, toAncor: NSLayoutYAxisAnchor)
        case height
        case width
        
        var toItem: UIView? {
            
            switch self {
            case let .top(item, _): return item
            case let .bottom(item, _): return item
            case let .left(item, _): return item
            case let .right(item, _): return item
            case let .leading(item, _): return item
            case let .trailing(item, _): return item
            case let .centerX(item, _): return item
            case let .centerY(item, _): return item
            case .width, .height: return nil
            }
        }
        
        func isMatch(_ constraint: NSLayoutConstraint) -> Bool {
            
            guard let firstItem = constraint.firstItem as? UIView else { return false }
            
            switch self {
            case let .top(_, toAncor):
                return constraint.firstAnchor == firstItem.topAnchor && constraint.secondAnchor == toAncor
            case let .bottom(_, toAncor):
                return constraint.firstAnchor == firstItem.bottomAnchor && constraint.secondAnchor == toAncor
            case let .left(_, toAncor):
                return constraint.firstAnchor == firstItem.leftAnchor && constraint.secondAnchor == toAncor
            case let .right(_, toAncor):
                return constraint.firstAnchor == firstItem.rightAnchor && constraint.secondAnchor == toAncor
            case let .leading(_, toAncor):
                return constraint.firstAnchor == firstItem.leadingAnchor && constraint.secondAnchor == toAncor
            case let .trailing(_, toAncor):
                return constraint.firstAnchor == firstItem.trailingAnchor && constraint.secondAnchor == toAncor
            case let .centerX(_, toAncor):
                return constraint.firstAnchor == firstItem.centerXAnchor && constraint.secondAnchor == toAncor
            case let .centerY(_, toAncor):
                return constraint.firstAnchor == firstItem.centerYAnchor && constraint.secondAnchor == toAncor
            case .width:
                return constraint.firstAnchor == firstItem.widthAnchor
            case .height:
                return constraint.firstAnchor == firstItem.heightAnchor
            }
        }
    }
}
