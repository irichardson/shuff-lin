//
//  ImageHelper.swift
//  blocks
//
//  Created by Ian Richardson on 8/26/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation

class ImageHelper {

    class func imageScaledToSize(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}