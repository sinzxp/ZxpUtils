//
//  ZXPImageUtils.swift
//  ZxpUtils
//
//  Created by quickplain on 2018/5/8.
//  Copyright © 2018年 quickplain. All rights reserved.
//

import UIKit

class ZXPImageUtils: NSObject {

}

extension UIImage {
    
    func scaleToSize(_ size:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func zipImage(_ scaleSize:CGFloat,percent: CGFloat) -> UIImage{
        UIGraphicsBeginImageContext(CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize))
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width * scaleSize, height:self.size.height * scaleSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //高保真压缩图片质量
        //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
        let imageData: Data = UIImageJPEGRepresentation(newImage, percent)!
        return UIImage(data: imageData)!
    }
    
}

extension UIImage {
    
    func compressImage(maxLength: Int) -> UIImage {
        let tempMaxLength: Int = maxLength / 8
        var compression: CGFloat = 1
        guard var data = UIImageJPEGRepresentation(self, compression), data.count > tempMaxLength else { return self }
        
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(self, compression)!
            if CGFloat(data.count) < CGFloat(tempMaxLength) * 0.9 {
                min = compression
            } else if data.count > tempMaxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < tempMaxLength { return resultImage }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > tempMaxLength && data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(tempMaxLength) / CGFloat(data.count)
            print("Ratio =", ratio)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)), height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = UIImageJPEGRepresentation(resultImage, compression)!
        }
        return resultImage
    }
}
    
extension UIImage {
    
    ///    a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
    ///    b,宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取值大的等比压缩至1280
    ///    c，宽或者高均大于1280，但是图片宽高比大于2，则宽或者高取值小的等比压缩至1280
    ///    **d, **宽或者高，只有一个值大于1280，并且宽高比超过2，不改变图片大小
    func resizeImage() -> UIImage {
        
        //prepare constants
        let width = self.size.width
        let height = self.size.height
        let scale = width/height
        
        var sizeChange = CGSize()
        
        if width <= 1280 && height <= 1280{ //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
            return self
        }else if width > 1280 || height > 1280 {//b,宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
            
            if scale <= 2 && scale >= 1 {
                let changedWidth:CGFloat = 1280
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if scale >= 0.5 && scale <= 1 {
                
                let changedheight:CGFloat = 1280
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if width > 1280 && height > 1280 {//宽以及高均大于1280，但是图片宽高比大于2时，则宽或者高取小的等比压缩至1280
                
                if scale > 2 {//高的值比较小
                    
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }else if scale < 0.5{//宽的值比较小
                    
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }
            }else {//d, 宽或者高，只有一个大于1280，并且宽高比超过2，不改变图片大小
                return self
            }
        }
        
        UIGraphicsBeginImageContext(sizeChange)
        
        //draw resized image on Context
        self.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height:sizeChange.height))
        
        //create UIImage
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return resizedImg
        
    }
    
    //图片压缩 1000kb以下的图片控制在100kb-200kb之间
    func compressImageSize() -> UIImage {
        let originalImgSize = UIImageJPEGRepresentation(self, 1)!.count
        var zipImageData:Data!
        if originalImgSize > 1500 {
            zipImageData = UIImageJPEGRepresentation(self,0.1)!
        }else if originalImgSize > 600 {
            zipImageData = UIImageJPEGRepresentation(self,0.2)!
        }else if originalImgSize > 400 {
            zipImageData = UIImageJPEGRepresentation(self,0.3)!
        }else if originalImgSize > 300 {
            zipImageData = UIImageJPEGRepresentation(self,0.4)!
        }else if originalImgSize > 200 {
            zipImageData = UIImageJPEGRepresentation(self,0.5)!
        }
        return UIImage(data: zipImageData)!
    }
    
}

