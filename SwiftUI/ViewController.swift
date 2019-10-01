//
//  ViewController.swift
//  SwiftUI
//
//  Created by Hari on 20/09/19.
//  Copyright © 2019 Hari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let title = View(type: .title, content: "Hello Dhyana", alignment: .center)
        let lineView = View(type: .lineView, content: nil, alignment: .center)
        _ = View(type: .button, content: Button(type: .rectButton, imageName: nil, title: "Center", target: self, selector: #selector(buttonTapped)), alignment: .center)
        _ = View(type: .button, content: Button(type: .rectButton, imageName: nil, title: "Center", target: self, selector: #selector(buttonTapped)), alignment: .right)
        let attributedString = NSMutableAttributedString(string: "Congrats! You’ve graduated from being an Expert.\n\nConquer yourself with a goal of 21 mindful mins everyday and watch yourself change.", attributes: [
            .font: UIFont(name: "HelveticaNeue", size: 16.0)!,
            .foregroundColor: UIColor.black,
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 82, length: 15))
        let attributed = View(type: .attributedText, content: attributedString, alignment: .center)
        let text = View(type: .text, content: Text(string: "Try these quick troubleshooting steps  Try these quick troubleshooting", font: .italicSystemFont(ofSize: 16), color: .black) , alignment: .center)
        let one = View(type: .text, content: Text(string: "1", font: .boldSystemFont(ofSize: 20), color: .lightGray), alignment: .center)
        let image = View(type: .image, content: "beginner", alignment: .center)
        let horizontalStackOne = HorizontalStack(viewsArray: [image, text], spacing: 30)
        let horizontalStackTwo = HorizontalStack(viewsArray: [one, text], spacing: 30)
        let buttonOne = View(type: .button, content: Button(type: .imageButton, imageName: "beginner", title: nil, target: self, selector: #selector(buttonTapped)), alignment: .center)
        let buttonTwo = View(type: .button, content: Button(type: .imageButton, imageName: "beginner", title: nil, target: self, selector: #selector(buttonTapped)), alignment: .center)

        let horizontalStackThree = HorizontalStack(viewsArray: [buttonOne, buttonTwo], spacing: 30)
        let imageText = View(type: .imageText, content: horizontalStackOne, alignment: .center)
        let view2 = View(type: .guidePoint, content: horizontalStackTwo, alignment: .center)
        let buttons = View(type: .buttons, content: horizontalStackThree, alignment: .center)

        let popUpView = PopupView(frame: self.view.frame, content: [title, lineView, attributed, image, imageText, view2, buttons])
        popUpView.show(on: self.view)
    }
    
    @objc func buttonTapped()
    {
        print("button tapped")
    }
}

