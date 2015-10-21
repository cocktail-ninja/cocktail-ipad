//
//  UIImage+Grayscale.swift
//  cocktail-assassin
//
//  Created by Sambya Aryasa on 2/2/15.
//  Copyright (c) 2015 tw. All rights reserved.
//
import UIKit
import CoreImage

extension UIImage {
    func toGrayscale(tintColor: UIColor) -> UIImage! {
        let filter = CIFilter(name: "CIColorMonochrome")
        
        filter!.setValue(CoreImage.CIImage(CGImage: self.CGImage!), forKey: kCIInputImageKey)
        filter!.setValue(CIColor(color: tintColor), forKey: kCIInputColorKey)

        let outputImage = filter!.outputImage
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(outputImage!, fromRect: outputImage!.extent)
        
        return UIImage(CGImage: cgImage)
    }
}
