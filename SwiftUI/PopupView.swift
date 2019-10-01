//
//  PopupView.swift
//  SwiftUI
//
//  Created by Hari on 20/09/19.
//  Copyright © 2019 Hari. All rights reserved.
//

import UIKit

enum ButtonType
{
    case imageButton
    case rectButton
    case plainTextButton
}

struct Button {
    var type: ButtonType
    var imageName: String?
    var title: String?
    var target: NSObject
    var selector: Selector
}

class PopupView: UIView {

    var alphaView: UIView!
    var backgroundView: UIView!

    var viewsArray: [View]!
    let stackView = UIStackView()
    var loadingFirstTime = true
    var backgroundHeightAnchor: NSLayoutConstraint!
    
    init(frame: CGRect, content: [View]) {
        super.init(frame: frame)
        self.viewsArray = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if loadingFirstTime
        {
            createAlphaView()
            setupStackView()
        }
    }
    
    func show(on view: UIView)
    {
        addConstraints(onView: view)
    }
    
    func addConstraints(onView: UIView)
    {
        onView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: onView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: onView.bottomAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: onView.rightAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: onView.leftAnchor).isActive = true
    }
    
    func createAlphaView()
    {
        let alphaView = UIView(frame: self.frame)
        alphaView.alpha = 0.3
        self.alphaView = alphaView
        self.addSubview(self.alphaView)
        self.alphaView.backgroundColor = .black
        self.alphaView.translatesAutoresizingMaskIntoConstraints = false
        self.alphaView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.alphaView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.alphaView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.alphaView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        
        self.backgroundView = UIView(frame: CGRect(x: 10, y: 10, width: self.frame.width - 20, height: 100))
        backgroundView.backgroundColor = .white
        self.addSubview(self.backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundHeightAnchor = backgroundView.heightAnchor.constraint(equalToConstant: 500)
        backgroundHeightAnchor.isActive = true
        backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.backgroundView.clipsToBounds = true
        self.backgroundView.layer.cornerRadius = 10
    }
    
    func setupStackView()
    {
        stackView.axis = .vertical
        stackView.alignment = .center // .Leading .FirstBaseline .Center .Trailing .LastBaseline
        stackView.distribution = .fill // .FillEqually .FillProportionally .EqualSpacing .EqualCentering
        stackView.spacing = 30
        self.backgroundView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.backgroundView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.backgroundView.centerYAnchor).isActive = true
        stackView.backgroundColor = .blue
        for view in viewsArray
        {
            switch view.type
            {
            case .title:
                let titleLabel = PopUpUIProvider.createTitle(with: view)
                stackView.addArrangedSubview(titleLabel)
            case .button:
                let button = createButton(with: view)
                stackView.addArrangedSubview(button)
            case .lineView:
                let lineView = PopUpUIProvider.createLineView(with: Int(self.backgroundView.frame.width))
                stackView.addArrangedSubview(lineView)
                lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
                lineView.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
                lineView.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
            case .text:
                let textLabel = PopUpUIProvider.createTextLabel(with: view)
                stackView.addArrangedSubview(textLabel)
                let width = (self.frame.width - 20) * 0.8
                let text = view.content as! Text
                textLabel.widthAnchor.constraint(equalTo: self.backgroundView.widthAnchor, multiplier: 0.8).isActive = true
                textLabel.heightAnchor.constraint(equalToConstant: text.string.height(withConstrainedWidth: width, font: textLabel.font)).isActive = true
            case .attributedText:
                let attributeTextLabel = PopUpUIProvider.createAttributedTextLabel(with: view)
                stackView.addArrangedSubview(attributeTextLabel)
                attributeTextLabel.widthAnchor.constraint(equalTo: self.backgroundView.widthAnchor).isActive = true
                attributeTextLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
            case .image:
                let imageView = PopUpUIProvider.createImage(with: view)
                stackView.addArrangedSubview(imageView)
            case .stack:
                let stack = view.content as! HorizontalStack
                let horizontalStackView = PopUpUIProvider.createHorizontalStack(with: stack, onView: self.backgroundView)
                stackView.addArrangedSubview(horizontalStackView)
            case .imageText:
                let stack = view.content as! HorizontalStack
                let horizontalStackView = PopUpUIProvider.createImageTextStackWith(stack: stack, on: self.backgroundView)
                stackView.addArrangedSubview(horizontalStackView)
            case .guidePoint:
                let stack = view.content as! HorizontalStack
                let horizontalStackView = PopUpUIProvider.createGuidePointStackWith(stack: stack, on: self.backgroundView)
                stackView.addArrangedSubview(horizontalStackView)
            case .buttons:
                let stack = view.content as! HorizontalStack
                let horizontalStackView = PopUpUIProvider.createButtonStackWith(stack: stack, on: self.backgroundView)
                stackView.addArrangedSubview(horizontalStackView)
            case .buttonText:
                print("some thing")
            }
        }
        loadingFirstTime = false
        let size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.backgroundHeightAnchor.constant = size.height + 50
    }
    
    func createButton(with view: View) -> UIButton
    {
        let content = view.content as! Button
        var button: UIButton!
        if content.type == .rectButton
        {
            button = PopUpUIProvider.createDhyanaButton(with: content.title)
            stackView.addArrangedSubview(button)

            button.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7).isActive = true
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        else if content.type == .plainTextButton
        {
            button = PopUpUIProvider.createPlainButton(with: content.title)
            stackView.addArrangedSubview(button)

            button.widthAnchor.constraint(equalTo: self.backgroundView.widthAnchor, multiplier: 0.7).isActive = true
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        else if content.type == .imageButton
        {
            button = PopUpUIProvider.createImageButton(with: content.imageName)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(content.target, action: content.selector, for: .touchUpInside)
        return button
    }
}

class PopUpUIProvider
{
    static func createTitle(with view: View) -> UILabel
    {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .green
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 17)
        label.text = view.content as? String
        return label
    }
    
    static func createTextLabel(with view: View) -> UILabel
    {
        let text = view.content as! Text
        let label = UILabel(frame: .zero)
        label.backgroundColor = .green
        label.textAlignment = .center
        label.textColor = text.color
        label.numberOfLines = 0
        label.font = text.font
        label.text = text.string
        return label
    }
    static func createAttributedTextLabel(with view: View) -> UILabel
    {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = view.content as? NSAttributedString
        label.attributedText = attributedText
        return label
    }
    
    static func createImage(with view: View) -> UIImageView
    {
        let imageView = UIImageView(frame: .zero)
        let image = UIImage(named: view.content as! String)
        imageView.image = image
        imageView.widthAnchor.constraint(equalToConstant: image!.size.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: image!.size.height).isActive = true
       // imageView.frame = CGRect(origin: CGPoint(x: 0, y: top), size: CGSize(width: image!.size.width, height: image!.size.height))
        return imageView
    }
    
    static func createDhyanaButton(with title: String?) -> UIButton
    {
        let dhyanaButton = UIButton(type: .custom)
        dhyanaButton.backgroundColor = .blue
        dhyanaButton.setTitle(title, for: .normal)
        return dhyanaButton
    }
    
    static func createPlainButton(with title: String?) -> UIButton
    {
        let dhyanaButton = UIButton(type: .custom)
        dhyanaButton.backgroundColor = .clear
        dhyanaButton.setTitle(title, for: .normal)
        return dhyanaButton
    }
    
    static func createImageButton(with imageName: String?) -> UIButton
    {
        let dhyanaButton = UIButton(type: .custom)
        dhyanaButton.backgroundColor = .clear
        let image = UIImage(named: imageName!)
        dhyanaButton.setImage(image, for: .normal)
        dhyanaButton.widthAnchor.constraint(equalToConstant: image!.size.width).isActive = true
        dhyanaButton.heightAnchor.constraint(equalToConstant: image!.size.height).isActive = true
      //  dhyanaButton.frame = CGRect(origin: .zero, size: CGSize(width: image!.size.width, height: image!.size.height))
        return dhyanaButton
    }
    
    static func createLineView(with width: Int) -> UIView{
        let lineView = UIView(frame: CGRect(x: 0, y: 50, width: width, height: 1))
        lineView.backgroundColor = .lightGray
        return lineView
    }
    
    static func createHorizontalStack(with horizontal: HorizontalStack, onView: UIView) -> UIStackView
    {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .equalCentering
        horizontalStack.spacing = CGFloat(horizontal.spacing)
      //  horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        for view in horizontal.viewsArray
        {
            if view.type == .button
            {
                let content = view.content as! Button
                let button = PopUpUIProvider.createImageButton(with: content.imageName!)
                horizontalStack.addArrangedSubview(button)
            }
            else if view.type == .image
            {
                let image = PopUpUIProvider.createImage(with: view)
                image.backgroundColor = .blue
                horizontalStack.addArrangedSubview(image)
            }
            else if view.type == .text
            {
                let titleLabel = PopUpUIProvider.createTextLabel(with: view)
//                titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//                titleLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
                horizontalStack.addArrangedSubview(titleLabel)
            }
        }
        return horizontalStack
    }
    
//    static func createImageTextStackWith(stack: HorizontalStack, on view: UIView) -> UIStackView
//    {
//        let imageName = stack.viewsArray[0]
//        let viewText = stack.viewsArray[1]
//        let text = viewText.content as! Text
//        let horizontalStack = UIStackView()
//        horizontalStack.axis = .horizontal
//        horizontalStack.alignment = .center
//        horizontalStack.distribution = .fill
//        horizontalStack.spacing = CGFloat(stack.spacing)
//
//        let imageView = PopUpUIProvider.createImage(with: imageName)
//        let textLabel = PopUpUIProvider.createTextLabel(with: viewText)
//        horizontalStack.addArrangedSubview(imageView)
//        horizontalStack.addArrangedSubview(textLabel)
//        let width = view.frame.width * 0.5
//        textLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
//        textLabel.heightAnchor.constraint(equalToConstant: text.string.height(withConstrainedWidth: width, font: text.font)).isActive = true
//
//        return horizontalStack
//    }
    
    static func createImageTextStackWith(stack: HorizontalStack, on view: UIView) -> UIStackView
    {
        let imageName = stack.viewsArray[0]
        let viewText = stack.viewsArray[1]
        let text = viewText.content as! Text
        let horizontalStack = createBasicHorizontalStackView()
        horizontalStack.spacing = CGFloat(stack.spacing)
        
        let imageView = PopUpUIProvider.createImage(with: imageName)
        let textLabel = PopUpUIProvider.createTextLabel(with: viewText)
        horizontalStack.addArrangedSubview(imageView)
        horizontalStack.addArrangedSubview(textLabel)
        let width = view.frame.width * 0.5
        textLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: text.string.height(withConstrainedWidth: width, font: text.font)).isActive = true
        
        return horizontalStack
    }
    
    static func createGuidePointStackWith(stack: HorizontalStack, on view: UIView) -> UIStackView
    {
        let pointText = stack.viewsArray[0]
        let viewText = stack.viewsArray[1]
        let text = viewText.content as! Text
        let horizontalStack = createBasicHorizontalStackView()
        horizontalStack.spacing = CGFloat(stack.spacing)
        
        let pointTextLabel = PopUpUIProvider.createTextLabel(with: pointText)
        let textLabel = PopUpUIProvider.createTextLabel(with: viewText)
        horizontalStack.addArrangedSubview(pointTextLabel)
        horizontalStack.addArrangedSubview(textLabel)
        let width = view.frame.width * 0.5
        pointTextLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        pointTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        textLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: text.string.height(withConstrainedWidth: width, font: text.font)).isActive = true
        
        return horizontalStack
    }
    
    static func createButtonStackWith(stack: HorizontalStack, on view: UIView) -> UIStackView
    {
        let horizontalStack = createBasicHorizontalStackView()
        horizontalStack.spacing = CGFloat(stack.spacing)
        for buttonView in stack.viewsArray
        {
            let button = buttonView.content as! Button
            let buttonView = PopUpUIProvider.createImageButton(with: button.imageName!)
            buttonView.addTarget(button.target, action: button.selector, for: .touchUpInside)
            horizontalStack.addArrangedSubview(buttonView)
        }
        return horizontalStack
    }
    
    static func createBasicHorizontalStackView() -> UIStackView
    {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        return horizontalStack
    }
}

