//
//  UWButton.swift
//  United Way iOS
//
//  Created by Sharaf Nazaar on 3/3/20.
//  Copyright © 2020 United Way. All rights reserved.
//

import UIKit

@IBDesignable
class UWButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
        self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
