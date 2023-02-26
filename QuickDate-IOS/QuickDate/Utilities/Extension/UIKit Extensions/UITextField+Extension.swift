

import UIKit
import Foundation

public extension UITextField {
    
    enum PaddingDirection {
        case left
        case right
    }
    
    func setPadding(padding: CGFloat, direction: PaddingDirection) {
        
        if direction == .left {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
            leftViewMode = .always
        } else {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
            rightViewMode = .always
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

