//
//  ELEXT.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/21.
//

import UIKit
import Foundation
import CommonCrypto

extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    func substring (start:Int, lenth:Int) -> String {
        guard start < count && lenth < count else { return "" }
        guard lenth > 0 && count - start - lenth >= 0 else { return "" }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: lenth)
        let substr = self[startIndex..<endIndex]
        return String(substr)
    }
}

extension UIColor {
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    convenience init(_ rgba:String) {
        var r:CGFloat = 0.0, g:CGFloat = 0.0, b:CGFloat = 0.0, a:CGFloat = 255.0
        if rgba.count >= 6 {
            if let rr = Int(rgba.substring(start: 0, lenth: 2), radix: 16) { r = CGFloat(rr) }
            if let gg = Int(rgba.substring(start: 2, lenth: 2), radix: 16) { g = CGFloat(gg) }
            if let bb = Int(rgba.substring(start: 4, lenth: 2), radix: 16) { b = CGFloat(bb) }
        }
        if rgba.count >= 8 {
            if let aa = Int(rgba.suffix(2), radix: 16) { a = CGFloat(aa) }
        }
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a / 255.0)
    }
}

extension UIView {
    func removeSubviews() {
        let subs = NSArray(array: subviews) as! [UIView]
        for sub in subs {
            sub.removeFromSuperview()
        }
    }
    
    var origin:CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }
    var size:CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
    var width:CGFloat {
        get {
            return frame.width
        }
        set {
            frame.size.width = newValue // = CGSize(width: width, height: frame.height)
        }
    }
    var height:CGFloat {
        get {
            return frame.height
        }
        set {
            frame.size.height = newValue// = CGSize(width: frame.height, height: height)
        }
    }
    var x:CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue// = CGPoint(x: x, y: frame.origin.y)
        }
    }
    var y:CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue// = CGPoint(x: frame.origin.x, y: y)
        }
    }
    var rx:CGFloat { // right X
        get {
            return frame.maxX
        }
        set {
            frame.origin.x = newValue - frame.width
        }
    }
    var by:CGFloat { //bottom Y
        get {
            return frame.maxY
        }
        set {
            frame.origin.y = newValue - frame.height
        }
    }
    var wx:CGFloat { // width X
        get {
            return frame.maxX
        }
        set {
            frame.size.width = newValue - frame.origin.x
        }
    }
    var hy:CGFloat { //height Y
        get {
            return frame.maxY
        }
        set {
            frame.size.height = newValue - frame.origin.y
        }
    }
    var midx:CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    var midy:CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }
    func setHCenter(inView:UIView) {
        center.x = inView.width/2
    }
    func setVCenter(inView:UIView) {
        center.y = inView.height/2
    }
    
    func setCornerBorder(color:UIColor, radius:CGFloat) {
        layer.borderWidth = 0.5
        layer.borderColor = color.cgColor
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    func setRadius(radius:CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}

extension UITextField {
    func setPlaceholder(string:String, color:UIColor) {
        let attrstr = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor:color, NSAttributedString.Key.font:(self.font)!])
        attributedPlaceholder = attrstr;
    }
}
