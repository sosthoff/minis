//
//  UIImage+Voodoo.m
//  minis
//
//  Created by Sebastian Osthoff on 11/10/15.
//  Copyright © 2015 Sebastian Osthoff. All rights reserved.
//

#import "UIImage+Voodoo.h"

@implementation UIImage (Voodoo)

- (UIImage *)convertImageToGrayScale {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, 0, space, kCGImageAlphaNone);
    
    CGContextDrawImage(context, rect, [self CGImage]);
    CGImageRef ref = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:ref];
    
    CGColorSpaceRelease(space);
    CGContextRelease(context);
    CFRelease(ref);
    
    return newImage;
}


- (UIImage*) replaceColor:(UIColor*)color withTolerance:(float)tolerance {
    CGImageRef ref = [self CGImage];
    
    NSUInteger width = CGImageGetWidth(ref);
    NSUInteger height = CGImageGetHeight(ref);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, space,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(space);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), ref);
    
    CGColorRef cgColor = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    float r = components[0] * 255.0;
    float g = components[1] * 255.0;
    float b = components[2] * 255.0;
    
    const float redRange[2] = {
        MAX(r - (tolerance / 2.0), 0.0),
        MIN(r + (tolerance / 2.0), 255.0)
    };
    const float greenRange[2] = {
        MAX(g - (tolerance / 2.0), 0.0),
        MIN(g + (tolerance / 2.0), 255.0)
    };
    
    const float blueRange[2] = {
        MAX(b - (tolerance / 2.0), 0.0),
        MIN(b + (tolerance / 2.0), 255.0)
    };
    
    int byteIndex = 0;
    
    while (byteIndex < bitmapByteCount) {
        unsigned char red   = rawData[byteIndex];
        unsigned char green = rawData[byteIndex + 1];
        unsigned char blue  = rawData[byteIndex + 2];
        
        if (((red >= redRange[0]) && (red <= redRange[1])) &&
            ((green >= greenRange[0]) && (green <= greenRange[1])) &&
            ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {

            rawData[byteIndex] = 0;
            rawData[byteIndex + 1] = 0;
            rawData[byteIndex + 2] = 0;
            rawData[byteIndex + 3] = 0;
        }
        byteIndex += 4;
    }
    
    CGImageRef newref = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:newref];
    
    CGImageRelease(newref);
    CGContextRelease(context);
    free(rawData);
    
    return result;
}


- (UIImage*) replaceColorWithEdgeDetection:(UIColor*)color withTolerance:(float)tolerance {

    CGImageRef ref = [self CGImage];
    
    NSInteger width = CGImageGetWidth(ref);
    NSInteger height = CGImageGetHeight(ref);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bytesPerColumn = bytesPerPixel * height;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, space,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(space);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), ref);
    
    CGColorRef cgColor = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    float r = components[0] * 255.0;
    float g = components[1] * 255.0;
    float b = components[2] * 255.0;
    
    const float redRange[2] = {
        MAX(r - (tolerance / 2.0), 0.0),
        MIN(r + (tolerance / 2.0), 255.0)
    };
    const float greenRange[2] = {
        MAX(g - (tolerance / 2.0), 0.0),
        MIN(g + (tolerance / 2.0), 255.0)
    };
    
    const float blueRange[2] = {
        MAX(b - (tolerance / 2.0), 0.0),
        MIN(b + (tolerance / 2.0), 255.0)
    };
    
    for (NSInteger heightIndex = 0; heightIndex <= bytesPerColumn; heightIndex++) {
        
        NSUInteger detectedLeftEdge = 0;
        NSUInteger detectedRightEdge = 0;
        
        for (NSInteger widthLeftIndex = 0; widthLeftIndex <= width; ++widthLeftIndex) {
            
            NSInteger byteIndex = heightIndex * width + widthLeftIndex;
            unsigned char red   = rawData[byteIndex];
            unsigned char green = rawData[byteIndex + 1];
            unsigned char blue  = rawData[byteIndex + 2];
            
            if (detectedLeftEdge < 10 &&
                ((red >= redRange[0]) && (red <= redRange[1])) &&
                ((green >= greenRange[0]) && (green <= greenRange[1])) &&
                ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {
                
                detectedLeftEdge = 0;
                rawData[byteIndex] = 0;
                rawData[byteIndex + 1] = 0;
                rawData[byteIndex + 2] = 0;
                rawData[byteIndex + 3] = 0;
            } else {
                detectedLeftEdge++;
            }
        }
        for (NSInteger widthRightIndex = width-4; widthRightIndex >= 0; widthRightIndex-=4) {
            
            NSInteger byteIndex = heightIndex * width + widthRightIndex;
            
            unsigned char red   = rawData[byteIndex];
            unsigned char green = rawData[byteIndex + 1];
            unsigned char blue  = rawData[byteIndex + 2];
            
            if (detectedRightEdge < 10 &&
                ((red >= redRange[0]) && (red <= redRange[1])) &&
                ((green >= greenRange[0]) && (green <= greenRange[1])) &&
                ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {
                
                detectedRightEdge = 0;
                rawData[byteIndex] = 0;
                rawData[byteIndex + 1] = 0;
                rawData[byteIndex + 2] = 0;
                rawData[byteIndex + 3] = 0;
            } else {
                detectedRightEdge++;
            }
        }
    }
    
    CGImageRef newref = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:newref];
    
    CGImageRelease(newref);
    CGContextRelease(context);
    free(rawData);
    
    return result;
}

+ (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame {
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
