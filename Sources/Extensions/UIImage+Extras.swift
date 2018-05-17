//
//  UIImage+Extras.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
    }

    func color(at point: CGPoint) -> UIColor? {
        guard let cgImage = cgImage,
            let cgImageData = cgImage.dataProvider?.data,
            let pixelData = CGDataProvider(data: cgImageData)?.data,
            let data = CFDataGetBytePtr(pixelData)
            else { return nil }

        let x = Int(point.x)
        let y = Int(point.y)
        let index = Int(size.width) * y + x
        let expectedLengthA = Int(size.width * size.height)
        let expectedLengthRGB = 3 * expectedLengthA
        let expectedLengthRGBA = 4 * expectedLengthA
        let byteLength = CFDataGetLength(pixelData)
        switch byteLength {
        case expectedLengthA:
            return UIColor(red: 0,
                           green: 0,
                           blue: 0,
                           alpha: CGFloat(data[index]) / 255.0)
        case expectedLengthRGB:
            return UIColor(red: CGFloat(data[3 * index]) / 255.0,
                           green: CGFloat(data[3 * index + 1]) / 255.0,
                           blue: CGFloat(data[3 * index + 2]) / 255.0,
                           alpha: 1.0)
        case expectedLengthRGBA:
            return UIColor(red: CGFloat(data[4 * index]) / 255.0,
                           green: CGFloat(data[4 * index + 1]) / 255.0,
                           blue: CGFloat(data[4 * index + 2]) / 255.0,
                           alpha: CGFloat(data[4 * index + 3]) / 255.0)
        default:
            return nil
        }
    }
}
