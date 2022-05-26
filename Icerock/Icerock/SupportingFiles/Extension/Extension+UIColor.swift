//
//  Extension+UIColor.swift
//  Icerock
//
//  Created by Максим Клочков on 13.05.2022.
//

import UIKit

extension UIColor {
    static let translucentWhite = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
    static let colorTwo = UIColor(red: 33/255, green: 38/255, blue: 45/255, alpha: 1)
    static let colorThree = UIColor(red: 88/255, green: 166/255, blue: 255/255, alpha: 0.5)
    static let colorFour = UIColor(red: 88/255, green: 166/255, blue: 255/255, alpha: 1)
    static let colorFive = UIColor(red: 13/255, green: 17/255, blue: 21/255, alpha: 1)
    static let colorSix = UIColor(red: 203/255, green: 79/255, blue: 79/255, alpha: 1)
    static let colorSeven = UIColor(red: 244/255, green: 266/255, blue: 100/255, alpha: 1)
    static let colorEight = UIColor(red: 63/255, green: 64/255, blue: 68/255, alpha: 1)
}

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
