//
//  ImageHandler.swift
//  Art App
//
//  Created by Sachin Katyal on 6/28/19.
//  Copyright © 2019 Sachin Katyal. All rights reserved.
//

import Foundation
import CoreML
import UIKit

class ImageHandler {
    
    var model = DogsCats()
    
    var CATEGORIES: [String]!
    var index: Int!
    
    init(image: UIImage) {
        CATEGORIES = ["dog", "cat"]
        index = sceneLabel(forImage: image)?.output[0].intValue
    }
    
    func predict() -> String {
        return CATEGORIES[index!]
    }

    
    func sceneLabel(forImage image:UIImage) -> DogsCatsOutput? {
        if let pixelBuffer = ImageProcessor.buffer(from: image){
            guard let scene = try? DogsCats().prediction(image: pixelBuffer) else {
                fatalError("EAT SHIT")
            }
            //print(scene.output)
            return scene
        }
        return nil
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func resizeImageMaintingRatios(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
