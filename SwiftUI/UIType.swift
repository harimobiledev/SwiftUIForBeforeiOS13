//
//  UIType.swift
//  SwiftUI
//
//  Created by Hari on 20/09/19.
//  Copyright © 2019 Hari. All rights reserved.
//

import Foundation
import UIKit

enum Alignment
{
    case center
    case right
    case left
}

struct View {
    var type: UIType
    var content: Any?
    var alignment: Alignment = .center
}

struct HorizontalStack
{
    var viewsArray: [View]
    var spacing: Int
}

struct Text {
    var string: String
    var font: UIFont = .systemFont(ofSize: 17)
    var color: UIColor = .black
}

enum UIType
{
    case title
    case button
    case lineView
    case text
    case attributedText
    case image
    case stack
    case imageText
    case buttonText
    case guidePoint
    case buttons
//    case list
}

