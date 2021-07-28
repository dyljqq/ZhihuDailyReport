//
//  Image.swift
//  ZhihuDailyReport
//
//  Created by 季勤强 on 2021/7/28.
//  Copyright © 2021 dyljqq. All rights reserved.
//

import UIKit

func dawnsampledImage(data: Data, to size: CGSize, scale: CGFloat) -> UIImage? {
    
    let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    guard let imageSource = CGImageSourceCreateWithData(data as CFData, sourceOptions) else {
        return nil
    }
    
    let maxDimensionInPixel = max(size.width, size.height) * scale
    let downsampleOptions = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixel
    ] as CFDictionary
    
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
        return nil
    }
    
    return UIImage(cgImage: downsampledImage)
}
