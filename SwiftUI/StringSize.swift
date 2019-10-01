//
//  StringSize.swift
//  SwiftUI
//
//  Created by Harikrishna Keerthipati on 29/03/18.
//

import Foundation
import UIKit
import CoreGraphics

extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    
    var estimatedWidth: CGFloat
    {
        let fontAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return size.width
    }
    
    func leftPadding(toLength: Int, withPad: String = " ") -> String {
        guard toLength > self.count else { return self }
        let padding = String(repeating: withPad, count: toLength - self.count)
        return padding + self
    }
    
    func rightPadding(toLength: Int, withPad: String = " ") -> String {
        guard toLength > self.count else {return self}
        let padding = String(repeating: withPad, count: toLength - self.count)
        return self + padding
    }
}
