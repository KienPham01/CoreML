//
//  RoudedShadowImageView.swift
//  vison-app-dev
//
//  Created by Kien on 12/11/18.
//  Copyright © 2018 Kien. All rights reserved.
//

import UIKit

class RoudedShadowImageView: UIImageView {

    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        self.layer.cornerRadius = self.frame.height / 2
    }
   

}

extension UIImage{
   func scaleImageTosize(image:UIImage,size:CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return scaleImage
    }
    
}
