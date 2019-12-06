//
//  testButton.swift
//  A-Level Project
//
//  Created by Manley, Timothy (PRKB) on 03/12/2019.
//  Copyright © 2019 Manley, Timothy (NCWS). All rights reserved.
//

import Foundation
import UIKit

class newButton: UIButton {
    
    func setTwoImages(_ image: UIImage?, _ secondImage: UIImage?, for state: UIControl.State) {
        
        let combinedImage: UIImage = combineImages(first: image!, second: secondImage!)
        
        self.setImage(combinedImage, for: self.state)
    }
    
    func combineImages(first: UIImage, second: UIImage) -> UIImage {
        
        let imageSize: CGSize = CGSize(width: max(first.size.width, second.size.width), height: max(first.size.height, second.size.height))
        
        let rect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        let result = renderer.image { ctx in
            
            UIColor.white.set()
            ctx.fill(rect)
            
            second.draw(in: rect, blendMode: .normal, alpha: 1)
            first.draw(in: rect, blendMode: .luminosity, alpha: 1)
            
        }
        
        return result
        
    }
}


